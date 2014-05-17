#
# bzip2
#
$(DEPDIR)/bzip2: bootstrap @DEPENDS_bzip2@
	@PREPARE_bzip2@
	cd @DIR_bzip2@ && \
	mv Makefile-libbz2_so Makefile && \
		CC=$(target)-gcc \
		$(MAKE) all && \
		@INSTALL_bzip2@
	@DISTCLEANUP_bzip2@
	touch $@

#
# grep
#
$(DEPDIR)/grep: bootstrap @DEPENDS_grep@
	@PREPARE_grep@
	cd @DIR_grep@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-nls \
			--disable-perl-regexp \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_grep@
	@DISTCLEANUP_grep@
	touch $@

#
# CONSOLE_DATA
#
$(DEPDIR)/console_data: bootstrap @DEPENDS_console_data@
	@PREPARE_console_data@
	cd @DIR_console_data@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix) \
			--with-main_compressor=gzip && \
		$(MAKE) && \
		@INSTALL_console_data@
	@DISTCLEANUP_console_data@
	touch $@

#
# module_init_tools
#
$(DEPDIR)/module_init_tools: bootstrap lsb @DEPENDS_module_init_tools@
	@PREPARE_module_init_tools@
	cd @DIR_module_init_tools@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-builddir \
			--prefix= && \
		$(MAKE) && \
		@INSTALL_module_init_tools@
	$(call adapted-etc-files,$(MODULE_INIT_TOOLS_ADAPTED_ETC_FILES))
	$(call initdconfig,module-init-tools)
	@DISTCLEANUP_module_init_tools@
	touch $@

#
# lsb
#
$(DEPDIR)/lsb: bootstrap @DEPENDS_lsb@
	@PREPARE_lsb@
	cd @DIR_lsb@ && \
		@INSTALL_lsb@
	@DISTCLEANUP_lsb@
	touch $@

#
# portmap
#
$(DEPDIR)/portmap: bootstrap @DEPENDS_portmap@
	@PREPARE_portmap@
	cd @DIR_portmap@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: S 41 10\n### BEGIN INIT INFO/g' -i debian/init.d && \
		$(BUILDENV) \
		$(MAKE) && \
		@INSTALL_portmap@
	$(call adapted-etc-files,$(PORTMAP_ADAPTED_ETC_FILES))
	@DISTCLEANUP_portmap@
	touch $@

#
# openrdate
#
$(DEPDIR)/openrdate: bootstrap @DEPENDS_openrdate@ $(OPENRDATE_ADAPTED_ETC_FILES:%=root/etc/%)
	@PREPARE_openrdate@
	cd @DIR_openrdate@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_openrdate@
	( cd root/etc && for i in $(OPENRDATE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in rdate.sh ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	@DISTCLEANUP_openrdate@
	touch $@

#
# e2fsprogs
#
$(DEPDIR)/e2fsprogs: bootstrap utillinux @DEPENDS_e2fsprogs@
	@PREPARE_e2fsprogs@
	cd @DIR_e2fsprogs@ && \
		CFLAGS="$(TARGET_CFLAGS)" \
		CC=$(target)-gcc \
		RANLIB=$(target)-ranlib \
		PATH=$(buildprefix)/@DIR_e2fsprogs@:$(PATH) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--libdir=/usr/lib \
			--disable-rpath \
			--disable-quota \
			--disable-testio-debug \
			--disable-defrag \
			--disable-nls \
			--enable-elf-shlibs \
			--enable-verbose-makecmds \
			--enable-symlink-install \
			--without-libintl-prefix \
			--without-libiconv-prefix \
			--with-root-prefix="" && \
		$(MAKE) && \
		$(MAKE) -C e2fsck e2fsck.static && \
		@INSTALL_e2fsprogs@
		( cd @DIR_e2fsprogs@ && \
		$(MAKE) install install-libs DESTDIR=$(targetprefix) && \
	$(INSTALL) e2fsck/e2fsck.static $(targetprefix)/sbin ) || true
	@DISTCLEANUP_e2fsprogs@
	touch $@

#
# utillinux
#
$(DEPDIR)/utillinux: bootstrap libz ncurses-dev @DEPENDS_utillinux@
	@PREPARE_utillinux@
	cd @DIR_utillinux@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -D_FILE_OFFSET_BITS=64 -I$(targetprefix)/include/ncurses" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-static \
			--disable-rpath \
			--disable-libuuid \
			--disable-libblkid \
			--disable-libmount \
			--disable-bash-completion \
			--disable-wall && \
		$(MAKE) ARCH=sh4 && \
		@INSTALL_utillinux@
	@DISTCLEANUP_utillinux@
	touch $@

#
# xfsprogs
#
$(DEPDIR)/xfsprogs: bootstrap $(DEPDIR)/e2fsprogs $(DEPDIR)/libreadline @DEPENDS_xfsprogs@
	@PREPARE_xfsprogs@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_xfsprogs@ && \
		export DEBUG=-DNDEBUG && export OPTIMIZER=-O2 && \
		aclocal -I m4 -I $(hostprefix)/share/aclocal && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix= \
			--enable-shared=yes \
			--enable-gettext=yes \
			--enable-readline=yes \
			--enable-editline=no \
			--enable-termcap=yes && \
		$(MAKE) $(MAKE_OPTS) && \
		export top_builddir=`pwd` && \
		@INSTALL_xfsprogs@
	@DISTCLEANUP_xfsprogs@
	touch $@

#
# mc
#
$(DEPDIR)/mc: bootstrap glib2 @DEPENDS_mc@ | $(NCURSES_DEV)
	@PREPARE_mc@
	cd @DIR_mc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-gpm-mouse \
			--with-screen=ncurses \
			--without-x && \
		$(MAKE) all && \
		@INSTALL_mc@
#		export top_builddir=`pwd` && \
#		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
	@DISTCLEANUP_mc@
	touch $@

#
# sdparm
#
$(DEPDIR)/sdparm: bootstrap @DEPENDS_sdparm@
	@PREPARE_sdparm@
	cd @DIR_sdparm@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) $(MAKE_OPTS) && \
		@INSTALL_sdparm@
	@( cd $(prefix)/$*cdkroot/usr/share/man/man8 && gzip -v9 sdparm.8 )
	@DISTCLEANUP_sdparm@
	touch $@

#
# sg3_utils
#
$(DEPDIR)/sg3_utils: bootstrap @DEPENDS_sg3_utils@
	@PREPARE_sg3_utils@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sg3_utils@ && \
		$(MAKE) clean || true && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		automake --add-missing --foreign && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS) && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sg3_utils@
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
	( cd root/etc && for i in $(SG3_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	$(INSTALL) -m755 root/usr/sbin/sg_down.sh $(prefix)/$*cdkroot/usr/sbin
	@DISTCLEANUP_sg3_utils@
	touch $@

#
# ipkg
#
$(DEPDIR)/ipkg: bootstrap @DEPENDS_ipkg@
	@PREPARE_ipkg@
	cd @DIR_ipkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_ipkg@
	ln -sf ipkg-cl $(prefix)/$*cdkroot/usr/bin/ipkg && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $(prefix)/$*cdkroot/etc && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/ipkg
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(prefix)/$*cdkroot/usr/lib/ipkg/status
	@DISTCLEANUP_ipkg@
	touch $@

#
# zd1211
#
CONFIG_ZD1211B :=
$(DEPDIR)/zd1211: bootstrap @DEPENDS_zd1211@
	@PREPARE_zd1211@
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux-sh4 \
			ZD1211B=$(ZD1211B) \
			CROSS_COMPILE=$(target)- ARCH=sh \
			BIN_DEST=$(targetprefix)/bin \
			INSTALL_MOD_PATH=$(targetprefix) \
			install && \
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
	@DISTCLEANUP_zd1211@
	touch $@

#
# nano
#
$(DEPDIR)/nano: bootstrap ncurses ncurses-dev @DEPENDS_nano@
	@PREPARE_nano@
	cd @DIR_nano@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--enable-tiny \
			--enable-color && \
		$(MAKE) && \
		@INSTALL_nano@
	@DISTCLEANUP_nano@
	touch $@

#
# rsync
#
$(DEPDIR)/rsync: bootstrap @DEPENDS_rsync@
	@PREPARE_rsync@
	cd @DIR_rsync@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debug \
			--disable-locale && \
		$(MAKE) && \
		@INSTALL_rsync@
	@DISTCLEANUP_rsync@
	touch $@

#
# rfkill
#
$(DEPDIR)/rfkill: bootstrap @DEPENDS_rfkill@
	@PREPARE_rfkill@
	cd @DIR_rfkill@ && \
		$(MAKE) $(MAKE_OPTS) && \
		@INSTALL_rfkill@
	@DISTCLEANUP_rfkill@
	touch $@

#
# lm_sensors
#
$(DEPDIR)/lm_sensors: bootstrap @DEPENDS_lm_sensors@
	@PREPARE_lm_sensors@
	cd @DIR_lm_sensors@ && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user && \
		@INSTALL_lm_sensors@ && \
		rm $(prefix)/$*cdkroot/usr/bin/*.pl && \
		rm $(prefix)/$*cdkroot/usr/sbin/*.pl && \
		rm $(prefix)/$*cdkroot/usr/sbin/sensors-detect && \
		rm $(prefix)/$*cdkroot/usr/share/man/man8/sensors-detect.8 && \
		rm $(prefix)/$*cdkroot/usr/include/linux/i2c-dev.h && \
		rm $(prefix)/$*cdkroot/usr/bin/ddcmon
	@DISTCLEANUP_lm_sensors@
	touch $@

#
# fuse
#
$(DEPDIR)/fuse: bootstrap @DEPENDS_fuse@
	@PREPARE_fuse@
	cd @DIR_fuse@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux-sh4/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_fuse@
		-rm $(prefix)/$*cdkroot/etc/udev/rules.d/99-fuse.rules
		-rmdir $(prefix)/$*cdkroot/etc/udev/rules.d
		-rmdir $(prefix)/$*cdkroot/etc/udev
		$(LN_SF) sh4-linux-fusermount $(prefix)/$*cdkroot/usr/bin/fusermount
		$(LN_SF) sh4-linux-ulockmgr_server $(prefix)/$*cdkroot/usr/bin/ulockmgr_server
	@DISTCLEANUP_fuse@
	touch $@

#
# curlftpfs
#
$(DEPDIR)/curlftpfs: bootstrap fuse @DEPENDS_curlftpfs@
	@PREPARE_curlftpfs@
	cd @DIR_curlftpfs@ && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_curlftpfs@
	@DISTCLEANUP_curlftpfs@
	touch $@

#
# fbset
#
$(DEPDIR)/fbset: bootstrap @DEPENDS_fbset@
	@PREPARE_fbset@
	cd @DIR_fbset@ && \
		make CC="$(target)-gcc -Wall -O2 -I." && \
		@INSTALL_fbset@
	@DISTCLEANUP_fbset@
	touch $@

#
# pngquant
#
$(DEPDIR)/pngquant: bootstrap libz libpng @DEPENDS_pngquant@
	@PREPARE_pngquant@
	cd @DIR_pngquant@ && \
		$(target)-gcc -O3 -Wall -I. -funroll-loops -fomit-frame-pointer -o pngquant pngquant.c rwpng.c -lpng -lz -lm && \
		@INSTALL_pngquant@
	@DISTCLEANUP_pngquant@
	touch $@

#
# mplayer
#
$(DEPDIR)/mplayer: bootstrap @DEPENDS_mplayer@
	@PREPARE_mplayer@
	cd @DIR_mplayer@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-mencoder && \
		$(MAKE) CC="$(target)-gcc" && \
		@INSTALL_mplayer@
	@DISTCLEANUP_mplayer@
	touch $@

#
# mencoder
#
$(DEPDIR)/mencoder: bootstrap @DEPENDS_mencoder@
	@PREPARE_mencoder@
	cd @DIR_mencoder@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-dvdnav \
			--disable-dvdread \
			--disable-dvdread-internal \
			--disable-libdvdcss-internal \
			--disable-libvorbis \
			--disable-mp3lib \
			--disable-liba52 \
			--disable-mad \
			--disable-vcd \
			--disable-ftp \
			--disable-pvr \
			--disable-tv-v4l2 \
			--disable-tv-v4l1 \
			--disable-tv \
			--disable-network \
			--disable-real \
			--disable-xanim \
			--disable-faad-internal \
			--disable-tremor-internal \
			--disable-pnm \
			--disable-ossaudio \
			--disable-tga \
			--disable-v4l2 \
			--disable-fbdev \
			--disable-dvb \
			--disable-mplayer && \
		$(MAKE) CC="$(target)-gcc" && \
		@INSTALL_mencoder@
	@DISTCLEANUP_mencoder@
	touch $@

#
# jfsutils
#
$(DEPDIR)/jfsutils: bootstrap e2fsprogs @DEPENDS_jfsutils@
	@PREPARE_jfsutils@
	cd @DIR_jfsutils@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--disable-dependency-tracking \
			--prefix= && \
		$(MAKE) && \
		@INSTALL_jfsutils@
	@DISTCLEANUP_jfsutils@
	touch $@

#
# dosfstools
#
$(DEPDIR)/dosfstools: bootstrap @DEPENDS_dosfstools@
	@PREPARE_dosfstools@
	cd @DIR_dosfstools@ && \
		$(MAKE) all \
		CC=$(target)-gcc \
		OPTFLAGS="$(TARGET_CFLAGS) -fomit-frame-pointer -D_FILE_OFFSET_BITS=64" && \
		@INSTALL_dosfstools@
	@DISTCLEANUP_dosfstools@
	touch $@

#
# hddtemp
#
$(DEPDIR)/hddtemp: bootstrap @DEPENDS_hddtemp@
	@PREPARE_hddtemp@
	cd @DIR_hddtemp@ && \
		$(BUILDENV) \
		./configure \
			--with-db_path=/var/hddtemp.db \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) all && \
		$(MAKE) install DESTDIR=$(targetprefix)
		$(INSTALL) -d $(targetprefix)/var/tuxbox/config
		$(INSTALL) -m 644 root/release/hddtemp.db $(targetprefix)/var
	@DISTCLEANUP_hddtemp@
	touch $@

#
# hdparm
#
$(DEPDIR)/hdparm: bootstrap @DEPENDS_hdparm@
	@PREPARE_hdparm@
	cd @DIR_hdparm@ && \
		$(BUILDENV) \
		$(MAKE) CROSS=$(target)- all && \
		@INSTALL_hdparm@
	@DISTCLEANUP_hdparm@
	touch $@

#
# fdisk
#
$(DEPDIR)/fdisk: bootstrap parted @DEPENDS_fdisk@
	@PREPARE_fdisk@
	cd @DIR_fdisk@ && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
		$(MAKE) all && \
		@INSTALL_fdisk@
	@DISTCLEANUP_fdisk@
	touch $@

#
# parted
#
$(DEPDIR)/parted: bootstrap libreadline e2fsprogs @DEPENDS_parted@
	@PREPARE_parted@
	cd @DIR_parted@ && \
		CC=$(target)-gcc \
		RANLIB=$(target)-ranlib \
		CFLAGS="-pipe -Os" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=$(targetprefix)/usr \
			--disable-device-mapper \
			--disable-nls && \
		$(MAKE) all && \
		@INSTALL_parted@
	@DISTCLEANUP_parted@
	touch $@

#
# opkg
#
$(DEPDIR)/opkg: bootstrap @DEPENDS_opkg@
	@PREPARE_opkg@
	cd @DIR_opkg@ && \
		autoreconf -v --install; \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/var && \
		$(MAKE) all && \
		@INSTALL_opkg@
	@DISTCLEANUP_opkg@
	touch $@

#
# sysstat
#
$(DEPDIR)/sysstat: bootstrap @DEPENDS_sysstat@
	@PREPARE_sysstat@
	cd @DIR_sysstat@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-documentation && \
		$(MAKE) && \
		@INSTALL_sysstat@
	@DISTCLEANUP_sysstat@
	touch $@

#
# autofs
#
$(DEPDIR)/autofs: bootstrap e2fsprogs @DEPENDS_autofs@
	@PREPARE_autofs@
	cd @DIR_autofs@ && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip SUBDIRS="lib daemon modules" && \
		@INSTALL_autofs@
	@DISTCLEANUP_autofs@
	touch $@

#
# imagemagick
#
$(DEPDIR)/imagemagick: bootstrap @DEPENDS_imagemagick@
	@PREPARE_imagemagick@
	cd @DIR_imagemagick@ && \
		$(BUILDENV) \
		CFLAGS="-O1" \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-dps \
			--without-fpx \
			--without-gslib \
			--without-jbig \
			--without-jp2 \
			--without-lcms \
			--without-tiff \
			--without-xml \
			--without-perl \
			--disable-openmp \
			--disable-opencl \
			--without-zlib \
			--enable-shared \
			--enable-static \
			--without-x && \
		$(MAKE) all && \
		@INSTALL_imagemagick@
	@DISTCLEANUP_imagemagick@
	touch $@

#
# hotplug_e2
#
$(DEPDIR)/hotplug_e2: bootstrap @DEPENDS_hotplug_e2@
	@PREPARE_hotplug_e2@
	[ -d "$(archivedir)/hotplug-e2-helper.git" ] && \
	(cd $(archivedir)/hotplug-e2-helper.git; git pull; cd "$(buildprefix)";); \
	cd @DIR_hotplug_e2@ && \
		./autogen.sh &&\
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all && \
		@INSTALL_hotplug_e2@
	@DISTCLEANUP_hotplug_e2@
	touch $@

#
# shairport
#
$(DEPDIR)/shairport: bootstrap openssl openssl-dev howl libalsa @DEPENDS_shairport@
	@PREPARE_shairport@
	[ -d "$(archivedir)/shairport.git" ] && \
	(cd $(archivedir)/shairport.git; git pull; cd "$(buildprefix)";); \
	cd @DIR_shairport@ && \
		$(BUILDENV) \
		$(MAKE) all CC=$(target)-gcc LD=$(target)-ld && \
		@INSTALL_shairport@
	@DISTCLEANUP_shairport@
	touch $@

