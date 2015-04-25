/*
 * Container handling for all stream's handled by ffmpeg
 * konfetti 2010; based on code from crow
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

/* ***************************** */
/* Includes                      */
/* ***************************** */

#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <memory.h>
#include <string.h>

#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/poll.h>
#include <pthread.h>
#include <sys/prctl.h>

#include <libavutil/avutil.h>
#include <libavutil/time.h>
#include <libavformat/avformat.h>
#include <libswresample/swresample.h>
#include <libavutil/opt.h>

#include "common.h"
#include "misc.h"
#include "debug.h"
#include "aac.h"
#include "pcm.h"
#include "ffmpeg_metadata.h"
#include "subtitle.h"

/* ***************************** */
/* Makros/Constants              */
/* ***************************** */

//for buffered io
#define FILLBUFSIZE 0
#define FILLBUFDIFF 1048576
#define FILLBUFPAKET 5120
#define FILLBUFSEEKTIME 3 //sec

static int ffmpeg_buf_size = FILLBUFSIZE + FILLBUFDIFF;
static ffmpeg_buf_seek_time = FILLBUFSEEKTIME;
static int(*ffmpeg_read_org)(void *opaque, uint8_t *buf, int buf_size) = NULL;
static int64_t(*ffmpeg_seek_org)(void *opaque, int64_t offset, int whence) = NULL;
static unsigned char* ffmpeg_buf_read = NULL;
static unsigned char* ffmpeg_buf_write = NULL;
static unsigned char* ffmpeg_buf = NULL;
static pthread_t fillerThread;
static int hasfillerThreadStarted[10] = {0,0,0,0,0,0,0,0,0,0};
int hasfillerThreadStartedID = 0;
static pthread_mutex_t fillermutex;
static int ffmpeg_buf_valid_size = 0;
static int ffmpeg_do_seek_ret = 0;
static int ffmpeg_do_seek = 0;
static int ffmpeg_buf_stop = 0;
//for buffered io (end)

#define MAX_AUDIO_FRAME_SIZE 192000

#define FFMPEG_DEBUG

#ifdef FFMPEG_DEBUG

static short debug_level = 10;

#define ffmpeg_printf(level, fmt, x...) do { \
if (debug_level >= level) printf("[%s:%s] " fmt, FILENAME, __FUNCTION__, ## x); } while (0)
#else
#define ffmpeg_printf(level, fmt, x...)
#endif

#ifndef FFMPEG_SILENT
#define ffmpeg_err(fmt, x...) do { printf("[%s:%s] " fmt, FILENAME, __FUNCTION__, ## x); } while (0)
#else
#define ffmpeg_err(fmt, x...)
#endif

/* Error Constants */
#define cERR_CONTAINER_FFMPEG_NO_ERROR        0
#define cERR_CONTAINER_FFMPEG_INIT           -1
#define cERR_CONTAINER_FFMPEG_NOT_SUPPORTED  -2
#define cERR_CONTAINER_FFMPEG_INVALID_FILE   -3
#define cERR_CONTAINER_FFMPEG_RUNNING        -4
#define cERR_CONTAINER_FFMPEG_NOMEM          -5
#define cERR_CONTAINER_FFMPEG_OPEN           -6
#define cERR_CONTAINER_FFMPEG_STREAM         -7
#define cERR_CONTAINER_FFMPEG_NULL           -8
#define cERR_CONTAINER_FFMPEG_ERR            -9
#define cERR_CONTAINER_FFMPEG_END_OF_FILE    -10

static const char* FILENAME = __FILE__;

/* ***************************** */
/* Types                         */
/* ***************************** */

/* ***************************** */
/* Varaibles                     */
/* ***************************** */

static pthread_mutex_t mutex;

static pthread_t PlayThread;
static int hasPlayThreadStarted = 0;

static AVFormatContext*   avContext = NULL;
static AVDictionary *avio_opts = NULL;

static unsigned char isContainerRunning = 0;

static long long int latestPts = 0;

static int restart_audio_resampling = 0;
static off_t seek_target_bytes = 0;
static int do_seek_target_bytes = 0;
static float seek_target_seconds = 0.0;
static int do_seek_target_seconds = 0;
static int seek_target_flag = 0;

/* ***************************** */
/* Prototypes                    */
/* ***************************** */
static int container_ffmpeg_seek_bytes(off_t pos);
//static int container_ffmpeg_seek(Context_t *context, float sec);
static int container_ffmpeg_seek(Context_t *context, float sec, int absolute);
static int container_ffmpeg_seek_rel(Context_t *context, off_t pos, long long int pts, float sec);
static int container_ffmpeg_seek_bytes_rel(off_t start, off_t bytes);

/* ***************************** */
/* MISC Functions                */
/* ***************************** */

struct splitstr
{
	char* part;
};

struct splitstr* strsplit(char *str, char *tok, int* count)
{
	char *tmpstr = NULL;
	struct splitstr *array = NULL, *tmparray = NULL;
	*count = 0;

	if(str == NULL || tok == NULL)
		return NULL;

	tmpstr = strtok(str, tok);
	while(tmpstr != NULL)
	{
		*count = *count + 1;
		tmparray = array; array = (struct splitstr*)realloc(array, sizeof(struct splitstr*) * (*count));
		if(array == NULL)
		{
//			err("no mem");
			free(tmparray);
			return NULL;
		}
		
		(&array[(*count) - 1])->part = tmpstr;
		tmpstr = strtok(NULL, tok);
	}

	return array;
}

char* ostrcat(char* value1, char* value2, int free1, int free2)
{
	int len = 0, len1 = 0, len2 = 0;
	char* buf = NULL;

	if(value1 == NULL && value2 == NULL) return NULL;

	if(value1 != NULL) len1 = strlen(value1);
	if(value2 != NULL) len2 = strlen(value2);

	len = len1 + len2 + 1;

	if(free1 == 1)
		buf = realloc(value1, len);
	else
		buf = malloc(len);
	if(buf == NULL)
	{
		if(free1 == 1) free(value1);
		if(free2 == 1) free(value2);
		return NULL;
	}

	if(free1 == 0 && len1 > 0) memcpy(buf, value1, len1);
	if(len2 > 0) memcpy(buf + len1, value2, len2);
	buf[len - 1] = '\0';

	if(free2 == 1) free(value2);

	//helpfull for memleak detect
	//if(buf != NULL && strlen(buf) == 0x0b - 0x01)
	//	printf("******** memleak string (%s) (%p) ********\n", buf, buf);

	return buf;
}

char* ostrstr(char* str, char* search)
{
	char* ret = NULL;

	if(str == NULL || search == NULL) return NULL;
	ret = strstr(str, search);

	return ret;
}

char* string_replace(char *search, char *replace, char *string, int free1)
{
	char* searchpos = NULL;
	char* tmpstr = NULL;

	if(string == NULL || search == NULL)
	{
		tmpstr = ostrcat(tmpstr, string, 1, 0);
		if(free1 == 1) free(string);
		return tmpstr;
	}

	searchpos = ostrstr(string, search);

	if(searchpos == NULL)
	{
		tmpstr = ostrcat(tmpstr, string, 1, 0);
		if(free1 == 1) free(string);
		return tmpstr;
	}

	tmpstr = strndup(string, searchpos - string);
	if(replace != NULL)
		tmpstr = ostrcat(tmpstr, replace, 1, 0);
	tmpstr = ostrcat(tmpstr, string + (searchpos - string) + strlen(search), 1, 0);

	if(free1 == 1) free(string);

	return tmpstr;
}

static int mutexInitialized = 0;

static void initMutex(void)
{
    pthread_mutex_init(&mutex, NULL);
    mutexInitialized = 1;
}

static void getMutex(const char *filename __attribute__((unused)), const char *function __attribute__((unused)), int line) {
    ffmpeg_printf(100, "::%d requesting mutex\n", line);

    if (!mutexInitialized)
	initMutex();

    pthread_mutex_lock(&mutex);

    ffmpeg_printf(100, "::%d received mutex\n", line);
}

static void releaseMutex(const char *filename __attribute__((unused)), const const char *function __attribute__((unused)), int line) {
    pthread_mutex_unlock(&mutex);

    ffmpeg_printf(100, "::%d released mutex\n", line);
}

//for buffered io
void getfillerMutex(const char *filename, const char *function, int line) {
    ffmpeg_printf(100, "::%d requesting mutex\n", line);

    pthread_mutex_lock(&fillermutex);

    ffmpeg_printf(100, "::%d received mutex\n", line);
}

void releasefillerMutex(const char *filename, const const char *function, int line) {
    pthread_mutex_unlock(&fillermutex);

    ffmpeg_printf(100, "::%d released mutex\n", line);
}
//for buffered io (end)encoding

static char* Codec2Encoding(AVCodecContext *codec, int* version)
{
    fprintf(stderr, "Codec ID: %ld (%.8lx)\n", (long)codec->codec_id, (long)codec->codec_id);
    switch (codec->codec_id)
    {
    case AV_CODEC_ID_MPEG1VIDEO:
        return "V_MPEG1";
    case AV_CODEC_ID_MPEG2VIDEO:
        return "V_MPEG1";
    case AV_CODEC_ID_H263:
    case AV_CODEC_ID_H263P:
    case AV_CODEC_ID_H263I:
        return "V_H263";
    case AV_CODEC_ID_FLV1:
        return "V_FLV";
    case AV_CODEC_ID_VP5:
    case AV_CODEC_ID_VP6:
    case AV_CODEC_ID_VP6F:
        return "V_VP6";
    case AV_CODEC_ID_RV10:
    case AV_CODEC_ID_RV20:
        return "V_RMV";
    case AV_CODEC_ID_MPEG4:
#if LIBAVCODEC_VERSION_MAJOR < 53
    case AV_CODEC_ID_XVID:
#endif
    case AV_CODEC_ID_MSMPEG4V1:
    case AV_CODEC_ID_MSMPEG4V2:
    case AV_CODEC_ID_MSMPEG4V3:
        return "V_MSCOMP";
    case AV_CODEC_ID_WMV1:
        *version = 1;
        return "V_WMV";
    case AV_CODEC_ID_WMV2:
        *version = 2;
        return "V_WMV";
    case AV_CODEC_ID_WMV3:
        *version = 3;
        return "V_WMV";
    case AV_CODEC_ID_VC1:
        return "V_VC1";
    case AV_CODEC_ID_H264:
#if LIBAVCODEC_VERSION_MAJOR < 54
    case AV_CODEC_ID_FFH264:
#endif
        return "V_MPEG4/ISO/AVC";
    case AV_CODEC_ID_AVS:
        return "V_AVS";
    case AV_CODEC_ID_MP2:
        return "A_MPEG/L3";
    case AV_CODEC_ID_MP3:
        return "A_MP3";
    case AV_CODEC_ID_AAC:
        return "A_IPCM";
    case AV_CODEC_ID_AC3:
        return "A_AC3";
    case AV_CODEC_ID_DTS:
        return "A_DTS";
    case AV_CODEC_ID_WMAV1:
    case AV_CODEC_ID_WMAV2:
    case 86056:
    case AV_CODEC_ID_WMAPRO:
        return "A_IPCM";
    case AV_CODEC_ID_MLP:
        return "A_MLP";
    case AV_CODEC_ID_RA_144:
        return "A_IPCM";
    case AV_CODEC_ID_RA_288:
        return "A_IPCM";
    case AV_CODEC_ID_VORBIS:
        return "A_IPCM";
    case AV_CODEC_ID_FLAC:
        return "A_IPCM";
    case AV_CODEC_ID_PCM_S16LE:
	return "A_IPCM";
/* subtitle */
    case AV_CODEC_ID_SSA:
        return "S_TEXT/ASS"; /* Hellmaster1024: seems to be ASS instead of SSA */
    case AV_CODEC_ID_TEXT: /* Hellmaster1024: i dont have most of this, but lets hope it is normal text :-) */
    case AV_CODEC_ID_DVD_SUBTITLE:
    case AV_CODEC_ID_DVB_SUBTITLE:
    case AV_CODEC_ID_XSUB:
    case AV_CODEC_ID_MOV_TEXT:
    case AV_CODEC_ID_HDMV_PGS_SUBTITLE:
    case AV_CODEC_ID_DVB_TELETEXT:
//    case CODEC_ID_DVB_TELETEXT:
//        return "S_TEXT/SRT"; /* fixme */
    case AV_CODEC_ID_SRT:
        return "S_TEXT/SRT"; /* fixme */
    default:
	// Default to injected-pcm for unhandled audio types.
	if (codec->codec_type == AVMEDIA_TYPE_AUDIO)
		return "A_IPCM";
	if (codec->codec_type == AVMEDIA_TYPE_SUBTITLE)
		return "S_TEXT/SRT";
    	ffmpeg_err("Codec ID %ld (%.8lx) not found\n", (long)codec->codec_id, (long)codec->codec_id);
    }
    return NULL;
}

long long int calcPts(AVStream* stream, int64_t pts)
{
    if (!stream)
    {
        ffmpeg_err("stream / packet null\n");
        return INVALID_PTS_VALUE;
    }

    if(pts == AV_NOPTS_VALUE)
        pts = INVALID_PTS_VALUE;
    else if (avContext->start_time == AV_NOPTS_VALUE)
        pts = 90000.0 * (double)pts * av_q2d(stream->time_base);
    else
        pts = 90000.0 * (double)pts * av_q2d(stream->time_base) - 90000.0 * avContext->start_time / AV_TIME_BASE;

    if (pts & 0x8000000000000000ull)
        pts = INVALID_PTS_VALUE;

    return pts;
}

/*Hellmaster1024: get the Duration of the subtitle from the SSA line*/
float getDurationFromSSALine(unsigned char* line){
    int i,h,m,s,ms;
    char* Text = strdup((char*) line);
    char* ptr1;
    char* ptr[10];
    long int msec;

    ptr1 = Text;
    ptr[0]=Text;
    for (i=0; i < 3 && *ptr1 != '\0'; ptr1++) {
        if (*ptr1 == ',') {
            ptr[++i]=ptr1+1;
            *ptr1 = '\0';
        }
    }

    sscanf(ptr[2],"%d:%d:%d.%d",&h,&m,&s,&ms);
    msec = (ms*10) + (s*1000) + (m*60*1000) + (h*24*60*1000);
    sscanf(ptr[1],"%d:%d:%d.%d",&h,&m,&s,&ms);
    msec -= (ms*10) + (s*1000) + (m*60*1000) + (h*24*60*1000);

    ffmpeg_printf(10, "%s %s %f\n", ptr[2], ptr[1], (float) msec / 1000.0);

    free(Text);
    return (float)msec/1000.0;
}

/* search for metatdata in context and stream
 * and map it to our metadata.
 */

#if LIBAVCODEC_VERSION_MAJOR < 54
static char* searchMeta(AVMetadata *metadata, char* ourTag)
#else
static char* searchMeta(AVDictionary * metadata, char* ourTag)
#endif
{
#if LIBAVCODEC_VERSION_MAJOR < 54
   AVMetadataTag *tag = NULL;
#else
   AVDictionaryEntry *tag = NULL;
#endif
   int i = 0;

   while (metadata_map[i] != NULL)
   {
      if (strcmp(ourTag, metadata_map[i]) == 0)
      {
#if LIBAVCODEC_VERSION_MAJOR < 54
          while ((tag = av_metadata_get(metadata, "", tag, AV_METADATA_IGNORE_SUFFIX)))
#else
          while ((tag = av_dict_get(metadata, "", tag, AV_DICT_IGNORE_SUFFIX)))
#endif
          {
              if (strcmp(tag->key, metadata_map[ i + 1 ]) == 0)
              {
                  return tag->value;
              }
          }
      }
      i++;
   }

   return NULL;
}

/* **************************** */
/* Worker Thread                */
/* **************************** */

static void FFMPEGThread(Context_t *context) {
    char threadname[17];
    strncpy(threadname, __func__, sizeof(threadname));
    threadname[16] = 0;
    prctl (PR_SET_NAME, (unsigned long)&threadname);
    AVPacket   packet;
    off_t lastSeek = -1;
    long long int lastPts = -1, currentVideoPts = -1, currentAudioPts = -1, showtime = 0, bofcount = 0;
    int           err = 0;
    AudioVideoOut_t avOut;

    SwrContext *swr = NULL;
    AVFrame *decoded_frame = NULL;
    int out_sample_rate = 44100;
    int out_channels = 2;
    uint64_t out_channel_layout = AV_CH_LAYOUT_STEREO;

    ffmpeg_printf(10, "\n");

    while ( context->playback->isCreationPhase )
    {
        ffmpeg_err("Thread waiting for end of init phase...\n");
        usleep(1000);
    }
    ffmpeg_printf(10, "Running!\n");

    while ( context && context->playback && context->playback->isPlaying ) {

        //IF MOVIE IS PAUSED, WAIT
        if (context->playback->isPaused) {
            ffmpeg_printf(20, "paused\n");

            usleep(100000);
            continue;
        }

        if (context->playback->isSeeking) {
            ffmpeg_printf(10, "seeking\n");

            usleep(100000);
            continue;
        }

	getMutex(FILENAME, __FUNCTION__,__LINE__);

	if (!context->playback || !context->playback->isPlaying) {
    		releaseMutex(FILENAME, __FUNCTION__,__LINE__);
		continue;
	}

	if (context->playback->BackWard && av_gettime() >= showtime)
	{
	      context->output->Command(context, OUTPUT_CLEAR, "video");

	      if(bofcount == 1)
	      {
		  showtime = av_gettime();
		  usleep(100000);
		  continue;
	      }

	      if(lastPts == -1)
	      {
		  if(currentVideoPts != -1)
		      lastPts = currentVideoPts;
		  else
		      lastPts = currentAudioPts;
	      }

	      if((err = container_ffmpeg_seek_rel(context, lastSeek, lastPts, (float) context->playback->Speed)) < 0)
	      {
		  ffmpeg_err( "Error seeking\n");

		  if (err == cERR_CONTAINER_FFMPEG_END_OF_FILE)
		  {
		      bofcount = 1;
		  }
	      }
	}

	if (do_seek_target_seconds || do_seek_target_bytes) {
		if (do_seek_target_seconds) {
			float seek_target_seconds_min = seek_target_seconds - 15 * AV_TIME_BASE;
		
			avformat_seek_file(avContext, -1, seek_target_seconds_min, seek_target_seconds, INT64_MAX, seek_target_flag);
		} else
			container_ffmpeg_seek_bytes(seek_target_bytes);
		do_seek_target_seconds = do_seek_target_bytes = 0;
		restart_audio_resampling = 1;
		latestPts = 0;
		seek_target_flag = 0;

		// flush streams
		unsigned int i;
		for (i = 0; i < avContext->nb_streams; i++)
			if (avContext->streams[i]->codec && avContext->streams[i]->codec->codec)
				avcodec_flush_buffers(avContext->streams[i]->codec);
	}

	if (context->playback->BackWard) {
	      lastPts = lastPts + (context->playback->Speed * 90000);
	      showtime = av_gettime() + 300000; //jump back all 300ms
	      context->output->Command(context, OUTPUT_AUDIOMUTE, "0");
	}

	if (av_read_frame(avContext, &packet) == 0 )
	{
	    long long int pts;
	    Track_t * videoTrack = NULL;
	    Track_t * audioTrack = NULL;
	    Track_t * subtitleTrack = NULL;
	    Track_t * dvbsubtitleTrack = NULL;
	    Track_t * teletextTrack = NULL;

	    int pid = avContext->streams[packet.stream_index]->id;

	    if (context->manager->video->Command(context, MANAGER_GET_TRACK, &videoTrack) < 0)
		ffmpeg_err("error getting video track\n");

	    if (context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack) < 0)
		ffmpeg_err("error getting audio track\n");

	    if (context->manager->subtitle->Command(context, MANAGER_GET_TRACK, &subtitleTrack) < 0)
		ffmpeg_err("error getting subtitle track\n");

	    if (context->manager->dvbsubtitle->Command(context, MANAGER_GET_TRACK, &dvbsubtitleTrack) < 0)
		ffmpeg_err("error getting dvb subtitle track\n");

	    if (context->manager->teletext->Command(context, MANAGER_GET_TRACK, &teletextTrack) < 0)
		ffmpeg_err("error getting teletext track\n");

	    ffmpeg_printf(200, "packet.size %d - index %d\n", packet.size, pid);

	    if (videoTrack && (videoTrack->Id == pid)) {
		    currentVideoPts = videoTrack->pts = pts = calcPts(videoTrack->stream, packet.pts);

		    if ((currentVideoPts > latestPts) && (currentVideoPts != INVALID_PTS_VALUE))
			latestPts = currentVideoPts;

		    ffmpeg_printf(200, "VideoTrack index = %d %lld\n",pid, currentVideoPts);

		    avOut.data       = packet.data;
		    avOut.len        = packet.size;
		    avOut.pts        = pts;
		    avOut.extradata  = videoTrack->extraData;
		    avOut.extralen   = videoTrack->extraSize;
		    avOut.frameRate  = videoTrack->frame_rate;
		    avOut.timeScale  = videoTrack->TimeScale;
		    avOut.width      = videoTrack->width;
		    avOut.height     = videoTrack->height;
		    avOut.type       = "video";

		    if (context->output->video->Write(context, &avOut) < 0) {
			ffmpeg_err("writing data to video device failed\n");
		    }
	    } else if (audioTrack && (audioTrack->Id == pid)) {
		    currentAudioPts = audioTrack->pts = pts = calcPts(audioTrack->stream, packet.pts);

		    if ((currentAudioPts > latestPts) && (!videoTrack))
			latestPts = currentAudioPts;

		    ffmpeg_printf(200, "AudioTrack index = %d\n",pid);
                    if (audioTrack->inject_raw_pcm == 1){
                        ffmpeg_printf(200,"write audio raw pcm\n");

                        pcmPrivateData_t extradata;
                        extradata.uNoOfChannels = ((AVStream*) audioTrack->stream)->codec->channels;
                        extradata.uSampleRate = ((AVStream*) audioTrack->stream)->codec->sample_rate;
                        extradata.uBitsPerSample = 16;
                        extradata.bLittleEndian = 1;

                        avOut.data       = packet.data;
                        avOut.len        = packet.size;
                        avOut.pts        = pts;
                        avOut.extradata  = (unsigned char *) &extradata;
                        avOut.extralen   = sizeof(extradata);
                        avOut.frameRate  = 0;
                        avOut.timeScale  = 0;
                        avOut.width      = 0;
                        avOut.height     = 0;
                        avOut.type       = "audio";

                        if (!context->playback->BackWard && context->output->audio->Write(context, &avOut) < 0)
                        {
                            ffmpeg_err("(raw pcm) writing data to audio device failed\n");
                        }
                    }
                    else if (audioTrack->inject_as_pcm == 1)
		    {
			AVCodecContext *c = ((AVStream*)(audioTrack->stream))->codec;

			if (restart_audio_resampling) {
				restart_audio_resampling = 0;
				if (swr) {
					swr_free(&swr);
					swr = NULL;
				}
				if (decoded_frame) {
					avcodec_free_frame(&decoded_frame);
					decoded_frame = NULL;
				}
				context->output->Command(context, OUTPUT_CLEAR, NULL);
				context->output->Command(context, OUTPUT_PLAY, NULL);
			}

			while(packet.size > 0)
			{
				int got_frame = 0;
				if (!decoded_frame) {
					if (!(decoded_frame = avcodec_alloc_frame())) {
						fprintf(stderr, "out of memory\n");
						exit(1);
					}
				} else
					avcodec_get_frame_defaults(decoded_frame);

				int len = avcodec_decode_audio4(c, decoded_frame, &got_frame, &packet);
				if (len < 0) {
//					fprintf(stderr, "avcodec_decode_audio4: %d\n", len);
					break;
				}

				packet.data += len;
				packet.size -= len;
				
				if (!got_frame)
					continue;

				int e;
				if (!swr) {
					int rates[] = { 48000, 96000, 192000, 44100, 88200, 176400, 0 };
					int *rate = rates;
					int in_rate = c->sample_rate;
					while (*rate && ((*rate / in_rate) * in_rate != *rate) && (in_rate / *rate) * *rate != in_rate)
						rate++;
					out_sample_rate = *rate ? *rate : 44100;
					swr = swr_alloc();
					out_channels = c->channels;
					if (c->channel_layout == 0) {
						// FIXME -- need to guess, looks pretty much like a bug in the FFMPEG WMA decoder
						c->channel_layout = AV_CH_LAYOUT_STEREO;
					}

					out_channel_layout = c->channel_layout;
					// player2 won't play mono
					if (out_channel_layout == AV_CH_LAYOUT_MONO) {
						out_channel_layout = AV_CH_LAYOUT_STEREO;
						out_channels = 2;
					}

					av_opt_set_int(swr, "in_channel_layout",	c->channel_layout,	0);
					av_opt_set_int(swr, "out_channel_layout",	out_channel_layout,	0);
					av_opt_set_int(swr, "in_sample_rate",		c->sample_rate,		0);
					av_opt_set_int(swr, "out_sample_rate",		out_sample_rate,	0);
					av_opt_set_int(swr, "in_sample_fmt",		c->sample_fmt,		0);
					av_opt_set_int(swr, "out_sample_fmt",		AV_SAMPLE_FMT_S16,	0);

					e = swr_init(swr);
					if (e < 0) {
						fprintf(stderr, "swr_init: %d (icl=%d ocl=%d isr=%d osr=%d isf=%d osf=%d\n",
							-e,
							(int)c->channel_layout, (int)out_channel_layout, c->sample_rate, out_sample_rate, c->sample_fmt, AV_SAMPLE_FMT_S16);
						swr_free(&swr);
						swr = NULL;
					}
				}

				uint8_t *output = NULL;
				int in_samples = decoded_frame->nb_samples;
				int out_samples = av_rescale_rnd(swr_get_delay(swr, c->sample_rate) + in_samples, out_sample_rate, c->sample_rate, AV_ROUND_UP);
				e = av_samples_alloc(&output, NULL, out_channels, out_samples, AV_SAMPLE_FMT_S16, 1);
				if (e < 0) {
					fprintf(stderr, "av_samples_alloc: %d\n", -e);
					continue;
				}
				int64_t next_in_pts = av_rescale(av_frame_get_best_effort_timestamp(decoded_frame),
								 ((AVStream*) audioTrack->stream)->time_base.num * (int64_t)out_sample_rate * c->sample_rate,
								 ((AVStream*) audioTrack->stream)->time_base.den);
				int64_t next_out_pts = av_rescale(swr_next_pts(swr, next_in_pts),
								 ((AVStream*) audioTrack->stream)->time_base.den,
								 ((AVStream*) audioTrack->stream)->time_base.num * (int64_t)out_sample_rate * c->sample_rate);
				currentAudioPts = audioTrack->pts = pts = calcPts(audioTrack->stream, next_out_pts);
				out_samples = swr_convert(swr, &output, out_samples, (const uint8_t **) &decoded_frame->data[0], in_samples);

				pcmPrivateData_t extradata;

				extradata.uSampleRate = out_sample_rate;
				extradata.uNoOfChannels = av_get_channel_layout_nb_channels(out_channel_layout);
				extradata.uBitsPerSample = 16;
				extradata.bLittleEndian = 1;

				avOut.data       = output;
			    	avOut.len        = out_samples * sizeof(short) * out_channels;

				avOut.pts        = pts;
				avOut.extradata  = (unsigned char *) &extradata;
				avOut.extralen   = sizeof(extradata);
				avOut.frameRate  = 0;
				avOut.timeScale  = 0;
				avOut.width      = 0;
				avOut.height     = 0;
				avOut.type       = "audio";

				if (!context->playback->BackWard && context->output->audio->Write(context, &avOut) < 0)
					ffmpeg_err("writing data to audio device failed\n");
				av_freep(&output);
			}
		    }
		    else if (audioTrack->have_aacheader == 1)
		    {
			ffmpeg_printf(200,"write audio aac\n");

			avOut.data       = packet.data;
			avOut.len        = packet.size;
			avOut.pts        = pts;
			avOut.extradata  = audioTrack->aacbuf;
			avOut.extralen   = audioTrack->aacbuflen;
			avOut.frameRate  = 0;
			avOut.timeScale  = 0;
			avOut.width      = 0;
			avOut.height     = 0;
			avOut.type       = "audio";

			if (!context->playback->BackWard && context->output->audio->Write(context, &avOut) < 0)
			{
			    ffmpeg_err("(aac) writing data to audio device failed\n");
			}
		    }
		    else
		    {
			avOut.data       = packet.data;
			avOut.len        = packet.size;
			avOut.pts        = pts;
			avOut.extradata  = NULL;
			avOut.extralen   = 0;
			avOut.frameRate  = 0;
			avOut.timeScale  = 0;
			avOut.width      = 0;
			avOut.height     = 0;
			avOut.type       = "audio";

			if (!context->playback->BackWard && context->output->audio->Write(context, &avOut) < 0)
			{
			    ffmpeg_err("writing data to audio device failed\n");
			}
		    }
	    } else if (subtitleTrack && (subtitleTrack->Id == pid)) {
		    float duration=3.0;
		    ffmpeg_printf(100, "subtitleTrack->stream %p \n", subtitleTrack->stream);

		    pts = calcPts(subtitleTrack->stream, packet.pts);

		    if ((pts > latestPts) && (!videoTrack) && (!audioTrack))
			latestPts = pts;

		    /*Hellmaster1024: in mkv the duration for ID_TEXT is stored in convergence_duration */
		    ffmpeg_printf(20, "Packet duration %d\n", packet.duration);
		    ffmpeg_printf(20, "Packet convergence_duration %lld\n", packet.convergence_duration);

		    if(packet.duration != 0) // FIXME: packet.duration is 32 bit, AV_NOPTS_VALUE is 64 bit --martii
			duration=((float)packet.duration)/1000.0;
		    else if(packet.convergence_duration != 0 && packet.convergence_duration != AV_NOPTS_VALUE )
			duration=((float)packet.convergence_duration)/1000.0;
		    else if(((AVStream*)subtitleTrack->stream)->codec->codec_id == AV_CODEC_ID_SSA)
		    {
			/*Hellmaster1024 if the duration is not stored in packet.duration or
			  packet.convergence_duration we need to calculate it any other way, for SSA it is stored in
			  the Text line*/
			duration = getDurationFromSSALine(packet.data);
		    } else {
			/* no clue yet */
		    }

		    /* konfetti: I've found cases where the duration from getDurationFromSSALine
		     * is zero (start end and are really the same in text). I think it make's
		     * no sense to pass those.
		     */
		    if (duration > 0.0)
		    {
			/* is there a decoder ? */
			if (((AVStream*) subtitleTrack->stream)->codec->codec)
			{
			   AVSubtitle sub;
			   int got_sub_ptr;

			   if (avcodec_decode_subtitle2(((AVStream*) subtitleTrack->stream)->codec, &sub, &got_sub_ptr, &packet) < 0)
			   {
			       ffmpeg_err("error decoding subtitle\n");
			   } else
			   {
			       unsigned int i;

			       ffmpeg_printf(0, "format %d\n", sub.format);
			       ffmpeg_printf(0, "start_display_time %d\n", sub.start_display_time);
			       ffmpeg_printf(0, "end_display_time %d\n", sub.end_display_time);
			       ffmpeg_printf(0, "num_rects %d\n", sub.num_rects);
			       ffmpeg_printf(0, "pts %lld\n", sub.pts);

			       for (i = 0; i < sub.num_rects; i++)
			       {

				  ffmpeg_printf(0, "x %d\n", sub.rects[i]->x);
				  ffmpeg_printf(0, "y %d\n", sub.rects[i]->y);
				  ffmpeg_printf(0, "w %d\n", sub.rects[i]->w);
				  ffmpeg_printf(0, "h %d\n", sub.rects[i]->h);
				  ffmpeg_printf(0, "nb_colors %d\n", sub.rects[i]->nb_colors);
				  ffmpeg_printf(0, "type %d\n", sub.rects[i]->type);
				  ffmpeg_printf(0, "text %s\n", sub.rects[i]->text);
				  ffmpeg_printf(0, "ass %s\n", sub.rects[i]->ass);
			       // pict ->AVPicture

			       }
			   }
			}else
			if(((AVStream*)subtitleTrack->stream)->codec->codec_id == AV_CODEC_ID_SSA)
			{
			    SubtitleData_t data;

			    ffmpeg_printf(10, "videoPts %lld\n", currentVideoPts);

			    data.data      = packet.data;
			    data.len       = packet.size;
			    data.extradata = subtitleTrack->extraData;
			    data.extralen  = subtitleTrack->extraSize;
			    data.pts       = pts;
			    data.duration  = duration;

			    context->container->assContainer->Command(context, CONTAINER_DATA, &data);
			}else{
			    /* hopefully native text ;) */

			    unsigned char* line = text_to_ass((char *)packet.data,pts/90,duration);
			    ffmpeg_printf(50,"text line is %s\n",(char *)packet.data);
			    ffmpeg_printf(50,"Sub line is %s\n",line);
			    ffmpeg_printf(20, "videoPts %lld %f\n", currentVideoPts,currentVideoPts/90000.0);
			    SubtitleData_t data;
			    data.data      = line;
			    data.len       = strlen((char*)line);
			    data.extradata = (unsigned char *) DEFAULT_ASS_HEAD;
			    data.extralen  = strlen(DEFAULT_ASS_HEAD);
			    data.pts       = pts;
			    data.duration  = duration;

			    context->container->assContainer->Command(context, CONTAINER_DATA, &data);
			    free(line);
			}
		    } /* duration */
	    }
	    else if (dvbsubtitleTrack && (dvbsubtitleTrack->Id == pid)) {
		    dvbsubtitleTrack->pts = pts = calcPts(dvbsubtitleTrack->stream, packet.pts);

		    ffmpeg_printf(200, "DvbSubTitle index = %d\n",pid);

		    avOut.data       = packet.data;
		    avOut.len        = packet.size;
		    avOut.pts        = pts;
		    avOut.extradata  = NULL;
		    avOut.extralen   = 0;
		    avOut.frameRate  = 0;
		    avOut.timeScale  = 0;
		    avOut.width      = 0;
		    avOut.height     = 0;
		    avOut.type       = "dvbsubtitle";

		    if (context->output->dvbsubtitle->Write(context, &avOut) < 0)
		    {
			//ffmpeg_err("writing data to dvbsubtitle fifo failed\n");
		    }
	    } else if (teletextTrack && (teletextTrack->Id == pid)) {
		    teletextTrack->pts = pts = calcPts(teletextTrack->stream, packet.pts);

		    ffmpeg_printf(200, "TeleText index = %d\n",pid);

		    avOut.data       = packet.data;
		    avOut.len        = packet.size;
		    avOut.pts        = pts;
		    avOut.extradata  = NULL;
		    avOut.extralen   = 0;
		    avOut.frameRate  = 0;
		    avOut.timeScale  = 0;
		    avOut.width      = 0;
		    avOut.height     = 0;
		    avOut.type       = "teletext";

		    if (context->output->teletext->Write(context, &avOut) < 0)
		    {
			//ffmpeg_err("writing data to teletext fifo failed\n");
		    }
	    }
	} else { // av_read_frame failed
		ffmpeg_err("no data ->end of file reached ? \n");
		av_free_packet(&packet);
		releaseMutex(FILENAME, __FUNCTION__,__LINE__);
		break; // while
	}

	av_free_packet(&packet);
	releaseMutex(FILENAME, __FUNCTION__,__LINE__);
    } /* while */

    if (swr)
	swr_free(&swr);
    if (decoded_frame)
	avcodec_free_frame(&decoded_frame);

    hasPlayThreadStarted = 0;

    ffmpeg_printf(10, "terminating\n");
}

//for buffered io
int container_set_ffmpeg_buf_seek_time(int* time)
{
    ffmpeg_buf_seek_time = (*time);
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

int container_set_ffmpeg_buf_size(int* size)
{
		if(ffmpeg_buf == NULL)
    {
        if(*size == 0)
            ffmpeg_buf_size = 0;
        else
            ffmpeg_buf_size = (*size) + FILLBUFDIFF;
    }

		ffmpeg_printf(10, "size=%d, buffer size=%d\n", (*size), ffmpeg_buf_size);
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

int container_get_ffmpeg_buf_size(int* size)
{
    *size = ffmpeg_buf_size - FILLBUFDIFF;
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

int container_get_fillbufstatus(int* size)
{
    int rwdiff = 0;

    if(ffmpeg_buf != NULL && ffmpeg_buf_read != NULL && ffmpeg_buf_write != NULL)
    {
        if(ffmpeg_buf_read < ffmpeg_buf_write)
            rwdiff = ffmpeg_buf_write - ffmpeg_buf_read;
        if(ffmpeg_buf_read > ffmpeg_buf_write)
        {
            rwdiff = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read;
            rwdiff += ffmpeg_buf_write - ffmpeg_buf;
        }

        *size = rwdiff;
    }

    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

int container_stop_buffer()
{
    ffmpeg_buf_stop = 1;
    return 0;
}

//flag 0: start direct
//flag 1: from thread
void ffmpeg_filler(Context_t *context, int id, int* inpause, int flag)
{
    int len = 0;
    int rwdiff = ffmpeg_buf_size;
    uint8_t buf[FILLBUFPAKET];

    if(ffmpeg_read_org == NULL || ffmpeg_seek_org == NULL)
    {
        ffmpeg_err("ffmpeg_read_org or ffmpeg_seek_org is NULL\n");
        return;
    }

    while( (flag == 0 && avContext != NULL && avContext->pb != NULL && rwdiff > FILLBUFDIFF) || (flag == 1 && hasfillerThreadStarted[id] == 1 && avContext != NULL && avContext->pb != NULL && rwdiff > FILLBUFDIFF) )
    {
         if(flag == 0 && ffmpeg_buf_stop == 1)
         {
             ffmpeg_buf_stop = 0;
             break;
         }

         getfillerMutex(FILENAME, __FUNCTION__,__LINE__);
         //do a seek
         if(ffmpeg_do_seek != 0)
         {
             ffmpeg_do_seek_ret = ffmpeg_seek_org(avContext->pb->opaque, avContext->pb->pos + ffmpeg_do_seek, SEEK_SET);
             if(ffmpeg_do_seek_ret >= 0)
             {
                 ffmpeg_buf_write = ffmpeg_buf;
                 ffmpeg_buf_read = ffmpeg_buf;
             }

             ffmpeg_do_seek = 0;
         }

         if(ffmpeg_buf_read == ffmpeg_buf_write)
         {
             ffmpeg_buf_valid_size = 0;
             rwdiff = ffmpeg_buf_size;
         }
         if(ffmpeg_buf_read < ffmpeg_buf_write)
         {
             rwdiff = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_write;
             rwdiff += ffmpeg_buf_read - ffmpeg_buf;
         }
         if(ffmpeg_buf_read > ffmpeg_buf_write)
         rwdiff = ffmpeg_buf_read - ffmpeg_buf_write;

         int size = FILLBUFPAKET;
         if(rwdiff - FILLBUFDIFF < size)
             size = (rwdiff - FILLBUFDIFF);

         if(ffmpeg_buf_write + size > ffmpeg_buf + ffmpeg_buf_size)
             size = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_write;

         if(ffmpeg_buf_write == ffmpeg_buf + ffmpeg_buf_size)
             ffmpeg_buf_write = ffmpeg_buf;

         releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);

         if(size > 0)
         {
             if(flag == 1 && hasfillerThreadStarted[id] == 2) break;
             len = ffmpeg_read_org(avContext->pb->opaque, buf, size);
             if(flag == 1 && hasfillerThreadStarted[id] == 2) break;

             ffmpeg_printf(20, "buffer-status (free buffer=%d)\n", rwdiff - FILLBUFDIFF - len);

             getfillerMutex(FILENAME, __FUNCTION__,__LINE__);
             if(len > 0)
             { 
                 memcpy(ffmpeg_buf_write, buf, len);
                 ffmpeg_buf_write += len;
             }
             else
             {
                 releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
                 ffmpeg_err("read not ok ret=%d\n", len);
                 break;
             }
             releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
        }
        else
        {
            //on long pause the server close the connection, so we use seek to reconnect
            if(context != NULL && context->playback != NULL && inpause != NULL)
            {
                if((*inpause) == 0 && context->playback->isPaused)
                {
                    (*inpause) = 1;
                }
                else if((*inpause) == 1 && !context->playback->isPaused)
                {
                    int buflen = 0;
                    (*inpause) = 0;

                    getfillerMutex(FILENAME, __FUNCTION__,__LINE__);
                    if(ffmpeg_buf_read < ffmpeg_buf_write)
                        buflen = ffmpeg_buf_write - ffmpeg_buf_read;
                    if(ffmpeg_buf_read > ffmpeg_buf_write)
                    {
                        buflen = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read;
                        buflen += ffmpeg_buf_write - ffmpeg_buf;
                    } 
                    ffmpeg_seek_org(avContext->pb->opaque, avContext->pb->pos + buflen, SEEK_SET);
                    releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
                }
            }
        }
    }
}

static void ffmpeg_fillerTHREAD(Context_t *context)
{
    int inpause = 0;
    int id = hasfillerThreadStartedID;

    ffmpeg_printf(10, "Running ID=%d!\n", id);

    while(hasfillerThreadStarted[id] == 1)
    {
        ffmpeg_filler(context, id, &inpause, 1);
        usleep(10000);
    }

    hasfillerThreadStarted[id] = 0;

    ffmpeg_printf(10, "terminating ID=%d\n", id);
}

static int ffmpeg_start_fillerTHREAD(Context_t *context)
{
    int error;
    int ret = 0, i = 0;
    pthread_attr_t attr;

    ffmpeg_printf(10, "\n");

    if ( context && context->playback && context->playback->isPlaying )
        ffmpeg_printf(10, "is Playing\n");
    else
        ffmpeg_printf(10, "is NOT Playing\n");

    //get filler thread ID
    //if the thread hangs for long time, we use a new id
    for(i = 0; i < 10; i++)
    {
        if(hasfillerThreadStarted[i] == 0)
        {
            hasfillerThreadStartedID = i;
            break;
        }
    }

    if (hasfillerThreadStarted[hasfillerThreadStartedID] == 0)
    {
        pthread_attr_init(&attr);
        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

        hasfillerThreadStarted[hasfillerThreadStartedID] = 1;
        if((error = pthread_create(&fillerThread, &attr, (void *)&ffmpeg_fillerTHREAD, context)) != 0)
        {
            hasfillerThreadStarted[hasfillerThreadStartedID] = 0;
            ffmpeg_printf(10, "Error creating filler thread, error:%d:%s\n", error,strerror(error));

            ret = cERR_CONTAINER_FFMPEG_ERR;
        }
        else
        {
            ffmpeg_printf(10, "Created filler thread\n");
        }
    }
    else
    {
        ffmpeg_printf(10, "All filler thread ID's in use!\n");

        ret = cERR_CONTAINER_FFMPEG_ERR;
    }

    ffmpeg_printf(10, "exiting with value %d\n", ret);
    return ret;
}

int ffmpeg_read_real(void *opaque, uint8_t *buf, int buf_size)
{
    int len = buf_size;
    int rwdiff = 0;

    if(buf_size > 0)
    {
        getfillerMutex(FILENAME, __FUNCTION__,__LINE__);

        if(ffmpeg_buf_read < ffmpeg_buf_write)
            rwdiff = ffmpeg_buf_write - ffmpeg_buf_read;
        if(ffmpeg_buf_read > ffmpeg_buf_write)
        {
            rwdiff = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read;
            rwdiff += ffmpeg_buf_write - ffmpeg_buf;
        }
        rwdiff--;

        if(len > rwdiff)
            len = rwdiff;

        if(ffmpeg_buf_read + len > ffmpeg_buf + ffmpeg_buf_size)
            len = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read;

        if(len > 0)
        {
            memcpy(buf, ffmpeg_buf_read, len);
            ffmpeg_buf_read += len;

            if(ffmpeg_buf_valid_size < FILLBUFDIFF)
            {
                if(ffmpeg_buf_valid_size + len > FILLBUFDIFF)
                    ffmpeg_buf_valid_size = FILLBUFDIFF;
                else
                    ffmpeg_buf_valid_size += len;
            }

            if(ffmpeg_buf_read == ffmpeg_buf + ffmpeg_buf_size)
                ffmpeg_buf_read = ffmpeg_buf;
        }
        else
            len = 0;

        releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
    }

    return len;
}

int ffmpeg_read(void *opaque, uint8_t *buf, int buf_size)
{
    int sumlen = 0;
    int len = 0;
    int count = 2000;

    while(sumlen < buf_size && (--count) > 0)
    {
        len = ffmpeg_read_real(opaque, buf, buf_size - sumlen);
        sumlen += len;
        buf += len;
        if(len == 0)
            usleep(10000);
    }

    if(count == 0)
    {
        if(sumlen == 0)
            ffmpeg_err( "Timeout waiting for buffered data (buf_size=%d sumlen=%d)!\n", buf_size, sumlen);
        else
            ffmpeg_err( "Timeout, not all buffered data availabel (buf_size=%d sumlen=%d)!\n", buf_size, sumlen);
    }

    return sumlen;
}

int64_t ffmpeg_seek(void *opaque, int64_t offset, int whence)
{
    int64_t diff;
    int rwdiff = 0;
    whence &= ~AVSEEK_FORCE;

    if(whence != SEEK_CUR && whence != SEEK_SET)
        return AVERROR(EINVAL);

    if(whence == SEEK_CUR)
        diff = offset;
    else
        diff = offset - avContext->pb->pos;

    if(diff == 0)
        return avContext->pb->pos;

    getfillerMutex(FILENAME, __FUNCTION__,__LINE__);

    if(ffmpeg_buf_read < ffmpeg_buf_write)
        rwdiff = ffmpeg_buf_write - ffmpeg_buf_read;
    if(ffmpeg_buf_read > ffmpeg_buf_write)
    {
        rwdiff = (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read;
        rwdiff += ffmpeg_buf_write - ffmpeg_buf;
    }

    if(diff > 0 && diff < rwdiff)
    {
        /* can do the seek inside the buffer */
        ffmpeg_printf(20, "buffer-seek diff=%lld\n", diff);
        if(diff > (ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read)
            ffmpeg_buf_read = ffmpeg_buf + (diff - ((ffmpeg_buf + ffmpeg_buf_size) - ffmpeg_buf_read));
        else
            ffmpeg_buf_read = ffmpeg_buf_read + diff;
    }
    else if(diff < 0 && diff * -1 < ffmpeg_buf_valid_size)
    {
        /* can do the seek inside the buffer */
        ffmpeg_printf(20, "buffer-seek diff=%lld\n", diff);
        int tmpdiff = diff * -1;
        if(tmpdiff > ffmpeg_buf_read - ffmpeg_buf)
            ffmpeg_buf_read = (ffmpeg_buf + ffmpeg_buf_size) - (tmpdiff - (ffmpeg_buf_read - ffmpeg_buf));
        else
            ffmpeg_buf_read = ffmpeg_buf_read - tmpdiff;
    }
    else
    {
        releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
        ffmpeg_printf(20, "real-seek diff=%lld\n", diff);

        ffmpeg_do_seek_ret = 0;
        ffmpeg_do_seek = diff;
        while(ffmpeg_do_seek != 0)
            usleep(100000);

        ffmpeg_do_seek = 0;
        if(ffmpeg_do_seek_ret < 0)
        {
            ffmpeg_err("seek not ok ret=%d\n", ffmpeg_do_seek_ret);
            return ffmpeg_do_seek_ret;
        }

        //fill buffer
        int count = ffmpeg_buf_seek_time * 10;
        int size = 0;

        container_get_fillbufstatus(&size);
        while(size < ffmpeg_buf_size - FILLBUFDIFF && (--count) > 0)
        {
            usleep(100000);
            container_get_fillbufstatus(&size);
        }

        return avContext->pb->pos + diff;
    }

    releasefillerMutex(FILENAME, __FUNCTION__,__LINE__);
    return avContext->pb->pos + diff;
}

static void ffmpeg_buf_free()
{
    ffmpeg_read_org = NULL;
    ffmpeg_seek_org = NULL;
    ffmpeg_buf_read = NULL;
    ffmpeg_buf_write = NULL;
    free(ffmpeg_buf);
    ffmpeg_buf = NULL;
    ffmpeg_buf_valid_size = 0;
    ffmpeg_do_seek_ret = 0;
    ffmpeg_do_seek = 0;
    ffmpeg_buf_stop = 0;
    hasfillerThreadStartedID = 0;
}
//for buffered io (end)

/* **************************** */
/* Container part for ffmpeg    */
/* **************************** */

static int terminating = 0;
static int interrupt_cb(void *ctx)
{
	PlaybackHandler_t *p = (PlaybackHandler_t *)ctx;
	return p->abortRequested;
}


int container_ffmpeg_init(Context_t *context, char * filename)
{
    int err;

    ffmpeg_printf(10, ">\n");

    //for buffered io
    ffmpeg_buf_free();
    //for buffered io end

    if (filename == NULL) {
	ffmpeg_err("filename NULL\n");

	return cERR_CONTAINER_FFMPEG_NULL;
    }

    if (context == NULL) {
	ffmpeg_err("context NULL\n");

	return cERR_CONTAINER_FFMPEG_NULL;
    }

    ffmpeg_printf(10, "filename %s\n", filename);

    if (isContainerRunning) {
	ffmpeg_err("ups already running?\n");
    releaseMutex(FILENAME, __FUNCTION__,__LINE__);
	return cERR_CONTAINER_FFMPEG_RUNNING;
    }

    /* initialize ffmpeg */
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
//    av_log_set_level( AV_LOG_DEBUG );
 
    context->playback->abortRequested = 0;
    avContext = avformat_alloc_context();
    avContext->interrupt_callback.callback = interrupt_cb;
    avContext->interrupt_callback.opaque = context->playback;

    if(strstr(filename, "http://") == filename)
	{
	    av_dict_set(&avio_opts, "timeout", "20000000", 0); //20sec
        av_dict_set(&avio_opts, "seekable", "0", 0);
//      av_dict_set(&avio_opts, "cookies", c->cookies, 0);

		if(ostrstr(filename, "|User-Agent=") != NULL)
        {
			char* tmpstr = ostrcat(filename, NULL, 0, 0);
			tmpstr = string_replace("|User-Agent=", "|", tmpstr, 1);
			int count = 0;
			struct splitstr* ret1 = NULL;
			ret1 = strsplit(tmpstr, "|", &count);

			if(ret1 != NULL && count > 1)
			{
				av_dict_set(&avio_opts, "user-agent", ret1[1].part, 0);
//				free(filename);
				filename = ostrcat(ret1[0].part, NULL, 0, 0);
			   	ffmpeg_printf(10, "set filename %s\n", ret1[0].part);
			   	ffmpeg_printf(10, "set user-agent: %s\n", ret1[1].part);
			}
			free(ret1), ret1 = NULL;
			free(tmpstr), tmpstr = NULL;			
		}

	    if ((err = avformat_open_input(&avContext, filename, NULL, &avio_opts)) != 0)
	    {
			char error[512];
	
			ffmpeg_err("avformat_open_input failed %d (%s)\n", err, filename);
			av_strerror(err, error, 512);
			ffmpeg_err("Cause: %s\n", error);
	
	        if(avio_opts != NULL) av_dict_free(&avio_opts);
	        //for buffered io
	        ffmpeg_buf_free();
	        //for buffered io (end)
	        releaseMutex(FILENAME, __FUNCTION__,__LINE__);
			return cERR_CONTAINER_FFMPEG_OPEN;
	    }
	}
	else
	{    
		if ((err = avformat_open_input(&avContext, filename, NULL, 0)) != 0)
		{
			char error[512];
	
			ffmpeg_err("avformat_open_input failed %d (%s)\n", err, filename);
			av_strerror(err, error, 512);
			ffmpeg_err("Cause: %s\n", error);
	
	        if(avio_opts != NULL) av_dict_free(&avio_opts);
	        //for buffered io
	        ffmpeg_buf_free();
	        //for buffered io (end)
	        releaseMutex(FILENAME, __FUNCTION__,__LINE__);
			return cERR_CONTAINER_FFMPEG_OPEN;
	    }
	}

    avContext->iformat->flags |= AVFMT_SEEK_TO_PTS;
    avContext->flags = AVFMT_FLAG_GENPTS;

    if (context->playback->noprobe)
        avContext->max_analyze_duration = 1;

    ffmpeg_printf(20, "find_streaminfo\n");

    if (avformat_find_stream_info(avContext, NULL) < 0) {
		ffmpeg_err("Error avformat_find_stream_info\n");
#ifdef this_is_ok
	/* crow reports that sometimes this returns an error
	 * but the file is played back well. so remove this
	 * until other works are done and we can prove this.
	 */
		avformat_close_input(&avContext);
        //for buffered io
        ffmpeg_buf_free();
        //for buffered io (end)
        releaseMutex(FILENAME, __FUNCTION__,__LINE__);
		return cERR_CONTAINER_FFMPEG_STREAM;
#endif
    }

//for buffered io
    if(strstr(filename, "http://") == filename)
    {
        if(ffmpeg_buf_size > 0 && ffmpeg_buf_size > FILLBUFDIFF + FILLBUFPAKET)
        {
            if(avContext != NULL && avContext->pb != NULL)
            {
                ffmpeg_buf = av_malloc(ffmpeg_buf_size);

                if(ffmpeg_buf != NULL)
                {
                    ffmpeg_printf(10, "buffer size=%d\n", ffmpeg_buf_size);
      		
                    ffmpeg_read_org = avContext->pb->read_packet;
                    avContext->pb->read_packet = ffmpeg_read;
                    ffmpeg_seek_org = avContext->pb->seek;
                    avContext->pb->seek = ffmpeg_seek;
                    ffmpeg_buf_read = ffmpeg_buf;
                    ffmpeg_buf_write = ffmpeg_buf;

                    //fill buffer
                    ffmpeg_filler(context, -1, NULL, 0);
                    ffmpeg_start_fillerTHREAD(context);
                }
            }
        }
    }
//for buffered io (end)

    terminating = 0;
    latestPts = 0;
    isContainerRunning = 1;
    int res = container_ffmpeg_update_tracks(context, filename, 1);
    return res;
}

int container_ffmpeg_update_tracks(Context_t *context, char *filename, int initial)
{
    if (terminating)
	return cERR_CONTAINER_FFMPEG_NO_ERROR;

    Track_t * audioTrack = NULL;
    Track_t * subtitleTrack = NULL;
    Track_t * dvbsubtitleTrack = NULL;
    Track_t * teletextTrack = NULL;

    context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack);
    if (initial)
	context->manager->subtitle->Command(context, MANAGER_GET_TRACK, &subtitleTrack);
    context->manager->dvbsubtitle->Command(context, MANAGER_GET_TRACK, &dvbsubtitleTrack);
    context->manager->teletext->Command(context, MANAGER_GET_TRACK, &teletextTrack);

    if (context->manager->video)
	    context->manager->video->Command(context, MANAGER_INIT_UPDATE, NULL);
    if (context->manager->audio)
	    context->manager->audio->Command(context, MANAGER_INIT_UPDATE, NULL);
#if 0
    if (context->manager->subtitle)
	    context->manager->subtitle->Command(context, MANAGER_INIT_UPDATE, NULL);
#endif
    if (context->manager->dvbsubtitle)
	    context->manager->dvbsubtitle->Command(context, MANAGER_INIT_UPDATE, NULL);
    if (context->manager->teletext)
	    context->manager->teletext->Command(context, MANAGER_INIT_UPDATE, NULL);

    ffmpeg_printf(20, "dump format\n");
    av_dump_format(avContext, 0, filename, 0);

    ffmpeg_printf(1, "number streams %d\n", avContext->nb_streams);

    unsigned int n;

    for ( n = 0; n < avContext->nb_streams; n++) {
	Track_t track;
	AVStream *stream = avContext->streams[n];
	int version = 0;

	char* encoding = Codec2Encoding(stream->codec, &version);

	if (encoding != NULL)
	   ffmpeg_printf(1, "%d. encoding = %s - version %d\n", n, encoding, version);

	if (!stream->id)
		stream->id = n;

	/* some values in track are unset and therefor copyTrack segfaults.
	 * so set it by default to NULL!
	 */
	memset(&track, 0, sizeof(track));

	switch (stream->codec->codec_type) {
	case AVMEDIA_TYPE_VIDEO:
	    ffmpeg_printf(10, "CODEC_TYPE_VIDEO %d\n",stream->codec->codec_type);

	    if (encoding != NULL) {
		track.type           = eTypeES;
		track.version        = version;

		track.width          = stream->codec->width;
		track.height         = stream->codec->height;

		track.extraData      = stream->codec->extradata;
		track.extraSize      = stream->codec->extradata_size;

		track.frame_rate     = stream->r_frame_rate.num;

		track.aacbuf         = 0;
		track.have_aacheader = -1;

		double frame_rate = av_q2d(stream->r_frame_rate); /* rational to double */

		ffmpeg_printf(10, "frame_rate = %f\n", frame_rate);

		track.frame_rate = frame_rate * 1000.0;

		/* fixme: revise this */

		if (track.frame_rate < 23970)
		    track.TimeScale = 1001;
		else
		    track.TimeScale = 1000;

		ffmpeg_printf(10, "bit_rate = %d\n",stream->codec->bit_rate);
		ffmpeg_printf(10, "flags = %d\n",stream->codec->flags);
		ffmpeg_printf(10, "frame_bits = %d\n",stream->codec->frame_bits);
		ffmpeg_printf(10, "time_base.den %d\n",stream->time_base.den);
		ffmpeg_printf(10, "time_base.num %d\n",stream->time_base.num);
		ffmpeg_printf(10, "frame_rate %d\n",stream->r_frame_rate.num);
		ffmpeg_printf(10, "TimeScale %d\n",stream->r_frame_rate.den);

		ffmpeg_printf(10, "frame_rate %d\n", track.frame_rate);
		ffmpeg_printf(10, "TimeScale %d\n", track.TimeScale);

		track.Name      = "und";
		track.Encoding  = encoding;
		track.stream    = stream;
		track.Id        = ((AVStream *) (track.stream))->id;

		if(stream->duration == AV_NOPTS_VALUE) {
		    ffmpeg_printf(10, "Stream has no duration so we take the duration from context\n");
		    track.duration = (double) avContext->duration / 1000.0;
		}
		else {
		    track.duration = (double) stream->duration * av_q2d(stream->time_base) * 1000.0;
		}

		if (context->manager->video)
		    if (context->manager->video->Command(context, MANAGER_ADD, &track) < 0) {
			/* konfetti: fixme: is this a reason to return with error? */
			ffmpeg_err("failed to add track %d\n", n);
		    }

	    }
	    else {
		ffmpeg_err("codec type video but codec unknown %d\n", stream->codec->codec_id);
	    }
	    break;
	case AVMEDIA_TYPE_AUDIO:
	    ffmpeg_printf(10, "CODEC_TYPE_AUDIO %d\n",stream->codec->codec_type);

	    if (encoding != NULL) {
		AVDictionaryEntry *lang;
		track.type           = eTypeES;

		lang = av_dict_get(stream->metadata, "language", NULL, 0);

		track.Name = lang ? lang->value : "und";

		ffmpeg_printf(10, "Language %s\n", track.Name);

		track.Encoding       = encoding;
		track.stream         = stream;
		track.Id        = ((AVStream *) (track.stream))->id;
		track.duration       = (double)stream->duration * av_q2d(stream->time_base) * 1000.0;
		track.aacbuf         = 0;
		track.have_aacheader = -1;

		if(stream->duration == AV_NOPTS_VALUE) {
		    ffmpeg_printf(10, "Stream has no duration so we take the duration from context\n");
		    track.duration = (double) avContext->duration / 1000.0;
		}
		else {
		    track.duration = (double) stream->duration * av_q2d(stream->time_base) * 1000.0;
		}

		if(!strncmp(encoding, "A_IPCM", 6))
		{
		    track.inject_as_pcm = 1;
		    ffmpeg_printf(10, " Handle inject_as_pcm = %d\n", track.inject_as_pcm);

			AVCodec *codec = avcodec_find_decoder(stream->codec->codec_id);

//( (AVStream*) audioTrack->stream)->codec->flags |= CODEC_FLAG_TRUNCATED;
			if(codec != NULL && !avcodec_open2(stream->codec, codec, NULL))
			   printf("AVCODEC__INIT__SUCCESS\n");
			else
			   printf("AVCODEC__INIT__FAILED\n");
		}
#if 0
		else if(stream->codec->codec_id == AV_CODEC_ID_AAC) {
		    ffmpeg_printf(10,"Create AAC ExtraData\n");
		    ffmpeg_printf(10,"stream->codec->extradata_size %d\n", stream->codec->extradata_size);
		    Hexdump(stream->codec->extradata, stream->codec->extradata_size);

  /* extradata
13 10 56 e5 9d 48 00 (anderen cops)
	object_type: 00010 2 = LC
	sample_rate: 011 0 6 = 24000
	chan_config: 0010 2 = Stereo
	000 0
	1010110 111 = 0x2b7
	00101 = SBR
	1
	0011 = 48000
	101 01001000 = 0x548
	ps = 0
	0000000
*/

		    unsigned int object_type = 2; // LC
		    unsigned int sample_index = aac_get_sample_rate_index(stream->codec->sample_rate);
		    unsigned int chan_config = stream->codec->channels;
		    if(stream->codec->extradata_size >= 2) {
			object_type = stream->codec->extradata[0] >> 3;
			sample_index = ((stream->codec->extradata[0] & 0x7) << 1)
			    + (stream->codec->extradata[1] >> 7);
			chan_config = (stream->codec->extradata[1] >> 3) && 0xf;
		    }

		    ffmpeg_printf(10,"aac object_type %d\n", object_type);
		    ffmpeg_printf(10,"aac sample_index %d\n", sample_index);
		    ffmpeg_printf(10,"aac chan_config %d\n", chan_config);

		    object_type -= 1; // Cause of ADTS

		    track.aacbuflen = AAC_HEADER_LENGTH;
		    track.aacbuf = malloc(8);
		    track.aacbuf[0] = 0xFF;
		    track.aacbuf[1] = 0xF1;
		    track.aacbuf[2] = ((object_type & 0x03) << 6)  | (sample_index << 2) | ((chan_config >> 2) & 0x01);
		    track.aacbuf[3] = (chan_config & 0x03) << 6;
		    track.aacbuf[4] = 0x00;
		    track.aacbuf[5] = 0x1F;
		    track.aacbuf[6] = 0xFC;

		    printf("AAC_HEADER -> ");
		    Hexdump(track.aacbuf,7);
		    track.have_aacheader = 1;

		} else if(stream->codec->codec_id == AV_CODEC_ID_WMAV1
		    || stream->codec->codec_id == AV_CODEC_ID_WMAV2
		    || stream->codec->codec_id == AV_CODEC_ID_WMAPRO) //if (stream->codec->extradata_size > 0)
		{
		    ffmpeg_printf(10,"Create WMA ExtraData\n");
		    track.aacbuflen = 104 + stream->codec->extradata_size;
		    track.aacbuf = malloc(track.aacbuflen);
		    memset (track.aacbuf, 0, track.aacbuflen);
		    unsigned char ASF_Stream_Properties_Object[16] =
			{0x91,0x07,0xDC,0xB7,0xB7,0xA9,0xCF,0x11,0x8E,0xE6,0x00,0xC0,0x0C,0x20,0x53,0x65};
		    memcpy(track.aacbuf + 0, ASF_Stream_Properties_Object, 16); // ASF_Stream_Properties_Object
		    memcpy(track.aacbuf + 16, &track.aacbuflen, 4); //FrameDateLength

		    unsigned int sizehi = 0;
		    memcpy(track.aacbuf + 20, &sizehi, 4); // sizehi (not used)

		    unsigned char ASF_Audio_Media[16] =
			{0x40,0x9E,0x69,0xF8,0x4D,0x5B,0xCF,0x11,0xA8,0xFD,0x00,0x80,0x5F,0x5C,0x44,0x2B};
		    memcpy(track.aacbuf + 24, ASF_Audio_Media, 16); //ASF_Audio_Media

		    unsigned char ASF_Audio_Spread[16] =
			{0x50,0xCD,0xC3,0xBF,0x8F,0x61,0xCF,0x11,0x8B,0xB2,0x00,0xAA,0x00,0xB4,0xE2,0x20};
		    memcpy(track.aacbuf + 40, ASF_Audio_Spread, 16); //ASF_Audio_Spread

		    memset(track.aacbuf + 56, 0, 4); // time_offset (not used)
		    memset(track.aacbuf + 60, 0, 4); // time_offset_hi (not used)

		    unsigned int type_specific_data_length = 18 + stream->codec->extradata_size;
		    memcpy(track.aacbuf + 64, &type_specific_data_length, 4); //type_specific_data_length

		    unsigned int error_correction_data_length = 8;
		    memcpy(track.aacbuf + 68, &error_correction_data_length, 4); //error_correction_data_length

		    unsigned short flags = 1; // stream_number
		    memcpy(track.aacbuf + 72, &flags, 2); //flags

		    unsigned int reserved = 0;
		    memcpy(track.aacbuf + 74, &reserved, 4); // reserved

		    // type_specific_data
#define WMA_VERSION_1           0x160
#define WMA_VERSION_2_9         0x161
#define WMA_VERSION_9_PRO       0x162
#define WMA_LOSSLESS            0x163
		    unsigned short codec_id = 0;
		    switch(stream->codec->codec_id) {
			//TODO: What code for lossless ?
			case AV_CODEC_ID_WMAPRO:
			    codec_id = WMA_VERSION_9_PRO;
			    break;
			case AV_CODEC_ID_WMAV2:
			    codec_id = WMA_VERSION_2_9 ;
			    break;
			case AV_CODEC_ID_WMAV1:
			default:
			    codec_id = WMA_VERSION_1;
			    break;
		    }
		    memcpy(track.aacbuf + 78, &codec_id, 2); //codec_id

		    unsigned short number_of_channels = stream->codec->channels;
		    memcpy(track.aacbuf + 80, &number_of_channels, 2); //number_of_channels

		    unsigned int samples_per_second = stream->codec->sample_rate;
		    ffmpeg_printf(1, "samples_per_second = %d\n", samples_per_second);
		    memcpy(track.aacbuf + 82, &samples_per_second, 4); //samples_per_second

		    unsigned int average_number_of_bytes_per_second = stream->codec->bit_rate / 8;
		    ffmpeg_printf(1, "average_number_of_bytes_per_second = %d\n", average_number_of_bytes_per_second);
		    memcpy(track.aacbuf + 86, &average_number_of_bytes_per_second, 4); //average_number_of_bytes_per_second

		    unsigned short block_alignment = stream->codec->block_align;
		    ffmpeg_printf(1, "block_alignment = %d\n", block_alignment);
		    memcpy(track.aacbuf + 90, &block_alignment, 2); //block_alignment

		    unsigned short bits_per_sample =
			stream->codec->sample_fmt>=0?(stream->codec->sample_fmt+1)*8:8;
		    ffmpeg_printf(1, "bits_per_sample = %d (%d)\n", bits_per_sample, stream->codec->sample_fmt);
		    memcpy(track.aacbuf + 92, &bits_per_sample, 2); //bits_per_sample

		    memcpy(track.aacbuf + 94, &stream->codec->extradata_size, 2); //bits_per_sample

		    memcpy(track.aacbuf + 96, stream->codec->extradata, stream->codec->extradata_size);

		    ffmpeg_printf(1, "aacbuf:\n");
		    Hexdump(track.aacbuf, track.aacbuflen);

		    //ffmpeg_printf(1, "priv_data:\n");
		    //Hexdump(stream->codec->priv_data, track.aacbuflen);

		    track.have_aacheader = 1;
		}
#endif

		if (context->manager->audio)
		{
		    if (context->manager->audio->Command(context, MANAGER_ADD, &track) < 0) {
			/* konfetti: fixme: is this a reason to return with error? */
			ffmpeg_err("failed to add track %d\n", n);
		    }
		}

	    }
	    else {
		ffmpeg_err("codec type audio but codec unknown %d\n", stream->codec->codec_id);
	    }
	    break;
	case AVMEDIA_TYPE_SUBTITLE:
	{
	    AVDictionaryEntry *lang;

	    ffmpeg_printf(10, "CODEC_TYPE_SUBTITLE %d\n",stream->codec->codec_type);

	     lang = av_dict_get(stream->metadata, "language", NULL, 0);

	     track.Name = lang ? lang->value : "und";

	    ffmpeg_printf(10, "Language %s\n", track.Name);

	    track.Encoding       = encoding;
	    track.stream         = stream;
	    track.Id		 = ((AVStream *) (track.stream))->id;
	    track.duration       = (double)stream->duration * av_q2d(stream->time_base) * 1000.0;

	    track.aacbuf         = 0;
	    track.have_aacheader = -1;

	    track.width          = -1; /* will be filled online from videotrack */
	    track.height         = -1; /* will be filled online from videotrack */

	    track.extraData      = stream->codec->extradata;
	    track.extraSize      = stream->codec->extradata_size;

	    ffmpeg_printf(1, "subtitle codec %d\n", stream->codec->codec_id);
	    ffmpeg_printf(1, "subtitle width %d\n", stream->codec->width);
	    ffmpeg_printf(1, "subtitle height %d\n", stream->codec->height);
	    ffmpeg_printf(1, "subtitle stream %p\n", stream);

	    if(stream->duration == AV_NOPTS_VALUE) {
		ffmpeg_printf(10, "Stream has no duration so we take the duration from context\n");
		track.duration = (double) avContext->duration / 1000.0;
	    }
	    else {
		track.duration = (double) stream->duration * av_q2d(stream->time_base) * 1000.0;
	    }

	    ffmpeg_printf(10, "FOUND SUBTITLE %s\n", track.Name);

	    if (stream->codec->codec_id == AV_CODEC_ID_DVB_TELETEXT && context->manager->teletext) {
		ffmpeg_printf(10, "dvb_teletext\n");
		int i = 0;
		AVDictionaryEntry *t = NULL;
		do {
			char tmp[30];
			snprintf(tmp, sizeof(tmp), "teletext_%d", i);
			t = av_dict_get(stream->metadata, tmp, NULL, 0);
			if (t) {
				track.Name = t->value;
				if (context->manager->teletext->Command(context, MANAGER_ADD, &track) < 0)
					ffmpeg_err("failed to add teletext track %d\n", n);
			}
			i++;
		} while (t);
	    } else if (stream->codec->codec_id == AV_CODEC_ID_DVB_SUBTITLE && context->manager->dvbsubtitle) {
		ffmpeg_printf(10, "dvb_subtitle\n");
		lang = av_dict_get(stream->metadata, "language", NULL, 0);
		if (context->manager->dvbsubtitle->Command(context, MANAGER_ADD, &track) < 0) {
		    ffmpeg_err("failed to add dvbsubtitle track %d\n", n);
		}
	    } else if (initial && context->manager->subtitle) {
		if (!stream->codec->codec) {
		    stream->codec->codec = avcodec_find_decoder(stream->codec->codec_id);
		    if (!stream->codec->codec)
			ffmpeg_err("avcodec_find_decoder failed for subtitle track %d\n", n);
		    else if (avcodec_open2(stream->codec, stream->codec->codec, NULL)) {
		    	ffmpeg_err("avcodec_open2 failed for subtitle track %d\n", n);
		    	stream->codec->codec = NULL;
		    }
		}
		if (context->manager->subtitle->Command(context, MANAGER_ADD, &track) < 0) {
		    /* konfetti: fixme: is this a reason to return with error? */
		    ffmpeg_err("failed to add subtitle track %d\n", n);
		}
	    }

	    break;
	}
	case AVMEDIA_TYPE_UNKNOWN:
	case AVMEDIA_TYPE_DATA:
	case AVMEDIA_TYPE_ATTACHMENT:
	case AVMEDIA_TYPE_NB:
	default:
	    ffmpeg_err("not handled or unknown codec_type %d\n", stream->codec->codec_type);
	 break;
	}

    } /* for */

    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_play(Context_t *context)
{
    int error;
    int ret = 0;
    pthread_attr_t attr;

    ffmpeg_printf(10, "\n");

    if ( context && context->playback && context->playback->isPlaying ) {
	ffmpeg_printf(10, "is Playing\n");
    }
    else {
	ffmpeg_printf(10, "is NOT Playing\n");
    }

    if (hasPlayThreadStarted == 0) {
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

	if((error = pthread_create(&PlayThread, &attr, (void *)&FFMPEGThread, context)) != 0) {
	    ffmpeg_printf(10, "Error creating thread, error:%d:%s\n", error,strerror(error));

	    hasPlayThreadStarted = 0;
	    ret = cERR_CONTAINER_FFMPEG_ERR;
	}
	else {
	    ffmpeg_printf(10, "Created thread\n");

	    hasPlayThreadStarted = 1;
	}
    }
    else {
	ffmpeg_printf(10, "A thread already exists!\n");

	ret = cERR_CONTAINER_FFMPEG_ERR;
    }

    ffmpeg_printf(10, "exiting with value %d\n", ret);

    return ret;
}

static int container_ffmpeg_stop(Context_t *context) {
    int ret = cERR_CONTAINER_FFMPEG_NO_ERROR;
    int wait_time = 100;

    ffmpeg_printf(10, "\n");

    if (!isContainerRunning)
    {
        ffmpeg_err("Container not running\n");
        return cERR_CONTAINER_FFMPEG_ERR;
    }
    
    //for buffered io
    wait_time = 100;
    if(hasfillerThreadStarted[hasfillerThreadStartedID] == 1)
        hasfillerThreadStarted[hasfillerThreadStartedID] = 2; // should end
    while ( (hasfillerThreadStarted[hasfillerThreadStartedID] != 0) && (--wait_time) > 0 ) {
        ffmpeg_printf(10, "Waiting for ffmpeg filler thread to terminate itself, will try another %d times, ID=%d\n", wait_time, hasfillerThreadStartedID);
        usleep(100000);
    }

    if (wait_time == 0) {
        ffmpeg_err( "Timeout waiting for filler thread!\n");

        ret = cERR_CONTAINER_FFMPEG_ERR;
    }
    //for buffered io (end)
    
    if (context->playback)
        context->playback->isPlaying = 0;

    wait_time = 100;
    while ( (hasPlayThreadStarted != 0) && (--wait_time) > 0 ) {
        ffmpeg_printf(10, "Waiting for ffmpeg thread to terminate itself, will try another %d times\n", wait_time);

        usleep(100000);
    }

    if (wait_time == 0) {
        ffmpeg_err( "Timeout waiting for thread!\n");

        ret = cERR_CONTAINER_FFMPEG_ERR;
    }

    hasPlayThreadStarted = 0;
    terminating = 1;

    getMutex(FILENAME, __FUNCTION__,__LINE__);

    if (avContext) {
        avformat_close_input(&avContext);
        avContext = NULL;
    }

    if(avio_opts != NULL) av_dict_free(&avio_opts);

    isContainerRunning = 0;
    avformat_network_deinit();

    //for buffered io
    ffmpeg_buf_free();
    //for buffered io (end)

    releaseMutex(FILENAME, __FUNCTION__,__LINE__);

    ffmpeg_printf(10, "ret %d\n", ret);
    return ret;
}

static int container_ffmpeg_seek_bytes(off_t pos) {
    int flag = AVSEEK_FLAG_BYTE;
    off_t current_pos = avio_tell(avContext->pb);

    ffmpeg_printf(20, "seeking to position %lld (bytes)\n", pos);

    if (current_pos > pos)
	flag |= AVSEEK_FLAG_BACKWARD;

    if (avformat_seek_file(avContext, -1, INT64_MIN, pos, INT64_MAX, flag) < 0)
    {
	ffmpeg_err( "Error seeking\n");
	return cERR_CONTAINER_FFMPEG_ERR;
    }

    ffmpeg_printf(30, "current_pos after seek %lld\n", avio_tell(avContext->pb));

    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

/* seeking relative to a given byteposition N seconds ->for reverse playback needed */
static int container_ffmpeg_seek_rel(Context_t *context, off_t pos, long long int pts, float sec) {
    Track_t * videoTrack = NULL;
    Track_t * audioTrack = NULL;
    Track_t * current = NULL;
    seek_target_flag = 0;

    ffmpeg_printf(10, "seeking %f sec relativ to %lld\n", sec, pos);

    context->manager->video->Command(context, MANAGER_GET_TRACK, &videoTrack);
    context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack);

    if (videoTrack != NULL)
	current = videoTrack;
    else if (audioTrack != NULL)
	current = audioTrack;

    if (current == NULL) {
	ffmpeg_err( "no track avaibale to seek\n");
	return cERR_CONTAINER_FFMPEG_ERR;
    }

    if (pos == -1)
    {
	pos = avio_tell(avContext->pb);
    }

    if (pts == -1)
	pts = current->pts;

    if (sec < 0)
	seek_target_flag |= AVSEEK_FLAG_BACKWARD;

    ffmpeg_printf(10, "iformat->flags %d\n", avContext->iformat->flags);

    if (avContext->iformat->flags & AVFMT_TS_DISCONT)
    {
	if (avContext->bit_rate)
	{
	    sec *= avContext->bit_rate / 8.0;
	    ffmpeg_printf(10, "bit_rate %d\n", avContext->bit_rate);
	}
	else
	{
	    sec *= 180000.0;
	}

	pos += sec;

	if (pos < 0)
	{
	   ffmpeg_err("end of file reached\n");
	   releaseMutex(FILENAME, __FUNCTION__,__LINE__);
	   return cERR_CONTAINER_FFMPEG_END_OF_FILE;
	}

	ffmpeg_printf(10, "1. seeking to position %lld bytes ->sec %f\n", pos, sec);

	seek_target_bytes = pos;
	do_seek_target_bytes = 1;

	return pos;
    }
    else
    {
	sec += ((float) pts / 90000.0f);

	if (sec < 0)
	    sec = 0;

	ffmpeg_printf(10, "2. seeking to position %f sec ->time base %f %d\n", sec, av_q2d(((AVStream*) current->stream)->time_base), AV_TIME_BASE);

	seek_target_seconds = sec * AV_TIME_BASE;
	do_seek_target_seconds = 1;
    }

    releaseMutex(FILENAME, __FUNCTION__,__LINE__);
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_seek(Context_t *context, float sec, int absolute) {
    Track_t * videoTrack = NULL;
    Track_t * audioTrack = NULL;
    Track_t * current = NULL;
    seek_target_flag = 0;

    if (absolute) {
	ffmpeg_printf(10, "goto %f sec\n", sec);

	if (sec < 0.0)
		sec = 0.0;
    } else {
	ffmpeg_printf(10, "seeking %f sec\n", sec);

	if (sec == 0.0)
	{
	    ffmpeg_err("sec = 0.0 ignoring\n");
	    return cERR_CONTAINER_FFMPEG_ERR;
	}
    }
    context->manager->video->Command(context, MANAGER_GET_TRACK, &videoTrack);
    context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack);

    if (videoTrack != NULL)
	current = videoTrack;
    else if (audioTrack != NULL)
	current = audioTrack;

    if (current == NULL) {
	ffmpeg_err( "no track available to seek\n");
	return cERR_CONTAINER_FFMPEG_ERR;
    }

    if (sec < 0)
	seek_target_flag |= AVSEEK_FLAG_BACKWARD;

    getMutex(FILENAME, __FUNCTION__,__LINE__);

    if (!context->playback || !context->playback->isPlaying) {
    	releaseMutex(FILENAME, __FUNCTION__,__LINE__);
	return cERR_CONTAINER_FFMPEG_NO_ERROR;
    }

    ffmpeg_printf(10, "iformat->flags %d\n", avContext->iformat->flags);

    if (avContext->iformat->flags & AVFMT_TS_DISCONT)
    {
/* konfetti: for ts streams seeking frame per seconds does not work (why?).
 * I take this algo partly from ffplay.c.
 *
 * seeking per HTTP does still not work very good. forward seeks everytime
 * about 10 seconds, backward does not work.
 */

	off_t pos = avio_tell(avContext->pb);

	ffmpeg_printf(10, "pos %lld %d\n", pos, avContext->bit_rate);

	if (avContext->bit_rate)
	{
	    sec *= avContext->bit_rate / 8.0;
	    ffmpeg_printf(10, "bit_rate %d\n", avContext->bit_rate);
	}
	else
	{
	    sec *= 180000.0;
	}
	if (absolute)
	    pos = sec;
	else
	    pos += sec;
	if (pos < 0)
	   pos = 0;

	ffmpeg_printf(10, "1. seeking to position %lld bytes ->sec %f\n", pos, sec);

	seek_target_bytes = pos;
	do_seek_target_bytes = 1;

    } else
    {
	if (!absolute)
	    sec += ((float) current->pts / 90000.0f);
	ffmpeg_printf(10, "2. seeking to position %f sec ->time base %f %d\n", sec, av_q2d(((AVStream*) current->stream)->time_base), AV_TIME_BASE);

	seek_target_seconds = sec * AV_TIME_BASE;
	do_seek_target_seconds = 1;
    }

    releaseMutex(FILENAME, __FUNCTION__,__LINE__);
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_get_length(Context_t *context, double * length) {
    ffmpeg_printf(50, "\n");
    Track_t * videoTrack = NULL;
    Track_t * audioTrack = NULL;
    Track_t * subtitleTrack = NULL;
    Track_t * current = NULL;

    if (length == NULL) {
	ffmpeg_err( "null pointer passed\n");
	return cERR_CONTAINER_FFMPEG_ERR;
    }

    context->manager->video->Command(context, MANAGER_GET_TRACK, &videoTrack);
    context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack);
    context->manager->subtitle->Command(context, MANAGER_GET_TRACK, &subtitleTrack);

    if (videoTrack != NULL)
	current = videoTrack;
    else if (audioTrack != NULL)
	current = audioTrack;
    else if (subtitleTrack != NULL)
	current = subtitleTrack;

    *length = 0.0;

    if (current != NULL) {
	if (current->duration == 0)
	    return cERR_CONTAINER_FFMPEG_ERR;
	else
	    *length = (current->duration / 1000.0);
    }
    else {
	if (avContext != NULL)
	{
	    *length = (avContext->duration / 1000.0);
	} else
	{
	   ffmpeg_err( "no Track not context ->no problem :D\n");
	   return cERR_CONTAINER_FFMPEG_ERR;
	}
    }

    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_switch_audio(Context_t* context, int* arg)
{
    ffmpeg_printf(10, "track %d\n", *arg);
    /* Hellmaster1024: nothing to do here!*/
    float sec=-5.0;
    context->playback->Command(context, PLAYBACK_SEEK, (void*)&sec);
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_switch_subtitle(Context_t* context __attribute__((unused)), int* arg __attribute__((unused)))
{
    /* Hellmaster1024: nothing to do here!*/
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_switch_dvbsubtitle(Context_t* context __attribute__((unused)), int* arg __attribute__((unused)))
{
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

static int container_ffmpeg_switch_teletext(Context_t* context __attribute__((unused)), int* arg __attribute__((unused)))
{
    return cERR_CONTAINER_FFMPEG_NO_ERROR;
}

/* konfetti comment: I dont like the mechanism of overwriting
 * the pointer in infostring. This lead in most cases to
 * user errors, like it is in the current version (libeplayer2 <-->e2->servicemp3.cpp)
 * From e2 there is passed a tag=strdup here and we overwrite this
 * strdupped tag. This lead to dangling pointers which are never freed!
 * I do not free the string here because this is the wrong way. The mechanism
 * should be changed, or e2 should pass it in a different way...
 */
static int container_ffmpeg_get_info(Context_t* context, char ** infoString)
{
    Track_t * videoTrack = NULL;
    Track_t * audioTrack = NULL;
    char*     meta = NULL;

    ffmpeg_printf(20, ">\n");

    if (avContext != NULL)
    {
       if ((infoString == NULL) || (*infoString == NULL))
       {
	   ffmpeg_err("infostring NULL\n");
	   return cERR_CONTAINER_FFMPEG_ERR;
       }

       ffmpeg_printf(20, "%s\n", *infoString);

       context->manager->video->Command(context, MANAGER_GET_TRACK, &videoTrack);
       context->manager->audio->Command(context, MANAGER_GET_TRACK, &audioTrack);

       if ((meta = searchMeta(avContext->metadata, *infoString)) == NULL)
       {
	   if (audioTrack != NULL)
	   {
	       AVStream* stream = audioTrack->stream;

	       meta = searchMeta(stream->metadata, *infoString);
	   }

	   if ((meta == NULL) && (videoTrack != NULL))
	   {
	       AVStream* stream = videoTrack->stream;

	       meta = searchMeta(stream->metadata, *infoString);
	   }
       }

       if (meta != NULL)
       {
	  *infoString = strdup(meta);
       }
       else
       {
	  ffmpeg_printf(1, "no metadata found for \"%s\"\n", *infoString);
	  *infoString = strdup("not found");
       }
    } else
    {
	ffmpeg_err("avContext NULL\n");
	return cERR_CONTAINER_FFMPEG_ERR;
    }

    return cERR_CONTAINER_FFMPEG_NO_ERROR;

}

static int Command(void  *_context, ContainerCmd_t command, void * argument)
{
    Context_t  *context = (Context_t*) _context;
    int ret = cERR_CONTAINER_FFMPEG_NO_ERROR;

    ffmpeg_printf(50, "Command %d\n", command);

    if(command != CONTAINER_SET_BUFFER_SEEK_TIME && command != CONTAINER_SET_BUFFER_SIZE && command != CONTAINER_GET_BUFFER_SIZE && command !=CONTAINER_GET_BUFFER_STATUS && command != CONTAINER_STOP_BUFFER && command != CONTAINER_INIT && !avContext)
        return cERR_CONTAINER_FFMPEG_ERR;
		
		switch(command)
    {
    case CONTAINER_INIT:  {
	char * filename = (char *)argument;
	ret = container_ffmpeg_init(context, filename);
	break;
    }
    case CONTAINER_PLAY:  {
	ret = container_ffmpeg_play(context);
	break;
    }
    case CONTAINER_STOP:  {
	ret = container_ffmpeg_stop(context);
	break;
    }
    case CONTAINER_SEEK: {
	ret = container_ffmpeg_seek(context, (float)*((float*)argument), 0);
	break;
    }
    case CONTAINER_SEEK_ABS: {
	ret = container_ffmpeg_seek(context, (float)*((float*)argument), -1);
	break;
    }
    case CONTAINER_LENGTH: {
	double length = 0;
	ret = container_ffmpeg_get_length(context, &length);

	*((double*)argument) = (double)length;
	break;
    }
    case CONTAINER_SWITCH_AUDIO: {
	ret = container_ffmpeg_switch_audio(context, (int*) argument);
	break;
    }
    case CONTAINER_SWITCH_SUBTITLE: {
	ret = container_ffmpeg_switch_subtitle(context, (int*) argument);
	break;
    }
    case CONTAINER_INFO: {
	ret = container_ffmpeg_get_info(context, (char **)argument);
	break;
    }
    case CONTAINER_STATUS: {
	*((int*)argument) = hasPlayThreadStarted;
	break;
    }
    case CONTAINER_LAST_PTS: {
	*((long long int*)argument) = latestPts;
	break;
    }
    case CONTAINER_SWITCH_DVBSUBTITLE: {
	ret = container_ffmpeg_switch_dvbsubtitle(context, (int*) argument);
	break;
    }
    case CONTAINER_SWITCH_TELETEXT: {
	ret = container_ffmpeg_switch_teletext(context, (int*) argument);
	break;
    }
    case CONTAINER_SET_BUFFER_SEEK_TIME: {
    ret = container_set_ffmpeg_buf_seek_time((int*) argument);
    break;
    }
    case CONTAINER_SET_BUFFER_SIZE: {
    ret = container_set_ffmpeg_buf_size((int*) argument);
    break;
    }
    case CONTAINER_GET_BUFFER_SIZE: {
    int size = 0;
    ret = container_get_ffmpeg_buf_size(&size);
    *((int*)argument) = size;
    break;
    }
    case CONTAINER_GET_BUFFER_STATUS: {
    int size = 0;
    ret = container_get_fillbufstatus(&size);
    *((int*)argument) = size;
    break;
    }
    case CONTAINER_STOP_BUFFER: {
    ret = container_stop_buffer();
    break;
    }    
    default:
	ffmpeg_err("ContainerCmd %d not supported!\n", command);
	ret = cERR_CONTAINER_FFMPEG_ERR;
	break;
    }

    ffmpeg_printf(50, "exiting with value %d\n", ret);

    return ret;
}

static char *FFMPEG_Capabilities[] = {"avi", "mkv", "mp4", "ts", "mov", "flv", "flac", "mp3", "mpg", "m2ts", "vob", "wmv","wma", "asf", "mp2", "m4v", "m4a", "divx", "dat", "mpeg", "trp", "mts", "vdr", "ogg", "wav", "wtv", "asx", "mvi", "png", "jpg", "ra", "ram", "rm", NULL };

Container_t FFMPEGContainer = {
    "FFMPEG",
    &Command,
    FFMPEG_Capabilities
};
