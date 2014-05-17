#
# Makefile to build NEUTRINO-PLUGINS
#
#
#
# PLUGINS
#
$(DEPDIR)/neutrino-mp-plugins.do_prepare:
	rm -rf $(appsdir)/neutrino-mp-plugins
	rm -rf $(appsdir)/neutrino-mp-plugins.org
	[ -d "$(archivedir)/neutrino-mp-plugins.git" ] && \
	(cd $(archivedir)/neutrino-mp-plugins.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp-plugins.git" ] || \
	git clone git://gitorious.org/neutrino-hd/tangocashs-neutrino-mp-plugins.git $(archivedir)/neutrino-mp-plugins.git; \
	cp -ra $(archivedir)/neutrino-mp-plugins.git $(appsdir)/neutrino-mp-plugins;\
	cp -ra $(appsdir)/neutrino-mp-plugins $(appsdir)/neutrino-mp-plugins.org
	touch $@

$(appsdir)/neutrino-mp-plugins/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp-plugins && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--oldinclude=$(targetprefix)/include \
			--enable-maintainer-mode \
			--enable-giflib \
			--with-boxtype=$(BOXTYPE) \
			--with-plugindir=/var/plugins \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS) -DMARTII -DNEW_LIBCURL" \
			LDFLAGS="$(N_LDFLAGS) -L$(appsdir)/neutrino-mp-plugins/fx2/lib/.libs"

$(DEPDIR)/neutrino-mp-plugins.do_compile: $(appsdir)/neutrino-mp-plugins/config.status
	cd $(appsdir)/neutrino-mp-plugins && \
		$(MAKE)
	touch $@

$(DEPDIR)/neutrino-mp-plugins: neutrino-mp-plugins.do_prepare neutrino-mp-plugins.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp-plugins install DESTDIR=$(targetprefix)
	touch $@

neutrino-mp-plugins-clean:
	rm -f $(DEPDIR)/neutrino-mp-plugins
	cd $(appsdir)/neutrino-mp-plugins && \
		$(MAKE) clean

neutrino-mp-plugins-distclean:
	rm -f $(DEPDIR)/neutrino-mp-plugins*


