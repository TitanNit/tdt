# tuxbox/xbmc-nightly

$(DEPDIR)/xbmc-nightly.do_prepare:
	REVISION=""; \
	PVRREVISION=""; \
	DIFF="0"; \
	REPO="git://github.com/xbmc/xbmc.git"; \
	PVRREPO="git://github.com/opdenkamp/xbmc-pvr-addons.git"; \
	rm -rf $(appsdir)/xbmc-nightly; \
	rm -rf $(appsdir)/xbmc-nightly.org; \
	clear; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 14 Apr 2012 12:36 - 460e79416c5cb13010456794f36f89d49d25da75"; \
	echo "2) Sun, 10 Jun 2012 13:53 - 327710767d2257dad27e3885effba1d49d4557f0"; \
	echo "3) Fr,  31 Aug 2012 22:34 - Frodo_alpha5 - 12840c28d8fbfd71c26be798ff6b13828b05b168"; \
	echo "4) Fr,  31 Oct 2012 22:34 - Frodo_alpha7 - e292b1147bd89a7e53742e3e5039b9a906a3b1d0"; \
	echo "5) Fr,  02 Jan 2013 22:34 - Frodo_rc3    - 7a6cb7f49ae19dca3c48c40fa3bd20dc3c490e60"; \
	echo "6) current inactive... comming soon, here is the next stable (case 6 == DIFF=6)"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="4"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="460e79416c5cb13010456794f36f89d49d25da75"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="327710767d2257dad27e3885effba1d49d4557f0"; \
	[ "$$REPLY" == "3" ] && DIFF="3" && REVISION="Frodo_alpha5"; \
	[ "$$REPLY" == "4" ] && DIFF="4" && REVISION="Frodo_alpha7" \
	                                 && PVRREVISION="9e6aca3ac0ff688f132ce0e8a4494b61b9b3ddac"; \
	[ "$$REPLY" == "5" ] && DIFF="5" && REVISION="Frodo_rc3" \
	                                 && PVRREVISION="Frodo_rc3"; \
	\
	echo "Revision: " $$REVISION; \
	[ -d "$(archivedir)/xbmc.git" ] && \
	(cd $(archivedir)/xbmc.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/xbmc.git" ] || \
	git clone $$REPO $(archivedir)/xbmc.git; \
	\
	echo "PVR Revision: " $$PVRREVISION; \
	[ -d "$(archivedir)/xbmc-pvr-addons.git" ] && \
	(cd $(archivedir)/xbmc-pvr-addons.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/xbmc-pvr-addons.git" ] || \
	git clone $$PVRREPO $(archivedir)/xbmc-pvr-addons.git; \
	\
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly.newest; \
	rm -rf $(appsdir)/xbmc-nightly.newest/.git; \
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly; \
	\
	cp -ra $(archivedir)/xbmc-pvr-addons.git $(appsdir)/xbmc-nightly.newest/pvr-addons; \
	rm -rf $(appsdir)/xbmc-nightly.newest/pvr-addons/.git; \
	cp -ra $(archivedir)/xbmc-pvr-addons.git $(appsdir)/xbmc-nightly/pvr-addons; \
	\
	[ "$$REVISION" == "" ] || (cd $(appsdir)/xbmc-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	[ "$$PVRREVISION" == "" ] || (cd $(appsdir)/xbmc-nightly/pvr-addons; git checkout "$$PVRREVISION"; cd "$(buildprefix)";); \
	\
	rm -rf $(appsdir)/xbmc-nightly/.git; \
	rm -rf $(appsdir)/xbmc-nightly/pvr-addons/.git; \
	\
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.org; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.$$DIFF.diff"; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.pvr.$$DIFF.diff"
	touch $@

#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap opkg libboost directfb libstgles libass libmpeg2 libmad libjpeg libsamplerate libogg libvorbis libmodplug libcurl libflac bzip2 tiff lzo libfribidi libfreetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink libexpat libnfs taglib
	cd $(appsdir)/xbmc-nightly && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PYTHON_SITE_PKG=$(targetprefix)/usr/lib/python$(PYTHON_VERSION)/site-packages \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			PY_PATH=$(targetprefix)/usr \
			TEXTUREPACKER_NATIVE_ROOT=/usr \
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
			--enable-webserver \
			--disable-nfs \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-udev \
			--disable-libusb \
			--disable-libcec \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa \
			--disable-ssh

$(DEPDIR)/xbmc-nightly.do_compile: $(appsdir)/xbmc-nightly/config.status
	cd $(appsdir)/xbmc-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/xbmc.bin; \
	fi
	touch $@

xbmc-nightly-clean xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(appsdir)/xbmc-nightly
	rm -rf $(appsdir)/xbmc-nightly.newest
	rm -rf $(appsdir)/xbmc-nightly.org
	rm -rf $(appsdir)/xbmc-nightly.patched

