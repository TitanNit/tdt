#
# nfs_utils
#
$(DEPDIR)/nfs_utils: bootstrap e2fsprogs $(NFS_UTILS_ADAPTED_ETC_FILES:%=root/etc/%) @DEPENDS_nfs_utils@
	@PREPARE_nfs_utils@
	cd @DIR_nfs_utils@ && \
		$(BUILDENV) \
		./configure \
			CC_FOR_BUILD=$(target)-gcc \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-gss \
			--enable-ipv6=no \
			--disable-tirpc \
			--disable-nfsv4 \
			--without-tcp-wrappers && \
		$(MAKE) && \
		@INSTALL_nfs_utils@
	( cd $(buildprefix)/root/etc && for i in $(NFS_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	@DISTCLEANUP_nfs_utils@
	@touch $@

#
# libevent
#
$(DEPDIR)/libevent: bootstrap @DEPENDS_libevent@
	@PREPARE_libevent@
	cd @DIR_libevent@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(prefix)/$*cdkroot/usr/ && \
		$(MAKE) && \
		@INSTALL_libevent@
	@DISTCLEANUP_libevent@
	touch $@

#
# libnfsidmap
#
$(DEPDIR)/libnfsidmap: bootstrap @DEPENDS_libnfsidmap@
	@PREPARE_libnfsidmap@
	cd @DIR_libnfsidmap@ && \
		$(BUILDENV) \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(prefix)/$*cdkroot/usr/ && \
		$(MAKE) && \
		@INSTALL_libnfsidmap@
	@DISTCLEANUP_libnfsidmap@
	touch $@

#
# vsftpd
#
$(DEPDIR)/vsftpd: bootstrap @DEPENDS_vsftpd@
	@PREPARE_vsftpd@
	cd @DIR_vsftpd@ && \
		$(MAKE) clean && \
		$(MAKE) $(MAKE_OPTS) CFLAGS="-pipe -Os -g0" && \
		@INSTALL_vsftpd@
		cp $(buildprefix)/root/etc/vsftpd.conf $(targetprefix)/etc
	@DISTCLEANUP_vsftpd@
	touch $@

#
# ethtool
#
$(DEPDIR)/ethtool: bootstrap @DEPENDS_ethtool@
	@PREPARE_ethtool@
	cd @DIR_ethtool@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_ethtool@
	@DISTCLEANUP_ethtool@
	touch $@

#
# samba
#
$(DEPDIR)/samba: bootstrap $(SAMBA_ADAPTED_ETC_FILES:%=root/etc/%) @DEPENDS_samba@
	@PREPARE_samba@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_samba@ && \
		cd source3 && \
		./autogen.sh && \
		$(BUILDENV) \
		libreplace_cv_HAVE_GETADDRINFO=no \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--disable-pie \
			--disable-avahi \
			--disable-cups \
			--disable-relro \
			--disable-swat \
			--disable-shared-libs \
			--disable-socket-wrapper \
			--disable-nss-wrapper \
			--disable-smbtorture4 \
			--disable-fam \
			--disable-iprint \
			--disable-dnssd \
			--disable-pthreadpool \
			--disable-dmalloc \
			--with-included-iniparser \
			--with-included-popt \
			--with-sendfile-support \
			--without-aio-support \
			--without-cluster-support \
			--without-ads \
			--without-krb5 \
			--without-dnsupdate \
			--without-automount \
			--without-ldap \
			--without-pam \
			--without-pam_smbpass \
			--without-winbind \
			--without-wbclient \
			--without-syslog \
			--without-nisplus-home \
			--without-quotas \
			--without-sys-quotas \
			--without-utmp \
			--without-acl-support \
			--with-configdir=/etc/samba \
			--with-privatedir=/etc/samba \
			--with-mandir=/usr/share/man \
			--with-piddir=/var/run \
			--with-logfilebase=/var/log \
			--with-lockdir=/var/lock \
			--with-swatdir=/usr/share/swat \
			--disable-cups && \
		$(MAKE) $(MAKE_OPTS) && \
		$(MAKE) $(MAKE_OPTS) installservers installbin installscripts installdat installmodules \
			SBIN_PROGS="bin/smbd bin/nmbd bin/winbindd" DESTDIR=$(prefix)/$*cdkroot/ prefix=./. && \
	( cd $(buildprefix)/root/etc && for i in $(SAMBA_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	@DISTCLEANUP_samba@
	touch $@

#
# netio
#
$(DEPDIR)/netio: bootstrap @DEPENDS_netio@
	@PREPARE_netio@
	cd @DIR_netio@ && \
		$(MAKE_OPTS) \
		$(MAKE) all O=.o X= CFLAGS="-DUNIX" LIBS="$(LDFLAGS) -lpthread" OUT=-o && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/bin && \
		@INSTALL_netio@
	@DISTCLEANUP_netio@
	touch $@

#
# ntp
#
$(DEPDIR)/ntp: bootstrap @DEPENDS_ntp@
	@PREPARE_ntp@
	cd @DIR_ntp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) && \
		@INSTALL_ntp@
	@DISTCLEANUP_ntp@
	touch $@

#
# lighttpd
#
$(DEPDIR)/lighttpd.do_prepare: bootstrap @DEPENDS_lighttpd@
	@PREPARE_lighttpd@
	touch $@

$(DEPDIR)/lighttpd.do_compile: $(DEPDIR)/lighttpd.do_prepare
	cd @DIR_lighttpd@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--datarootdir=/usr/share && \
		$(MAKE)
	touch $@

$(DEPDIR)/lighttpd: \
$(DEPDIR)/%lighttpd: $(DEPDIR)/lighttpd.do_compile
	cd @DIR_lighttpd@ && \
		@INSTALL_lighttpd@
	cd @DIR_lighttpd@ && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -c -m644 doc/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
		$(INSTALL) -c -m644 doc/rc.lighttpd.redhat $(prefix)/$*cdkroot/etc/init.d/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && $(INSTALL) -m755 root/etc/lighttpd/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && $(INSTALL) -m755 root/etc/init.d/lighttpd $(prefix)/$*cdkroot/etc/init.d
	@DISTCLEANUP_lighttpd@
	[ "x$*" = "x" ] && touch $@ || true

#
# netkit_ftp
#
$(DEPDIR)/netkit_ftp: bootstrap ncurses libreadline @DEPENDS_netkit_ftp@
	@PREPARE_netkit_ftp@
	cd @DIR_netkit_ftp@ && \
		$(BUILDENV) \
		./configure \
			--with-c-compiler=$(target)-gcc \
			--prefix=/usr \
			--installroot=$(prefix)/$*cdkroot && \
		$(MAKE) && \
		@INSTALL_netkit_ftp@
	@DISTCLEANUP_netkit_ftp@
	touch $@

#
# wireless_tools
#
$(DEPDIR)/wireless_tools: bootstrap @DEPENDS_wireless_tools@
	@PREPARE_wireless_tools@
	cd @DIR_wireless_tools@ && \
		$(MAKE) $(MAKE_OPTS) && \
		@INSTALL_wireless_tools@
	@DISTCLEANUP_wireless_tools@
	touch $@

#
# wpa_supplicant
#
$(DEPDIR)/wpa_supplicant: bootstrap openssl openssl-dev wireless_tools @DEPENDS_wpa_supplicant@
	@PREPARE_wpa_supplicant@
	cd @DIR_wpa_supplicant@/wpa_supplicant && \
		$(INSTALL) -m 644 $(buildprefix)/Patches/wpa_supplicant.config .config && \
		$(MAKE) $(MAKE_OPTS) && \
		@INSTALL_wpa_supplicant@
	@DISTCLEANUP_wpa_supplicant@
	touch $@

#
# xupnpd
#
$(DEPDIR)/xupnpd: bootstrap @DEPENDS_xupnpd@
	@PREPARE_xupnpd@
	cd @DIR_xupnpd@ && \
		$(BUILDENV) \
		$(MAKE) TARGET=$(target) sh4 && \
		@INSTALL_xupnpd@
	@DISTCLEANUP_xupnpd@
	touch $@