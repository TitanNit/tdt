/*
 * Copyright (C) STMicroelectronics Limited 2008. All rights reserved.
 *
 * file name:   VideoCompanion.h
 *
 * AUTOMATICALLY GENERATED - DO NOT EDIT
 */

#ifndef VIDEO_COMPANION_H
#define VIDEO_COMPANION_H

typedef int ST_ErrorCode_t ;
typedef unsigned int U32;
typedef   signed int S32;
typedef int BOOL;
typedef unsigned char U8;

#if defined (CONFIG_CPU_SUBTYPE_STB7100)

  #define DELTA_VERSION_DELTAMU_GREEN 
  #define DELTA_BASE_ADDRESS	0x19540000 
  #define MAILBOX_BASE_ADDRESS	0x19211000 
  #define mb411_video 
  #define SOC_NAME_STi7109 
  #define SOC_CUT	30 
  #define FORCE_IPF_DOWNLOAD_FIRMWARE 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7105)

  #define DELTA_VERSION_DELTAMU_RASTA 
  #define DELTA_BASE_ADDRESS	0xFE540000 
  #define MAILBOX_BASE_ADDRESS	0xFE211000 
  #define mb680_video 
  #define SOC_NAME_STi7105 
  #define SOC_CUT	30 
  #define SUPPORT_HIGH_PROFILE 
  #define SUPPORT_HIGH_PROFILE_FOR_INTER_PICTURES 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7106)

  #define DELTA_VERSION_DELTAMU_RASTA_E 
  #define DELTA_BASE_ADDRESS	0xFE540000 
  #define MAILBOX_BASE_ADDRESS	0xFE211000 
  #define mb680_video 
  #define SOC_NAME_STi7106 
  #define SOC_CUT	10 
  #define SUPPORT_HIGH_PROFILE 
  #define SUPPORT_HIGH_PROFILE_FOR_INTER_PICTURES 
  #define TRANSFORMER_AVSDEC_HD 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7108)

  #define DELTA_VERSION_DELTAMU_RASTA_E 
  #define DELTA_VERSION_DELTAMU_RED 
  #define DELTA_BASE_ADDRESS	0xFDE00000 
  #define MAILBOX_BASE_ADDRESS	0xFDABF000 
  #define TRANSFORMER_AVSDEC_HD 
  #define mb837_video 
  #define SOC_NAME_STi7108 
  #define SOC_CUT	10 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7111)

  #define FORCE_IPF_DOWNLOAD_FIRMWARE 
  #define DELTA_VERSION_DELTAMU_GREEN 
  #define DELTA_BASE_ADDRESS	0xFE540000 
  #define MAILBOX_BASE_ADDRESS	0xFE211000 
  #define mb618_video 
  #define SOC_NAME_STi7111 
  #define SOC_CUT	10 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7141)

  #define FORCE_IPF_DOWNLOAD_FIRMWARE 
  #define DELTA_VERSION_DELTAMU_GREEN 
  #define DELTA_BASE_ADDRESS	0xFE540000 
  #define MAILBOX_BASE_ADDRESS	0xFE211000 
  #define mb628_video 
  #define SOC_NAME_STi7141 
  #define SOC_CUT	10 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#elif defined(CONFIG_CPU_SUBTYPE_STX7200)

  #define FORCE_IPF_DOWNLOAD_FIRMWARE 
  #define DELTA_VERSION_DELTAMU_GREEN 
  #define DELTA_BASE_ADDRESS	0xfd900000 
  #define MAILBOX_BASE_ADDRESS	0xfd801000 
  #define mb519_video1 
  #define SOC_NAME_STi7200 
  #define SOC_CUT	10 
  #define TRANSFORMER_EVENT_LOG 
  #define VIDEO_COMPANION_ONLY 
  #define MULTICOM 
  #define HOST_DELTA_COM_MULTICOM 
  #define SHARED_MEMORY_ADDRESS	0 
  #define SHARED_MEMORY_SIZE	0 
  #define PLATFORM_RTL 
  #define H264_MME_VERSION	42 
  #define MPEG4P2_MME_VERSION	12 
  #define RV89DEC_MME_VERSION	12 
  #define THEORADEC_MME_VERSION	30 
  #define VC9_MME_VERSION	16 
  #define SUPPORT_DPART 
  #define ERC 
  #define SUPPORT_ALL_VERSIONS 
  #define CEH_SUPPORT 
  #define OS21_TASKS 
  #define TRANSFORMER_H264DEC 
  #define TRANSFORMER_JPEGDECHW 
  #define TRANSFORMER_JPEGDEC 
  #define TRANSFORMER_PNGDEC 
  #define PNGDEC_MME_VERSION	11

#else
  #error Please define a correct CONFIG_CPU_SUBTYPE
#endif

#include <MPEG2_VideoTransformerTypes.h>
#include <H264_VideoTransformerTypes.h>
#include <VC9_VideoTransformerTypes.h>
#include <FLV1_VideoTransformerTypes.h>
#include <DivXHD_decoderTypes.h> 
#include <DivX_decoderTypes.h> 
#include <H263Dec_TransformerTypes.h> 
#include <VP6_VideoTransformerTypes.h> 
#include <TheoraDecode_interface.h> 
#include <RV89Decode_interface.h> 
#include <JPEGDECHW_VideoTransformerTypes.h> 
#include <PNGDecode_interface_video.h> 
#include <AVS_SD_decoderTypes.h> 
//#include <AVS_HD_VideoTransformerTypes.h> 
#include <EVENT_Log_TransformerTypes.h> 

#endif /* VIDEO_COMPANION_H */
