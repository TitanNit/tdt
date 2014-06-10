#
# liblua
#
$(DEPDIR)/liblua: bootstrap ncurses $(archivedir)/luaposix.git @DEPENDS_liblua@
	@PREPARE_liblua@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_liblua@ && \
		$(BUILDENV) \
		cp -r $(archivedir)/luaposix.git .; \
		cd luaposix.git/ext; cp posix/posix.c include/lua52compat.h ../../src/; cd ../..; \
		sed -i 's/<config.h>/"config.h"/' src/posix.c; \
		sed -i '/^#define/d' src/lua52compat.h; \
		sed -i 's@^#define LUA_ROOT.*@#define LUA_ROOT "/"@' src/luaconf.h; \
		sed -i '/^#define LUA_USE_READLINE/d' src/luaconf.h; \
		sed -i 's/ -lreadline//' src/Makefile; \
		$(MAKE) linux CC='$(target)-gcc' LDFLAGS="-L$(targetprefix)/usr/lib" && \
		@INSTALL_liblua@
	@DISTCLEANUP_liblua@
	touch $@

#
# libao
#
$(DEPDIR)/libao: bootstrap @DEPENDS_libao@
	@PREPARE_libao@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libao@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libao@
	@DISTCLEANUP_libao@
	touch $@

#
# howl
#
$(DEPDIR)/howl: bootstrap @DEPENDS_howl@
	@PREPARE_howl@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_howl@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_howl@
	@DISTCLEANUP_howl@
	touch $@

#
# libboost
#
$(DEPDIR)/libboost: bootstrap @DEPENDS_libboost@
	@PREPARE_libboost@
	cd @DIR_libboost@ && \
		@INSTALL_libboost@
	@DISTCLEANUP_libboost@
	touch $@

#
# libz
#
$(DEPDIR)/libz: bootstrap @DEPENDS_libz@
	@PREPARE_libz@
	cd @DIR_libz@ && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--shared && \
		$(MAKE) && \
		@INSTALL_libz@
	@DISTCLEANUP_libz@
	touch $@

#
# libreadline
#
$(DEPDIR)/libreadline: bootstrap ncurses-dev @DEPENDS_libreadline@
	@PREPARE_libreadline@
	cd @DIR_libreadline@ && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			bash_cv_must_reinstall_sighandlers=no \
			bash_cv_func_sigsetjmp=present \
			bash_cv_func_strcoll_broken=no \
			bash_cv_have_mbstate_t=yes \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libreadline@
	@DISTCLEANUP_libreadline@
	touch $@

#
# libfreetype
#
$(DEPDIR)/libfreetype: bootstrap libpng @DEPENDS_libfreetype@
	@PREPARE_libfreetype@
	cd @DIR_libfreetype@ && \
		sed -i '/#define FT_CONFIG_OPTION_OLD_INTERNALS/d' include/freetype/config/ftoption.h && \
		sed -i '/^FONT_MODULES += \(type1\|cid\|pfr\|type42\|pcf\|bdf\)/d' modules.cfg && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config && \
		ln -sf $(crossprefix)/bin/freetype-config $(crossprefix)/bin/$(target)-freetype-config && \
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype && \
		@INSTALL_libfreetype@
	@DISTCLEANUP_libfreetype@
	touch $@

#
# lirc
#
$(DEPDIR)/lirc: bootstrap @DEPENDS_lirc@
	@PREPARE_lirc@
	cd @DIR_lirc@ && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed && \
		$(MAKE) all && \
		@INSTALL_lirc@
	@DISTCLEANUP_lirc@
	touch $@

#
# libjpeg
#
$(DEPDIR)/libjpeg: bootstrap @DEPENDS_libjpeg@
	@PREPARE_libjpeg@
	cd @DIR_libjpeg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libjpeg@
	@DISTCLEANUP_libjpeg@
	touch $@

#
# libjpeg_turbo
#
$(DEPDIR)/libjpeg_turbo: bootstrap @DEPENDS_libjpeg_turbo@
	@PREPARE_libjpeg_turbo@
	cd @DIR_libjpeg_turbo@ && \
		export CC=$(target)-gcc && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--disable-static \
			--with-jpeg8 \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libjpeg_turbo@
	cd @DIR_libjpeg_turbo@ && \
		make clean && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--disable-static \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libjpeg_turbo@
	@DISTCLEANUP_libjpeg_turbo@
	touch $@

#
# libpng12
#
$(DEPDIR)/libpng12: bootstrap @DEPENDS_libpng12@
	@PREPARE_libpng12@
	cd @DIR_libpng12@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		@INSTALL_libpng@
	@DISTCLEANUP_libpng12@
	touch $@

#
# libpng
#
$(DEPDIR)/libpng: bootstrap libz @DEPENDS_libpng@
	@PREPARE_libpng@
	cd @DIR_libpng@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		sed -e 's,^prefix="/usr",prefix="$(targetprefix)/usr",' < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		@INSTALL_libpng@
	@DISTCLEANUP_libpng@
	touch $@

#
# libungif
#
$(DEPDIR)/libungif: bootstrap @DEPENDS_libungif@
	@PREPARE_libungif@
	cd @DIR_libungif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE) && \
		@INSTALL_libungif@
	@DISTCLEANUP_libungif@
	touch $@

#
# libgif
#
$(DEPDIR)/libgif: bootstrap @DEPENDS_libgif@
	@PREPARE_libgif@
	cd @DIR_libgif@ && \
		export ac_cv_prog_have_xmlto=no && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--bindir=/.remove \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libgif@
	@DISTCLEANUP_libgif@
	touch $@

#
# libgif_e2
#
$(DEPDIR)/libgif_e2: bootstrap @DEPENDS_libgif_e2@
	@PREPARE_libgif_e2@
	cd @DIR_libgif_e2@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE) && \
		@INSTALL_libgif_e2@
	@DISTCLEANUP_libgif_e2@
	touch $@

#
# libcurl
#
$(DEPDIR)/libcurl: bootstrap openssl rtmpdump @DEPENDS_libcurl@
	@PREPARE_libcurl@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcurl@ && \
		autoreconf -vif -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-ssl \
			--disable-debug \
			--disable-verbose \
			--disable-manual \
			--with-random && \
		$(MAKE) all && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config && \
		@INSTALL_libcurl@
	@DISTCLEANUP_libcurl@
	touch $@

#
# libfribidi
#
$(DEPDIR)/libfribidi: bootstrap @DEPENDS_libfribidi@
	@PREPARE_libfribidi@
	cd @DIR_libfribidi@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-shared \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libfribidi@
	@DISTCLEANUP_libfribidi@
	touch $@

#
# libsigc
#
$(DEPDIR)/libsigc: bootstrap libstdc++-dev @DEPENDS_libsigc@
	@PREPARE_libsigc@
	cd @DIR_libsigc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks && \
		$(MAKE) all && \
		@INSTALL_libsigc@
	@DISTCLEANUP_libsigc@
	touch $@

#
# libmad
#
$(DEPDIR)/libmad: bootstrap @DEPENDS_libmad@
	@PREPARE_libmad@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmad@ && \
		touch NEWS AUTHORS ChangeLog; \
		autoreconf -fi -I$(hostprefix)/share/aclocal; \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso && \
		$(MAKE) all && \
		@INSTALL_libmad@
	@DISTCLEANUP_libmad@
	touch $@

#
# libid3tag
#
$(DEPDIR)/libid3tag: bootstrap @DEPENDS_libid3tag@
	@PREPARE_libid3tag@
	cd @DIR_libid3tag@ && \
		touch NEWS AUTHORS ChangeLog && \
		autoreconf -fi && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared=yes && \
		$(MAKE) all && \
		@INSTALL_libid3tag@
	@DISTCLEANUP_libid3tag@
	touch $@

#
# libvorbis
#
$(DEPDIR)/libvorbis: bootstrap libogg @DEPENDS_libvorbis@
	@PREPARE_libvorbis@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libvorbis@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libvorbis@
	@DISTCLEANUP_libvorbis@
	touch $@

#
# libvorbisidec
#
$(DEPDIR)/libvorbisidec: bootstrap libogg @DEPENDS_libvorbisidec@
	@PREPARE_libvorbisidec@
	cd @DIR_libvorbisidec@ && \
		ACLOCAL_FLAGS="-I . -I $(targetprefix)/usr/share/aclocal" \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libvorbisidec@
	@DISTCLEANUP_libvorbisidec@
	touch $@

#
# libglib2
# You need libglib2.0-dev on host system
#
$(DEPDIR)/glib2: bootstrap libffi @DEPENDS_glib2@
	@PREPARE_glib2@
	echo "glib_cv_va_copy=no" > @DIR_glib2@/config.cache
	echo "glib_cv___va_copy=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_va_val_copy=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_stack_grows=no" >> @DIR_glib2@/config.cache
	echo "glib_cv_uscore=no" >> @DIR_glib2@/config.cache
	cd @DIR_glib2@ && \
		$(BUILDENV) \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_glib2@
	@DISTCLEANUP_glib2@
	touch $@

#
# libiconv
#
$(DEPDIR)/libiconv: bootstrap @DEPENDS_libiconv@
	@PREPARE_libiconv@
	cd @DIR_libiconv@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		cp ./srcm4/* $(hostprefix)/share/aclocal/ && \
		@INSTALL_libiconv@
	@DISTCLEANUP_libiconv@
	touch $@

#
# libmng
#
$(DEPDIR)/libmng: bootstrap libjpeg lcms @DEPENDS_libmng@
	@PREPARE_libmng@
	cd @DIR_libmng@ && \
		cat unmaintained/autogen.sh | tr -d \\r > autogen.sh && chmod 755 autogen.sh && \
		[ ! -x ./configure ] && ./autogen.sh --help || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static \
			--with-zlib \
			--with-jpeg \
			--with-gnu-ld \
			--with-lcms && \
		$(MAKE) && \
		@INSTALL_libmng@
	@DISTCLEANUP_libmng@
	touch $@

#
# lcms
#
$(DEPDIR)/lcms: bootstrap libjpeg @DEPENDS_lcms@
	@PREPARE_lcms@
	cd @DIR_lcms@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static && \
		$(MAKE) && \
		@INSTALL_lcms@
	@DISTCLEANUP_lcms@
	touch $@

#
# directfb
#
$(DEPDIR)/directfb: bootstrap libfreetype @DEPENDS_directfb@
	@PREPARE_directfb@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_directfb@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--disable-sdl \
			--disable-x11 \
			--disable-devmem \
			--disable-multi \
			--with-gfxdrivers=stgfx \
			--with-inputdrivers=linuxinput,enigma2remote \
			--without-software \
			--enable-stmfbdev \
			--disable-fbdev \
			--enable-mme=yes && \
			export top_builddir=`pwd` && \
		$(MAKE) LD=$(target)-ld && \
		@INSTALL_directfb@
	@DISTCLEANUP_directfb@
	touch $@

#
# DFB++
#
$(DEPDIR)/dfbpp: bootstrap libjpeg directfb @DEPENDS_dfbpp@
	@PREPARE_dfbpp@
	cd @DIR_dfbpp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
			export top_builddir=`pwd` && \
		$(MAKE) all && \
		@INSTALL_dfbpp@
	@DISTCLEANUP_dfbpp@
	touch $@

#
# LIBSTGLES
#
$(DEPDIR)/libstgles: bootstrap directfb @DEPENDS_libstgles@
	@PREPARE_libstgles@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libstgles@ && \
		cp --remove-destination $(hostprefix)/share/libtool/config/ltmain.sh . && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libstgles@
	@DISTCLEANUP_libstgles@
	touch $@

#
# libexpat
#
$(DEPDIR)/libexpat: bootstrap @DEPENDS_libexpat@
	@PREPARE_libexpat@
	cd @DIR_libexpat@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libexpat@
	@DISTCLEANUP_libexpat@
	touch $@

#
# fontconfig
#
$(DEPDIR)/fontconfig: bootstrap libexpat libfreetype @DEPENDS_fontconfig@
	@PREPARE_fontconfig@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_fontconfig@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(crossprefix)/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts && \
		$(MAKE) && \
		@INSTALL_fontconfig@
	@DISTCLEANUP_fontconfig@
	touch $@

#
# libxmlccwrap
#
$(DEPDIR)/libxmlccwrap: bootstrap @DEPENDS_libxmlccwrap@
	@PREPARE_libxmlccwrap@
	cd @DIR_libxmlccwrap@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libxmlccwrap@ && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la
	@DISTCLEANUP_libxmlccwrap@
	touch $@

#
# a52dec
#
$(DEPDIR)/a52dec: bootstrap @DEPENDS_a52dec@
	@PREPARE_a52dec@
	cd @DIR_a52dec@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_a52dec@
	@DISTCLEANUP_a52dec@
	touch $@

#
# libdvdcss
#
$(DEPDIR)/libdvdcss: bootstrap @DEPENDS_libdvdcss@
	@PREPARE_libdvdcss@
	cd @DIR_libdvdcss@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-doc && \
		$(MAKE) all && \
		@INSTALL_libdvdcss@
	@DISTCLEANUP_libdvdcss@
	touch $@

#
# libdvdnav
#
$(DEPDIR)/libdvdnav: bootstrap libdvdread @DEPENDS_libdvdnav@
	@PREPARE_libdvdnav@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdnav@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			--with-dvdread-config=$(crossprefix)/bin/dvdread-config && \
		$(MAKE) all && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdnav-config > $(crossprefix)/bin/dvdnav-config && \
		chmod 755 $(crossprefix)/bin/dvdnav-config && \
		@INSTALL_libdvdnav@
	@DISTCLEANUP_libdvdnav@
	touch $@

#
# libdvdread
#
$(DEPDIR)/libdvdread: bootstrap @DEPENDS_libdvdread@
	@PREPARE_libdvdread@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdread@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-static \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdread-config > $(crossprefix)/bin/dvdread-config && \
		chmod 755 $(crossprefix)/bin/dvdread-config && \
		@INSTALL_libdvdread@
	@DISTCLEANUP_libdvdread@
	touch $@

#
# libdreamdvd2
#
$(DEPDIR)/libdreamdvd2: bootstrap libdvdnav @DEPENDS_libdreamdvd2@
	@PREPARE_libdreamdvd2@
	[ -d "$(archivedir)/libdreamdvd.git" ] && \
	(cd $(archivedir)/libdreamdvd.git; git pull ; cd "$(buildprefix)";); \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd2@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		automake --foreign --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libdreamdvd2@
	@DISTCLEANUP_libdreamdvd2@
	touch $@

#
# libdreamdvd
#
$(DEPDIR)/libdreamdvd: bootstrap @DEPENDS_libdreamdvd@
	@PREPARE_libdreamdvd@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libdreamdvd@
	@DISTCLEANUP_libdreamdvd@
	touch $@

#
# ffmpeg
#
FFMPEG_CONFIGURE  = --disable-static --enable-shared --enable-small --disable-runtime-cpudetect
FFMPEG_CONFIGURE += --disable-ffserver --disable-ffplay --disable-ffprobe
FFMPEG_CONFIGURE += --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages
FFMPEG_CONFIGURE += --disable-asm --disable-altivec --disable-amd3dnow --disable-amd3dnowext --disable-mmx --disable-mmxext
FFMPEG_CONFIGURE += --disable-sse --disable-sse2 --disable-sse3 --disable-ssse3 --disable-sse4 --disable-sse42 --disable-avx --disable-fma4
FFMPEG_CONFIGURE += --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-vfp --disable-neon --disable-vis --disable-inline-asm
FFMPEG_CONFIGURE += --disable-yasm --disable-mips32r2 --disable-mipsdspr1 --disable-mipsdspr2 --disable-mipsfpu --disable-fast-unaligned
FFMPEG_CONFIGURE += --disable-muxers
FFMPEG_CONFIGURE += --enable-muxer=flac --enable-muxer=mp3 --enable-muxer=h261 --enable-muxer=h263 --enable-muxer=h264
FFMPEG_CONFIGURE += --enable-muxer=image2 --enable-muxer=mpeg1video --enable-muxer=mpeg2video --enable-muxer=ogg
FFMPEG_CONFIGURE += --disable-encoders
FFMPEG_CONFIGURE += --enable-encoder=aac --enable-encoder=h261 --enable-encoder=h263 --enable-encoder=h263p --enable-encoder=ljpeg
FFMPEG_CONFIGURE += --enable-encoder=mjpeg --enable-encoder=mpeg1video --enable-encoder=mpeg2video --enable-encoder=png
FFMPEG_CONFIGURE += --disable-decoders
FFMPEG_CONFIGURE += --enable-decoder=aac --enable-decoder=dvbsub --enable-decoder=dvdsub --enable-decoder=flac --enable-decoder=h261 --enable-decoder=h263
FFMPEG_CONFIGURE += --enable-decoder=h263i --enable-decoder=h264 --enable-decoder=iff_byterun1 --enable-decoder=mjpeg
FFMPEG_CONFIGURE += --enable-decoder=mp3 --enable-decoder=mpeg1video --enable-decoder=mpeg2video --enable-decoder=png
FFMPEG_CONFIGURE += --enable-decoder=theora --enable-decoder=vorbis --enable-decoder=wmv3 --enable-decoder=pcm_s16le
FFMPEG_CONFIGURE += --enable-decoder=rawvideo --enable-decoder=wmapro --enable-decoder=wmav1 --enable-decoder=wmav2 --enable-decoder=wmavoice
FFMPEG_CONFIGURE += --enable-decoder=iff_byterun1 --enable-decoder=ra_144 --enable-decoder=ra_288
FFMPEG_CONFIGURE += --enable-demuxer=mjpeg --enable-demuxer=wav --enable-demuxer=rtsp
FFMPEG_CONFIGURE += --enable-parser=mjpeg
FFMPEG_CONFIGURE += --disable-indevs --disable-outdevs --disable-bsfs --disable-debug
FFMPEG_CONFIGURE += --enable-pthreads --enable-bzlib --enable-zlib --enable-librtmp --enable-stripping

$(DEPDIR)/ffmpeg: bootstrap libass rtmpdump @DEPENDS_ffmpeg@
	@PREPARE_ffmpeg@
	cd @DIR_ffmpeg@ && \
		$(BUILDENV) \
		./configure \
			$(FFMPEG_CONFIGURE) \
			--enable-cross-compile \
			--pkg-config="pkg-config" \
			--cross-prefix=$(target)- \
			--target-os=linux \
			--arch=sh4 \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_ffmpeg@
	@DISTCLEANUP_ffmpeg@
	touch $@

$(DEPDIR)/ffmpeg_old: bootstrap libass rtmpdump @DEPENDS_ffmpeg_old@
	@PREPARE_ffmpeg_old@
	cd @DIR_ffmpeg_old@; \
		$(BUILDENV) \
		./configure \
			$(FFMPEG_CONFIGURE) \
			--enable-avresample \
			--pkg-config="pkg-config" \
			--enable-cross-compile \
			--cross-prefix=$(target)- \
			--target-os=linux \
			--arch=sh4 \
			--prefix=/usr; \
		$(MAKE); \
		@INSTALL_ffmpeg_old@
	@DISTCLEANUP_ffmpeg_old@
	touch $@

#
# libass
#
$(DEPDIR)/libass: bootstrap libfreetype libfribidi @DEPENDS_libass@
	@PREPARE_libass@
	cd @DIR_libass@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-fontconfig \
			--disable-enca && \
		$(MAKE) && \
		@INSTALL_libass@
	@DISTCLEANUP_libass@
	touch $@

#
# WebKitDFB
#
$(DEPDIR)/webkitdfb: bootstrap glib2 icu4c libxml2 enchant lite libcurl fontconfig sqlite libsoup cairo libjpeg @DEPENDS_webkitdfb@
	@PREPARE_webkitdfb@
	export PATH=$(buildprefix)/@DIR_icu4c@/host/config:$(PATH) && \
	cd @DIR_webkitdfb@ && \
		$(BUILDENV) \
		./autogen.sh \
			--with-target=directfb \
			--without-gtkplus \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-cairo-directfb \
			--disable-shared-workers \
			--enable-optimizations \
			--disable-channel-messaging \
			--disable-javascript-debugger \
			--enable-offline-web-applications \
			--enable-dom-storage \
			--enable-database \
			--disable-eventsource \
			--enable-icon-database \
			--enable-datalist \
			--disable-video \
			--enable-svg \
			--enable-xpath \
			--disable-xslt \
			--disable-dashboard-support \
			--disable-geolocation \
			--disable-workers \
			--disable-web-sockets \
			--with-networking-backend=soup && \
		$(MAKE) && \
		@INSTALL_webkitdfb@
	@DISTCLEANUP_webkitdfb@
	touch $@

#
# icu4c
#
$(DEPDIR)/icu4c: bootstrap @DEPENDS_icu4c@
	@PREPARE_icu4c@
	cd @DIR_icu4c@ && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < $(buildprefix)/Patches/icu4c-4_4_1_locales.patch;
		echo "Building host icu"
		mkdir -p @DIR_icu4c@/host && \
		cd @DIR_icu4c@/host && \
		sh ../configure --disable-samples --disable-tests && \
		unset TARGET && \
		make
		echo "Building cross icu"
		cd @DIR_icu4c@ && \
		$(BUILDENV) \
		./configure \
			--with-cross-build=$(buildprefix)/@DIR_icu4c@/host \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-extras \
			--disable-layout \
			--disable-tests \
			--disable-samples && \
		unset TARGET && \
		@INSTALL_icu4c@
	@DISTCLEANUP_icu4c@
	rm -rf icu
	touch $@

#
# enchant
#
$(DEPDIR)/enchant: bootstrap glib2 @DEPENDS_enchant@
	@PREPARE_enchant@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_enchant@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-gnu-ld \
			--disable-aspell \
			--disable-ispell \
			--disable-myspell \
			--disable-zemberek && \
		$(MAKE) LD=$(target)-ld && \
		@INSTALL_enchant@
	@DISTCLEANUP_enchant@
	touch $@

#
# lite
#
$(DEPDIR)/lite: bootstrap directfb @DEPENDS_lite@
	@PREPARE_lite@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lite@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debug && \
		$(MAKE) && \
		@INSTALL_lite@
	@DISTCLEANUP_lite@
	touch $@

#
# sqlite
#
$(DEPDIR)/sqlite: bootstrap @DEPENDS_sqlite@
	@PREPARE_sqlite@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sqlite@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_sqlite@
	@DISTCLEANUP_sqlite@
	touch $@

#
# libsoup
#
$(DEPDIR)/libsoup: bootstrap @DEPENDS_libsoup@
	@PREPARE_libsoup@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsoup@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-more-warnings \
			--without-gnome && \
		$(MAKE) && \
		@INSTALL_libsoup@
	@DISTCLEANUP_libsoup@
	touch $@

#
# pixman
#
$(DEPDIR)/pixman: bootstrap @DEPENDS_pixman@
	@PREPARE_pixman@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_pixman@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_pixman@
	@DISTCLEANUP_pixman@
	touch $@

#
# cairo
#
$(DEPDIR)/cairo: bootstrap libpng pixman @DEPENDS_cairo@
	@PREPARE_cairo@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_cairo@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-gtk-doc \
			--enable-ft=yes \
			--enable-png=yes \
			--enable-ps=no \
			--enable-pdf=no \
			--enable-svg=no \
			--disable-glitz \
			--disable-xcb \
			--disable-xlib \
			--enable-directfb \
			--program-suffix=-directfb && \
		$(MAKE) && \
		@INSTALL_cairo@
	@DISTCLEANUP_cairo@
	touch $@

#
# libogg
#
$(DEPDIR)/libogg: bootstrap @DEPENDS_libogg@
	@PREPARE_libogg@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libogg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libogg@
	@DISTCLEANUP_libogg@
	touch $@

#
# libflac
#
$(DEPDIR)/libflac: bootstrap @DEPENDS_libflac@
	@PREPARE_libflac@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libflac@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-ogg \
			--disable-altivec && \
		$(MAKE) && \
		@INSTALL_libflac@
	@DISTCLEANUP_libflac@
	touch $@

##############################   PYTHON   #####################################

#
# elementtree
#
$(DEPDIR)/elementtree: bootstrap @DEPENDS_elementtree@
	@PREPARE_elementtree@
	cd @DIR_elementtree@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_elementtree@
	touch $@

#
# libxml2
#
$(DEPDIR)/libxml2: bootstrap @DEPENDS_libxml2@
	@PREPARE_libxml2@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libxml2@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-python=$(hostprefix)/bin/python \
			--without-c14n \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all && \
		@INSTALL_libxml2@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config && \
		chmod 755 $(crossprefix)/bin/xml2-config && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xml2Conf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xml2Conf.sh
	@DISTCLEANUP_libxml2@
	touch $@

#
# libxslt
#
$(DEPDIR)/libxslt: bootstrap libxml2 @DEPENDS_libxslt@
	@PREPARE_libxslt@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libxslt@ && \
		$(BUILDENV) \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libxml-prefix="$(crossprefix)" \
			--with-libxml-include-prefix="$(targetprefix)/usr/include" \
			--with-libxml-libs-prefix="$(targetprefix)/usr/lib" \
			--with-python=$(hostprefix)/bin/python \
			--without-crypto \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all && \
		@INSTALL_libxslt@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/libexslt.la && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xsltConf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xsltConf.sh
	@DISTCLEANUP_libxslt@
	touch $@

#
# lxml
#
$(DEPDIR)/lxml: bootstrap python @DEPENDS_lxml@
	@PREPARE_lxml@
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config && \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_lxml@
	touch $@

#
# setuptools
#
$(DEPDIR)/setuptools: bootstrap python @DEPENDS_setuptools@
	@PREPARE_setuptools@
	cd @DIR_setuptools@ && \
		$(hostprefix)/bin/python ./setup.py build install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_setuptools@
	touch $@

#
# gdata
#
$(DEPDIR)/gdata: bootstrap setuptools @DEPENDS_gdata@
	@PREPARE_gdata@
	cd @DIR_gdata@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_gdata@
	touch $@

#
# twisted
#
$(DEPDIR)/twisted: bootstrap setuptools @DEPENDS_twisted@
	@PREPARE_twisted@
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_twisted@
	touch $@

#
# twistetweb2
#
$(DEPDIR)/twistedweb2: bootstrap setuptools @DEPENDS_twistedweb2@
	@PREPARE_twistedweb2@
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_twistedweb2@
	touch $@

#
# twistedmail
#
$(DEPDIR)/twistedmail: bootstrap setuptools @DEPENDS_twistedmail@
	@PREPARE_twistedmail@
	cd @DIR_twistedmail@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_twistedmail@
	touch $@

#
# pilimaging
#
$(DEPDIR)/pilimaging: bootstrap libjpeg libfreetype python @DEPENDS_pilimaging@
	@PREPARE_pilimaging@
	cd @DIR_pilimaging@ && \
		sed -ie "s|"darwin"|"darwinNot"|g" "setup.py"; \
		sed -ie "s|ZLIB_ROOT = None|ZLIB_ROOT = libinclude(\"${targetprefix}/usr\")|" "setup.py"; \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pilimaging@
	touch $@

#
# pycrypto
#
$(DEPDIR)/pycrypto: bootstrap setuptools @DEPENDS_pycrypto@
	@PREPARE_pycrypto@
	cd @DIR_pycrypto@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pycrypto@
	touch $@

#
# pyusb
#
$(DEPDIR)/pyusb: bootstrap setuptools @DEPENDS_pyusb@
	@PREPARE_pyusb@
	cd @DIR_pyusb@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pyusb@
	touch $@

#
# pyopenssl
#
$(DEPDIR)/pyopenssl: bootstrap setuptools @DEPENDS_pyopenssl@
	@PREPARE_pyopenssl@
	cd @DIR_pyopenssl@ && \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/python$(PYTHON_VERSION)" \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pyopenssl@
	touch $@

#
# python
#
$(DEPDIR)/python: bootstrap host_python openssl-dev sqlite libreadline bzip2 @DEPENDS_python@
	@PREPARE_python@
	( cd @DIR_python@ && \
		CONFIG_SITE= \
		autoreconf --verbose --install --force Modules/_ctypes/libffi && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--enable-ipv6 \
			--without-cxx-main \
			--with-threads \
			--with-pymalloc \
			--with-signal-module \
			--with-wctype-functions \
			HOSTPYTHON=$(hostprefix)/bin/python \
			OPT="$(TARGET_CFLAGS)" && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			PYTHON_MODULES_INCLUDE="$(prefix)/$*cdkroot/usr/include" \
			PYTHON_MODULES_LIB="$(prefix)/$*cdkroot/usr/lib" \
			CROSS_COMPILE_TARGET=yes \
			CROSS_COMPILE=$(target) \
			HOSTARCH=sh4-linux \
			CFLAGS="$(TARGET_CFLAGS) -fno-inline" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
			HOSTPYTHON=$(hostprefix)/bin/python \
			HOSTPGEN=$(hostprefix)/bin/pgen \
			all install DESTDIR=$(prefix)/$*cdkroot ) && \
		@INSTALL_python@
	$(LN_SF) ../../libpython$(PYTHON_VERSION).so.1.0 $(prefix)/$*cdkroot$(PYTHON_DIR)/config/libpython$(PYTHON_VERSION).so && \
	$(LN_SF) $(prefix)/$*cdkroot$(PYTHON_INCLUDE_DIR) $(prefix)/$*cdkroot/usr/include/python
	@DISTCLEANUP_python@
	touch $@

#
# pythonwifi
#
$(DEPDIR)/pythonwifi: bootstrap setuptools @DEPENDS_pythonwifi@
	@PREPARE_pythonwifi@
	cd @DIR_pythonwifi@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pythonwifi@
	touch $@

#
# pythoncheetah
#
$(DEPDIR)/pythoncheetah: bootstrap setuptools @DEPENDS_pythoncheetah@
	@PREPARE_pythoncheetah@
	cd @DIR_pythoncheetah@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pythoncheetah@
	touch $@

#
# zope_interface
#
$(DEPDIR)/zope_interface: bootstrap python setuptools @DEPENDS_zope_interface@
	@PREPARE_zope_interface@
	cd @DIR_zope_interface@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_zope_interface@
	touch $@

##############################   GSTREAMER + PLUGINS   #########################
#
# gstreamer
#
$(DEPDIR)/gstreamer: bootstrap glib2 libxml2 @DEPENDS_gstreamer@
	@PREPARE_gstreamer@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gstreamer@ && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-dependency-tracking \
			--disable-check \
			--enable-introspection=no \
			ac_cv_func_register_printf_function=no && \
		$(MAKE) && \
		@INSTALL_gstreamer@
	@DISTCLEANUP_gstreamer@
	touch $@
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/gstreamer-0.10/*.la
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/gstreamer-0.10/*.la

#
# gst_plugins_base
#
$(DEPDIR)/gst_plugins_base: bootstrap glib2 gstreamer libogg libalsa @DEPENDS_gst_plugins_base@
	@PREPARE_gst_plugins_base@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_base@ && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-theora \
			--disable-gnome_vfs \
			--disable-pango \
			--disable-x \
			--disable-ivorbis \
			--disable-vorbis \
			--disable-vorbistest \
			--disable-examples \
			--disable-freetypetest \
			--with-audioresample-format=int && \
		$(MAKE) && \
		@INSTALL_gst_plugins_base@
	@DISTCLEANUP_gst_plugins_base@
	touch $@

#
# gst_plugins_good
#
$(DEPDIR)/gst_plugins_good: bootstrap gstreamer gst_plugins_base libsoup libflac @DEPENDS_gst_plugins_good@
	@PREPARE_gst_plugins_good@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_good@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-esd \
			--disable-esdtest \
			--disable-aalib \
			--disable-shout2 \
			--disable-x && \
		$(MAKE) && \
		@INSTALL_gst_plugins_good@
	@DISTCLEANUP_gst_plugins_good@
	touch $@

#
# gst_plugins_bad
#
$(DEPDIR)/gst_plugins_bad: bootstrap gstreamer gst_plugins_base libmodplug @DEPENDS_gst_plugins_bad@
	@PREPARE_gst_plugins_bad@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_bad@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-sdl \
			--disable-modplug \
			--disable-mpeg2enc \
			--disable-mplex \
			--disable-vdpau \
			--disable-apexsink \
			--disable-dvdnav \
			--disable-cdaudio \
			--disable-mpeg2enc \
			--disable-mplex \
			--disable-librfb \
			--disable-vdpau \
			--disable-examples \
			--disable-sdltest \
			--disable-curl \
			--disable-rsvg \
			ac_cv_openssldir=no && \
		$(MAKE) && \
		@INSTALL_gst_plugins_bad@
	@DISTCLEANUP_gst_plugins_bad@
	touch $@

#
# gst_plugins_ugly
#
$(DEPDIR)/gst_plugins_ugly: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_ugly@
	@PREPARE_gst_plugins_ugly@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_ugly@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-mpeg2dec && \
		$(MAKE) && \
		@INSTALL_gst_plugins_ugly@
	@DISTCLEANUP_gst_plugins_ugly@
	touch $@

#
# gst_ffmpeg
#
$(DEPDIR)/gst_ffmpeg: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_ffmpeg@
	@PREPARE_gst_ffmpeg@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_ffmpeg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			\
			--with-ffmpeg-extra-configure=" \
			--disable-ffserver \
			--disable-ffplay \
			--disable-ffmpeg \
			--disable-ffprobe \
			--enable-postproc \
			--enable-gpl \
			--enable-static \
			--enable-pic \
			--disable-protocols \
			--disable-devices \
			--disable-network \
			--disable-hwaccels \
			--disable-filters \
			--disable-doc \
			--enable-optimizations \
			--enable-cross-compile \
			--target-os=linux \
			--arch=sh4 \
			--cross-prefix=$(target)- \
			\
			--disable-muxers \
			--disable-encoders \
			--disable-decoders \
			--enable-decoder=ogg \
			--enable-decoder=vorbis \
			--enable-decoder=flac \
			\
			--disable-demuxers \
			--enable-demuxer=ogg \
			--enable-demuxer=vorbis \
			--enable-demuxer=flac \
			--enable-demuxer=mpegts \
			\
			--disable-bsfs \
			--enable-pthreads \
			--enable-bzlib"
		@INSTALL_gst_ffmpeg@
	@DISTCLEANUP_gst_ffmpeg@
	touch $@

#
# gst_plugins_fluendo_mpegdemux
#
$(DEPDIR)/gst_plugins_fluendo_mpegdemux: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_fluendo_mpegdemux@
	@PREPARE_gst_plugins_fluendo_mpegdemux@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_fluendo_mpegdemux@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-check=no && \
		$(MAKE) && \
		@INSTALL_gst_plugins_fluendo_mpegdemux@
	@DISTCLEANUP_gst_plugins_fluendo_mpegdemux@
	touch $@

#
# gst_plugin_subsink
#
$(DEPDIR)/gst_plugin_subsink: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly @DEPENDS_gst_plugin_subsink@
	@PREPARE_gst_plugin_subsink@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugin_subsink@ && \
		touch NEWS README AUTHORS ChangeLog && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoheader && \
		autoconf && \
		automake --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_gst_plugin_subsink@
	@DISTCLEANUP_gst_plugin_subsink@
	touch $@

#
# gst_plugins_dvbmediasink
#
$(DEPDIR)/gst_plugins_dvbmediasink: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugin_subsink @DEPENDS_gst_plugins_dvbmediasink@
	@PREPARE_gst_plugins_dvbmediasink@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_dvbmediasink@ && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		autoconf && \
		automake --foreign --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_gst_plugins_dvbmediasink@
	@DISTCLEANUP_gst_plugins_dvbmediasink@
	touch $@

##############################   EXTERNAL_LCD   ################################
#
# graphlcd
#
$(DEPDIR)/graphlcd: bootstrap libfreetype libusb @DEPENDS_graphlcd@
	@PREPARE_graphlcd@
	[ -d "$(archivedir)/graphlcd-base-touchcol.git" ] && \
	(cd $(archivedir)/graphlcd-base-touchcol.git; git pull ; git checkout touchcol; cd "$(buildprefix)";); \
	cd @DIR_graphlcd@ && \
		$(BUILDENV) \
		$(MAKE) all DESTDIR=$(targetprefix)/usr && \
		@INSTALL_graphlcd@
	@DISTCLEANUP_graphlcd@
	touch $@

#
# LCD4LINUX
#--with-python
$(DEPDIR)/lcd4_linux.do_prepare: bootstrap libusbcompat libgd2 libusb libdpf @DEPENDS_lcd4_linux@
	@PREPARE_lcd4_linux@
	touch $@

$(DEPDIR)/lcd4_linux.do_compile: $(DEPDIR)/lcd4_linux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lcd4_linux@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		aclocal && \
		libtoolize -f -c && \
		autoheader && \
		automake --foreign && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--libdir=$(targetprefix)/usr/lib \
			--includedir=$(targetprefix)/usr/include \
			--oldincludedir=$(targetprefix)/usr/include \
			--prefix=/usr \
			--with-drivers='DPF,SamsungSPF' \
			--with-plugins='all,!dbus,!mpris_dbus,!asterisk,!isdn,!pop3,!ppp,!seti,!huawei,!imon,!kvv,!sample,!w1retap,!wireless,!xmms,!gps,!mpd,!mysql,!qnaplog' \
			--without-ncurses && \
		$(MAKE) all
	touch $@

$(DEPDIR)/lcd4_linux: \
$(DEPDIR)/%lcd4_linux: $(DEPDIR)/lcd4_linux.do_compile
	cd @DIR_lcd4_linux@ && \
		@INSTALL_lcd4_linux@
	@DISTCLEANUP_lcd4_linux@
	[ "x$*" = "x" ] && touch $@

#
# libdpfax
#
$(DEPDIR)/libdpfax: bootstrap libusbcompat @DEPENDS_libdpfax@
	@PREPARE_libdpfax@
	cd @DIR_libdpfax@ && \
		$(BUILDENV) \
			$(MAKE) all &&\
		@INSTALL_libdpfax@
	@DISTCLEANUP_libdpfax@
	touch $@

#
# DPFAX
#
$(DEPDIR)/libdpf: bootstrap libusbcompat @DEPENDS_libdpf@
	@PREPARE_libdpf@
	cd @DIR_libdpf@ && \
	$(BUILDENV) \
		$(MAKE) && \
		cp dpf.h $(targetprefix)/usr/include/ && \
		cp sglib.h $(targetprefix)/usr/include/ && \
		cp usbuser.h $(targetprefix)/usr/include/ && \
		cp libdpf.a $(targetprefix)/usr/lib/
	@DISTCLEANUP_libdpf@
	touch $@

#
#
# libgd2
#
$(DEPDIR)/libgd2: bootstrap libpng libjpeg libiconv libfreetype @DEPENDS_libgd2@
	@PREPARE_libgd2@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libgd2@ && \
		chmod +w configure && \
		libtoolize -f -c && \
		autoreconf --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libgd2@
	@DISTCLEANUP_libgd2@
	touch $@

#
# libusb
#
$(DEPDIR)/libusb: bootstrap @DEPENDS_libusb@
	@PREPARE_libusb@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libusb@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-build-docs && \
		$(MAKE) all && \
		@INSTALL_libusb@
	@DISTCLEANUP_libusb@
	touch $@

#
# libusbcompat
#
$(DEPDIR)/libusbcompat: bootstrap libusb @DEPENDS_libusbcompat@
	@PREPARE_libusbcompat@
	cd @DIR_libusbcompat@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libusbcompat@
	@DISTCLEANUP_libusbcompat@
	touch $@

##############################   END EXTERNAL_LCD   #############################

#
# eve-browser
#
$(DEPDIR)/evebrowser: $(DEPDIR)/webkitdfb @DEPENDS_evebrowser@
	svn checkout https://eve-browser.googlecode.com/svn/trunk/ @DIR_evebrowser@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_evebrowser@ && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr && \
			$(MAKE) all && \
		@INSTALL_evebrowser@ && \
		cp -ar enigma2/HbbTv $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/
	@DISTCLEANUP_evebrowser@
	touch $@

#
# brofs
#
$(DEPDIR)/brofs: bootstrap @DEPENDS_brofs@
	@PREPARE_brofs@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_brofs@ && \
		$(BUILDENV) \
			$(MAKE) all && \
		@INSTALL_brofs@
	@DISTCLEANUP_brofs@
	touch $@

#
# libcap
#
$(DEPDIR)/libcap: bootstrap @DEPENDS_libcap@
	@PREPARE_libcap@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcap@ && \
		$(MAKE) \
		DESTDIR=$(targetprefix) \
		PREFIX=$(targetprefix)/usr \
		LIBDIR=$(targetprefix)/usr/lib \
		SBINDIR=$(targetprefix)/usr/sbin \
		INCDIR=$(targetprefix)/usr/include \
		BUILD_CC=gcc \
		PAM_CAP=no \
		LIBATTR=no \
		CC=$(target)-gcc
		@INSTALL_libcap@
	@DISTCLEANUP_libcap@
	touch $@

#
# alsa-lib
#
$(DEPDIR)/libalsa: bootstrap @DEPENDS_libalsa@
	@PREPARE_libalsa@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libalsa@ && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-debug=no \
			--disable-aload \
			--disable-rawmidi \
			--disable-old-symbols \
			--disable-alisp \
			--disable-hwdep \
			--disable-python && \
		$(MAKE) && \
		@INSTALL_libalsa@
	@DISTCLEANUP_libalsa@
	touch $@

#
# alsautils
#
$(DEPDIR)/alsautils: bootstrap @DEPENDS_alsautils@
	@PREPARE_alsautils@
	cd @DIR_alsautils@ && \
		sed -ir -r "s/(alsamixer|amidi|aplay|iecset|speaker-test|seq|alsactl|alsaucm)//g" Makefile.am && \
		autoreconf -fi -I $(targetprefix)/usr/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--disable-alsatest \
			--disable-alsaconf \
			--disable-alsaloop \
			--disable-alsamixer \
			--disable-xmlto && \
		$(MAKE) && \
		@INSTALL_alsautils@
	@DISTCLEANUP_alsautils@
	touch $@

#
# libopenthreads
#
$(DEPDIR)/libopenthreads: bootstrap @DEPENDS_libopenthreads@
	@PREPARE_libopenthreads@
	[ -d "$(archivedir)/cst-public-libraries-openthreads.git" ] && \
	(cd $(archivedir)/cst-public-libraries-openthreads.git; git pull ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/cst-public-libraries-openthreads.git" ] || \
	git clone --recursive git://c00lstreamtech.de/cst-public-libraries-openthreads.git $(archivedir)/cst-public-libraries-openthreads.git; \
	cp -ra $(archivedir)/cst-public-libraries-openthreads.git $(buildprefix)/openthreads; \
	cd $(buildprefix)/openthreads && patch -p1 < "$(buildprefix)/Patches/libopenthreads.patch"
	cd @DIR_libopenthreads@ && \
		rm CMakeFiles/* -rf CMakeCache.txt cmake_install.cmake && \
		cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME="Linux" \
			-DCMAKE_INSTALL_PREFIX="" \
			-DCMAKE_C_COMPILER="$(target)-gcc" \
			-DCMAKE_CXX_COMPILER="$(target)-g++" \
			-D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 && \
			find . -name cmake_install.cmake -print0 | xargs -0 \
			sed -i 's@SET(CMAKE_INSTALL_PREFIX "/usr/local")@SET(CMAKE_INSTALL_PREFIX "")@' && \
		$(MAKE) && \
		@INSTALL_libopenthreads@
	@DISTCLEANUP_libopenthreads@
	touch $@

#
# rtmpdump
#
$(DEPDIR)/rtmpdump: bootstrap openssl openssl-dev @DEPENDS_rtmpdump@
	@PREPARE_rtmpdump@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rtmpdump@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		libtoolize -f -c && \
		$(BUILDENV) \
		make CROSS_COMPILE=$(target)- && \
		@INSTALL_rtmpdump@
	@DISTCLEANUP_rtmpdump@
	touch $@

#
# libdvbsi++
#
$(DEPDIR)/libdvbsipp: bootstrap @DEPENDS_libdvbsipp@
	@PREPARE_libdvbsipp@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvbsipp@ && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libdvbsipp@
	@DISTCLEANUP_libdvbsipp@
	touch $@

#
# tuxtxtlib
#
$(DEPDIR)/tuxtxtlib: bootstrap @DEPENDS_tuxtxtlib@
	@PREPARE_tuxtxtlib@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxtlib@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		automake --foreign --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts && \
		$(MAKE) all && \
		@INSTALL_tuxtxtlib@
	@DISTCLEANUP_tuxtxtlib@
	touch $@

#
# tuxtxt32bpp
#
$(DEPDIR)/tuxtxt32bpp: tuxtxtlib @DEPENDS_tuxtxt32bpp@
	@PREPARE_tuxtxt32bpp@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxt32bpp@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		automake --foreign --add-missing && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts && \
		$(MAKE) all && \
		@INSTALL_tuxtxt32bpp@
	@DISTCLEANUP_tuxtxt32bpp@
	touch $@

#
# libmpeg2
#
$(DEPDIR)/libmpeg2: bootstrap @DEPENDS_libmpeg2@
	@PREPARE_libmpeg2)
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmpeg2@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-sdl \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libmpeg2@
	@DISTCLEANUP_libmpeg2@
	touch $@

#
# libsamplerate
#
$(DEPDIR)/libsamplerate: bootstrap @DEPENDS_libsamplerate@
	@PREPARE_libsamplerate@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsamplerate@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libsamplerate@
	@DISTCLEANUP_libsamplerate@
	touch $@

#
# libmodplug
#
$(DEPDIR)/libmodplug: bootstrap @DEPENDS_libmodplug@
	@PREPARE_libmodplug@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmodplug@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libmodplug@
	@DISTCLEANUP_libmodplug@
	touch $@

#
# tiff
#
$(DEPDIR)/tiff: bootstrap @DEPENDS_tiff@
	@PREPARE_tiff@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tiff@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_tiff@
	@DISTCLEANUP_tiff@
	touch $@

#
# lzo
#
$(DEPDIR)/lzo: bootstrap @DEPENDS_lzo@
	@PREPARE_lzo@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lzo@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_lzo@
	@DISTCLEANUP_lzo@
	touch $@

#
# yajl
#
$(DEPDIR)/yajl: bootstrap @DEPENDS_yajl@
	@PREPARE_yajl@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_yajl@ && \
		sed -i "s/install: all/install: distro/g" configure && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr && \
		$(MAKE) distro && \
		@INSTALL_yajl@
	@DISTCLEANUP_yajl@
	touch $@

#
# libpcre (shouldn't this be named pcre without the lib?)
#
$(DEPDIR)/libpcre: bootstrap @DEPENDS_libpcre@
	@PREPARE_libpcre@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpcre@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-utf8 \
			--enable-unicode-properties && \
		$(MAKE) all && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
		chmod 755 $(crossprefix)/bin/pcre-config && \
		@INSTALL_libpcre@
	@DISTCLEANUP_libpcre@
	touch $@

#
# libcdio
#
$(DEPDIR)/libcdio: bootstrap @DEPENDS_libcdio@
	@PREPARE_libcdio@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcdio@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libcdio@
	@DISTCLEANUP_libcdio@
	touch $@

#
# jasper
#
$(DEPDIR)/jasper: bootstrap @DEPENDS_jasper@
	@PREPARE_jasper@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_jasper@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_jasper@
	@DISTCLEANUP_jasper@
	touch $@

#
# mysql
#
$(DEPDIR)/mysql: bootstrap @DEPENDS_mysql@
	@PREPARE_mysql@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_mysql@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-atomic-ops=up \
			--with-embedded-server \
			--sysconfdir=/etc/mysql \
			--localstatedir=/var/mysql \
			--disable-dependency-tracking \
			--without-raid \
			--without-debug \
			--with-low-memory \
			--without-query-cache \
			--without-man \
			--without-docs \
			--without-innodb && \
		$(MAKE) all && \
		@INSTALL_mysql@
	@DISTCLEANUP_mysql@
	touch $@

#
# libmicrohttpd
#
$(DEPDIR)/libmicrohttpd: bootstrap @DEPENDS_libmicrohttpd@
	@PREPARE_libmicrohttpd@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmicrohttpd@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libmicrohttpd@
	@DISTCLEANUP_libmicrohttpd@
	touch $@

#
# libexif
#
$(DEPDIR)/libexif: bootstrap @DEPENDS_libexif@
	@PREPARE_libexif@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libexif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_libexif@
	@DISTCLEANUP_libexif@
	touch $@

#
# minidlna
#
$(DEPDIR)/minidlna: bootstrap ffmpeg libflac libogg libvorbis libid3tag sqlite libexif libjpeg @DEPENDS_minidlna@
	@PREPARE_minidlna@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_minidlna@ && \
		libtoolize -f -c && \
		$(BUILDENV) \
			$(MAKE) DESTDIR=$(prefix)/cdkroot \
			PAM_CAP=no \
			LIBATTR=no && \
		@INSTALL_minidlna@
	@DISTCLEANUP_minidlna@
	touch $@

#
# djmount
#
$(DEPDIR)/djmount: bootstrap fuse @DEPENDS_djmount@
	@PREPARE_djmount@
	cd @DIR_djmount@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_djmount@
	@DISTCLEANUP_djmount@
	touch $@

#
# libupnp
#
$(DEPDIR)/libupnp: bootstrap @DEPENDS_libupnp@
	@PREPARE_libupnp@
	cd @DIR_libupnp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_libupnp@
	@DISTCLEANUP_libupnp@
	touch $@

#
# rarfs
#
$(DEPDIR)/rarfs: bootstrap libstdc++-dev fuse @DEPENDS_rarfs@
	@PREPARE_rarfs@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rarfs@ && \
		export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -D_FILE_OFFSET_BITS=64" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-option-checking \
			--includedir=/usr/include/fuse \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_rarfs@
	@DISTCLEANUP_rarfs@
	touch $@

#
# sshfs
#
$(DEPDIR)/sshfs: bootstrap fuse @DEPENDS_sshfs@
	@PREPARE_sshfs@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sshfs@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_sshfs@
	@DISTCLEANUP_sshfs@
	touch $@

#
# gmediarender
#
$(DEPDIR)/gmediarender: bootstrap libstdc++-dev gst_plugins_dvbmediasink libupnp @DEPENDS_gmediarender@
	@PREPARE_gmediarender@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gmediarender@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libupnp=$(targetprefix)/usr && \
		$(MAKE) all && \
		@INSTALL_gmediarender@
	@DISTCLEANUP_gmediarender@
	touch $@

#
# tinyxml
#
$(DEPDIR)/tinyxml: @DEPENDS_tinyxml@
	@PREPARE_tinyxml@
	cd @DIR_tinyxml@ && \
		libtoolize -f -c && \
		$(BUILDENV) \
		$(MAKE) && \
		@INSTALL_tinyxml@
	@DISTCLEANUP_tinyxml@
	touch $@

#
# libnfs
#
$(DEPDIR)/libnfs: bootstrap @DEPENDS_libnfs@
	@PREPARE_libnfs@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libnfs@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
		@INSTALL_libnfs@
	@DISTCLEANUP_libnfs@
	touch $@

#
# taglib
#
$(DEPDIR)/taglib: bootstrap @DEPENDS_taglib@
	@PREPARE_taglib@
	cd @DIR_taglib@ && \
		$(BUILDENV) \
			cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_RELEASE_TYPE=Release . && \
		$(MAKE) all && \
		@INSTALL_taglib@
	@DISTCLEANUP_taglib@
	touch $@

