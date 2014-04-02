#
# titan
#

# $(DEPDIR)/titan.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg libopenthreads libusb2 libalsa tuxtxt32bpp titan-libdreamdvd $(MEDIAFW_DEP)

$(DEPDIR)/titan.do_prepare: | bootstrap libfreetype libjpeg libpng ffmpeg tuxtxt32bpp titan-libdreamdvd $(MEDIAFW_DEP)
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.dyndns.tv/svn/titan $(appsdir)/titan; \
	COMPRESSBIN=gzip; \
	COMPRESSEXT=gz; \
	$(if $(UFS910), COMPRESSBIN=lzma;) \
	$(if $(UFS910), COMPRESSEXT=lzma;) \
	[ -d "$(buildprefix)/BUILD" ] && \
	(echo "[titan.mk] Kernel COMPRESSBIN=$$COMPRESSBIN"; echo "[titan.mk] Kernel COMPRESSEXT=$$COMPRESSEXT"; cd "$(buildprefix)/BUILD"; rm -f $(buildprefix)/BUILD/uimage.*; dd if=$(targetprefix)/boot/uImage of=uimage.tmp.$$COMPRESSEXT bs=1 skip=64; $$COMPRESSBIN -d uimage.tmp.$$COMPRESSEXT; str="`strings $(buildprefix)/BUILD/uimage.tmp | grep "Linux version 2.6" | sed 's/Linux version //' | sed 's/(.*)//' | sed 's/  / /'`"; code=`"$(appsdir)/titan/titan/tools/gettitancode" "$$str"`; code="$$code"UL; echo "[titan.mk] $$str -> $$code"; sed s/"^#define SYSCODE .*"/"#define SYSCODE $$code"/ -i "$(appsdir)/titan/titan/titan.c"); \
	SVNVERSION=`svn info $(appsdir)/titan | grep Revision | sed s/'Revision: '//g`; \
	SVNBOX=ufs910; \
	$(if $(UFS910), SVNBOX=ufs910;) \
	$(if $(UFS912), SVNBOX=ufs912;) \
	$(if $(UFS922), SVNBOX=ufs922;) \
	$(if $(OCTAGON1008), SVNBOX=atevio700;) \
	$(if $(FORTIS_HDBOX), SVNBOX=atevio7000;) \
	$(if $(ATEVIO7500), SVNBOX=atevio7500;) \
	$(if $(ATEMIO510), SVNBOX=atemio510;) \
	$(if $(ATEMIO520), SVNBOX=atemio520;) \
	$(if $(ATEMIO530), SVNBOX=atemio530;) \
	TPKDIR="/svn/tpk/"$$SVNBOX"-rev"$$SVNVERSION"-secret/sh4/titan"; \
	(echo "[titan.mk] tpk SVNVERSION=$$SVNVERSION";echo "[titan.mk] tpk TPKDIR=$$TPKDIR"; sed s!"/svn/tpk/.*"!"$$TPKDIR\", 1, 0);"! -i "$(appsdir)/titan/titan/extensions.h"; sed s!"svn/tpk/.*"!"$$TPKDIR\") == 0)"! -i "$(appsdir)/titan/titan/tpk.h"; sed s/"^#define PLUGINVERSION .*"/"#define PLUGINVERSION $$SVNVERSION"/ -i "$(appsdir)/titan/titan/struct.h"); \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan; \
	touch $@
	rm -f $(buildprefix)/BUILD/uimage.*

$(appsdir)/titan/titan/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/titan && \
		libtoolize --force && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr/local \
			--with-target=cdk \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"
		$(MAKE)
	touch $@

$(DEPDIR)/titan.do_compile: $(appsdir)/titan/titan/config.status
	cd $(appsdir)/titan/titan && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan: titan.do_prepare titan.do_compile
	$(MAKE) -C $(appsdir)/titan/titan install DESTDIR=$(targetprefix)
	$(target)-strip $(targetprefix)/usr/local/bin/titan
	touch $@
	
titan-clean:
	rm -f $(buildprefix)/BUILD/uimage.*
	rm -f $(DEPDIR)/titan
	rm -f $(DEPDIR)/titan.do_prepare
	cd $(appsdir)/titan/titan && \
		$(MAKE) clean

titan-distclean:
	rm -f $(DEPDIR)/titan*
	rm -rf $(appsdir)/titan	

titan-updateyaud: titan-clean titan
	mkdir -p $(prefix)/release/usr/local/bin
	cp $(targetprefix)/usr/local/bin/titan $(prefix)/release_titan/usr/local/bin/

#
# titan-libdreamdvd
#
$(DEPDIR)/titan-libdreamdvd.do_prepare: | bootstrap libdvdnav
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.dyndns.tv/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan; \
	touch $@

$(appsdir)/titan/libdreamdvd/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/libdreamdvd && \
		libtoolize --force && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/titan-libdreamdvd.do_compile: $(appsdir)/titan/libdreamdvd/config.status
	cd $(appsdir)/titan/libdreamdvd && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan-libdreamdvd: titan-libdreamdvd.do_prepare titan-libdreamdvd.do_compile
	$(MAKE) -C $(appsdir)/titan/libdreamdvd install DESTDIR=$(targetprefix)
	touch $@

titan-libdreamdvd-clean:
	rm -f $(DEPDIR)/titan-libdreamdvd
	cd $(appsdir)/titan/libdreamdvd && \
		$(MAKE) clean

titan-libdreamdvd-distclean:
	rm -f $(DEPDIR)/titan-libdreamdvd*
	rm -rf $(appsdir)/titan/libdreamdvd	

#
# titan-plugins
#

$(DEPDIR)/titan-plugins.do_prepare: | libpng libjpeg libfreetype libcurl
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.dyndns.tv/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan;
	touch $@

$(appsdir)/titan/plugins/config.status: titan-libdreamdvd
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/plugins && \
	libtoolize --force && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	$(CONFIGURE) --prefix= \
	$(if $(MULTICOM324), --enable-multicom324) \
	$(if $(EPLAYER3), --enable-eplayer3)
	touch $@

$(DEPDIR)/titan-plugins.do_compile: $(appsdir)/titan/plugins/config.status
	cd $(appsdir)/titan/plugins && \
			$(MAKE) -C $(appsdir)/titan/plugins all install DESTDIR=$(prefix)/$*cdkroot
	touch $@

$(DEPDIR)/titan-plugins: titan-plugins.do_prepare titan-plugins.do_compile
	$(MAKE) -C $(appsdir)/titan/plugins all install DESTDIR=$(targetprefix)
	touch $@

titan-plugins-clean:
	rm -f $(DEPDIR)/titan-plugins
	rm -f $(DEPDIR)/titan-plugins.do_prepare
	-$(MAKE) -C $(appsdir)/titan/plugins clean
	
titan-plugins-distclean:
	rm -f $(DEPDIR)/titan-plugins*
	rm -rf $(appsdir)/titan/plugins	