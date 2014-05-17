#
# tuxbox/enigma2
#

E_CONFIG_OPTS =

if ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

if ENABLE_EPLAYER3
E_CONFIG_OPTS += --enable-libeplayer3
endif

if ENABLE_MEDIAFWGSTREAMER
E_CONFIG_OPTS += --enable-mediafwgstreamer
endif

$(DEPDIR)/enigma2-pli-nightly.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://git.code.sf.net/p/openpli/enigma2"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo ""; \
	echo "Choose between the following revisions:"; \
	echo "========================================================================================================"; \
	echo " 0) Newest                 - E2 OpenPli gstreamer / libplayer3    (Can fail due to outdated patch)     "; \
	echo "========================================================================================================"; \
	echo " 1) inactive"; \
	echo " 2) inactive"; \
	echo "========================================================================================================"; \
	echo " 3) Mon, 28 Jan 2013 21:30 - E2 OpenPli gstreamer / libplayer3 ce3b90e73e88660bafe900f781d434dd6bd25f71"; \
	echo " 4) Sat,  2 Mar 2013 21:36 - E2 OpenPli gstreamer / libplayer3 4361a969cde00cd37d6d17933f2621ea49b5a30a"; \
	echo " 5) Fri, 10 May 2013 15:43 - E2 OpenPli gstreamer / libplayer3 20a5a1f00cdadeff6d0e02861cf7ba8436fc49c5"; \
	echo "========================================================================================================"; \
	echo "Media Framwork : $(MEDIAFW)"; \
	echo "External LCD   : $(EXTERNALLCD)"; \
	read -p "Select         : "; \
	[ "$$REPLY" == "0" ] && DIFF="0"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION=""; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION=""; \
	[ "$$REPLY" == "3" ] && DIFF="3" && REVISION="ce3b90e73e88660bafe900f781d434dd6bd25f71"; \
	[ "$$REPLY" == "4" ] && DIFF="4" && REVISION="4361a969cde00cd37d6d17933f2621ea49b5a30a"; \
	[ "$$REPLY" == "5" ] && DIFF="5" && REVISION="20a5a1f00cdadeff6d0e02861cf7ba8436fc49c5"; \
	echo "Revision       : "$$REVISION; \
	echo ""; \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] && \
	(cd $(archivedir)/enigma2-pli-nightly.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] || \
	git clone -b $$HEAD $$REPO $(archivedir)/enigma2-pli-nightly.git; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly.newest; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.diff"
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-pli-nightly/config.status: \
		bootstrap opkg ethtool libfreetype libexpat libpng libjpeg libgif_e2 libfribidi libid3tag libmad libsigc libreadline \
		libdvbsipp python libxml2 libxslt elementtree zope_interface twisted pyopenssl pythonwifi pilimaging pyusb pycrypto \
		lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 \
		$(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/enigma2-nightly && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=none \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) $(E_CONFIG_OPTS)

$(DEPDIR)/enigma2-pli-nightly.do_compile: $(appsdir)/enigma2-pli-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-pli-nightly: enigma2-pli-nightly.do_prepare enigma2-pli-nightly.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-pli-nightly-clean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) distclean

enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched
