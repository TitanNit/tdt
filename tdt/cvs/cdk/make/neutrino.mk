#
# Makefile to build NEUTRINO
#
$(targetprefix)/var/etc/.version:
	echo "imagename=Neutrino" > $@
	echo "homepage=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "creator=`id -un`" >> $@
	echo "docs=http://gitorious.org/open-duckbox-project-sh4/pages/Home" >> $@
	echo "forum=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git describe`" >> $@

#
#
#
NEUTRINO_DEPS  = bootstrap openssl libcurl libid3tag libmad libvorbisidec libpng libjpeg libgif libfreetype
NEUTRINO_DEPS += ffmpeg liblua libdvbsipp libopenthreads libusb libalsa
NEUTRINO_DEPS += $(EXTERNALLCD_DEP) $(MEDIAFW_DEP)

N_CFLAGS   = -Wall -W -Wshadow -pipe -Os -fno-strict-aliasing
#-rdynamic

N_CPPFLAGS = -I$(driverdir)/bpamem

if BOXTYPE_SPARK
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

if BOXTYPE_SPARK7162
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

N_CONFIG_OPTS = --enable-silent-rules --enable-freesatepg
# --enable-pip

if ENABLE_EXTERNALLCD
N_CONFIG_OPTS += --enable-graphlcd
endif

if ENABLE_MEDIAFWGSTREAMER
N_CONFIG_OPTS += --enable-gstreamer
else
N_CONFIG_OPTS += --enable-libeplayer3
endif

################################################################################
#
# libstb-hal
#
$(DEPDIR)/libstb-hal.do_prepare:
	rm -rf $(appsdir)/libstb-hal
	rm -rf $(appsdir)/libstb-hal.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal;\
	cp -ra $(appsdir)/libstb-hal $(appsdir)/libstb-hal.org
	touch $@

$(appsdir)/libstb-hal/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/libstb-hal && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal.do_compile: $(appsdir)/libstb-hal/config.status
	cd $(appsdir)/libstb-hal && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal: libstb-hal.do_prepare libstb-hal.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-clean:
	rm -f $(DEPDIR)/libstb-hal
	cd $(appsdir)/libstb-hal && \
		$(MAKE) distclean

libstb-hal-distclean:
	rm -f $(DEPDIR)/libstb-hal
	rm -f $(DEPDIR)/libstb-hal.do_compile
	rm -f $(DEPDIR)/libstb-hal.do_prepare

################################################################################
#
# libstb-hal-next
#
$(DEPDIR)/libstb-hal-next.do_prepare:
	rm -rf $(appsdir)/libstb-hal-next
	rm -rf $(appsdir)/libstb-hal-next.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal-next;\
	(cd $(appsdir)/libstb-hal-next; git checkout next; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/libstb-hal-next $(appsdir)/libstb-hal-next.org
	touch $@

$(appsdir)/libstb-hal-next/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/libstb-hal-next && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal-next.do_compile: $(appsdir)/libstb-hal-next/config.status
	cd $(appsdir)/libstb-hal-next && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal-next: libstb-hal-next.do_prepare libstb-hal-next.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal-next install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-next-clean:
	rm -f $(DEPDIR)/libstb-hal-next
	cd $(appsdir)/libstb-hal-next && \
		$(MAKE) distclean

libstb-hal-next-distclean:
	rm -f $(DEPDIR)/libstb-hal-next
	rm -f $(DEPDIR)/libstb-hal-next.do_compile
	rm -f $(DEPDIR)/libstb-hal-next.do_prepare

################################################################################
#
# NEUTRINO MP
#
$(DEPDIR)/neutrino-mp.do_prepare: | $(NEUTRINO_DEPS) libstb-hal
	rm -rf $(appsdir)/neutrino-mp
	rm -rf $(appsdir)/neutrino-mp.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp; \
	cp -ra $(appsdir)/neutrino-mp $(appsdir)/neutrino-mp.org
	touch $@

$(appsdir)/neutrino-mp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--enable-giflib \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp.do_compile: $(appsdir)/neutrino-mp/config.status
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp: neutrino-mp.do_prepare neutrino-mp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-clean:
	rm -f $(DEPDIR)/neutrino-mp
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) distclean

neutrino-mp-distclean:
	rm -f $(DEPDIR)/neutrino-mp
	rm -f $(DEPDIR)/neutrino-mp.do_compile
	rm -f $(DEPDIR)/neutrino-mp.do_prepare

neutrino-mp-updateyaud: neutrino-mp-clean neutrino-mp
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

################################################################################
#
# neutrino-mp-next
#
NEUTRINO_MP_NEXT_PATCHES =
#NEUTRINO_MP_NEXT_PATCHES += $(PATCHES)/
#NEUTRINO_MP_NEXT_PATCHES += $(PATCHES)/

$(DEPDIR)/neutrino-mp-next.do_prepare: | $(NEUTRINO_DEPS) libstb-hal-next
	rm -rf $(appsdir)/neutrino-mp-next
	rm -rf $(appsdir)/neutrino-mp-next.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp-next; \
	(cd $(appsdir)/neutrino-mp-next; git checkout next; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/neutrino-mp-next $(appsdir)/neutrino-mp-next.org
	for i in $(NEUTRINO_MP_NEXT_PATCHES); do \
		echo "==> Applying Patch: $(subst $(PATCHES)/,'',$$i)"; \
		cd $(appsdir)/neutrino-mp-next && patch -p1 -i $$i; \
	done;
	touch $@

$(appsdir)/neutrino-mp-next/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp-next && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--enable-lua \
			--enable-ffmpegdec \
			--enable-giflib \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal-next/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal-next \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp-next.do_compile: $(appsdir)/neutrino-mp-next/config.status
	cd $(appsdir)/neutrino-mp-next && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp-next: neutrino-mp-next.do_prepare neutrino-mp-next.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp-next install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-next-clean:
	rm -f $(DEPDIR)/neutrino-mp-next
	cd $(appsdir)/neutrino-mp-next && \
		$(MAKE) distclean

neutrino-mp-next-distclean:
	rm -f $(DEPDIR)/neutrino-mp-next
	rm -f $(DEPDIR)/neutrino-mp-next.do_compile
	rm -f $(DEPDIR)/neutrino-mp-next.do_prepare

################################################################################
#
# neutrino-hd2-exp
#
NEUTRINO_HD2_PATCHES =
NEUTRINO_HD2_PATCHES+= $(PATCHES)/neutrino-hd2-exp.diff

$(DEPDIR)/neutrino-hd2-exp.do_prepare: | $(NEUTRINO_DEPS) libflac
	rm -rf $(appsdir)/nhd2-exp
	rm -rf $(appsdir)/nhd2-exp.org
	[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] && \
	(cd $(archivedir)/neutrino-hd2-exp.svn; svn up ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] || \
	svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(archivedir)/neutrino-hd2-exp.svn; \
	cp -ra $(archivedir)/neutrino-hd2-exp.svn $(appsdir)/nhd2-exp; \
	cp -ra $(appsdir)/nhd2-exp $(appsdir)/nhd2-exp.org
	for i in $(NEUTRINO_HD2_PATCHES); do \
		echo "==> Applying Patch: $(subst $(PATCHES)/,'',$$i)"; \
		cd $(appsdir)/nhd2-exp && patch -p1 -i $$i; \
	done;
	touch $@

$(appsdir)/nhd2-exp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/nhd2-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-isocodesdir=/usr/share/iso-codes \
			--enable-standaloneplugins \
			--enable-radiotext \
			--enable-upnp \
			--enable-scart \
			--enable-ci \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-hd2-exp: neutrino-hd2-exp.do_prepare neutrino-hd2-exp.do_compile
	$(MAKE) -C $(appsdir)/nhd2-exp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

$(DEPDIR)/neutrino-hd2-exp.do_compile: $(appsdir)/nhd2-exp/config.status
	cd $(appsdir)/nhd2-exp && \
		$(MAKE) all
	touch $@

neutrino-hd2-exp-clean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	cd $(appsdir)/nhd2-exp && \
		$(MAKE) clean

neutrino-hd2-exp-distclean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_compile
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_prepare

################################################################################
#
#NORMAL
#
$(appsdir)/neutrino/config.status: bootstrap $(EXTERNALLCD_DEP) libfreetype libpng libid3tag openssl libcurl libmad libboost libgif ffmpeg_old
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--without-libsdl \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/local/share \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/neutrino.do_prepare:
	touch $@

$(DEPDIR)/neutrino.do_compile: $(appsdir)/neutrino/config.status
	cd $(appsdir)/neutrino && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino: neutrino.do_prepare neutrino.do_compile
	$(MAKE) -C $(appsdir)/neutrino install DESTDIR=$(targetprefix) DATADIR=$(targetprefix)/usr/local/share/
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-clean neutrino-distclean:
	rm -f $(DEPDIR)/neutrino
	rm -f $(DEPDIR)/neutrino.do_compile
	rm -f $(DEPDIR)/neutrino.do_prepare
	cd $(appsdir)/neutrino && \
		$(MAKE) distclean

