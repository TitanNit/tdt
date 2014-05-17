#
# SYSVINIT/INITSCRIPTS
#
SYSVINIT := sysvinit
INITSCRIPTS := initscripts
SYSVINITTOOLS := sysvinit-tools
SYSVINIT_VERSION := 2.86-15
SYSVINIT_SPEC := stm-target-$(SYSVINIT).spec
SYSVINIT_SPEC_PATCH :=
SYSVINIT_PATCHES :=

SYSVINIT_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm
INITSCRIPTS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(SYSVINIT_VERSION).sh4.rpm
SYSVINITTOOLS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SYSVINITTOOLS)-$(SYSVINIT_VERSION).sh4.rpm

$(SYSVINIT_RPM) $(SYSVINITTOOLS_RPM) $(INITSCRIPTS_RPM): \
		$(addprefix Patches/,$(SYSVINIT_SPEC_PATCH) $(SYSVINIT_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(SYSVINIT)-$(SYSVINIT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SYSVINIT_SPEC_PATCH),( cd SPECS && patch -p1 $(SYSVINIT_SPEC) < $(buildprefix)/Patches/$(SYSVINIT_SPEC_PATCH) ) &&) \
	$(if $(SYSVINIT_PATCHES),cp $(addprefix Patches/,$(SYSVINIT_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(SYSVINIT_SPEC)

$(DEPDIR)/$(SYSVINIT): $(SYSVINIT_ADAPTED_ETC_FILES:%=root/etc/%) $(SYSVINIT_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(SYSVINIT_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	touch $@

$(DEPDIR)/$(SYSVINITTOOLS): $(SYSVINITTOOLS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $<
	touch $@

$(DEPDIR)/$(INITSCRIPTS): $(INITSCRIPTS_ADAPTED_ETC_FILES:%=root/etc/%) $(INITSCRIPTS_RPM) | filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd $(prefix)/$*cdkroot/etc/init.d/ && \
		sed -e "s|-uid 0 ||g" -i bootclean.sh && \
		sed -e "s|-empty ||g" -i bootclean.sh && \
		sed -e "s/chmod \-f/chmod/g" -i bootmisc.sh && \
		sed -e "s/chown \-f/chown/g" -i bootmisc.sh && \
		sed -e "s|/etc/nologin|/var/tmp/nologin|g" -i bootmisc.sh && \
		sed -e "s|PATH=/lib/init:/bin:/sbin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i checkroot.sh && \
		sed -e "s/hostname \-\-file/hostname \-F/g" -i hostname.sh && \
		sed -e "s|PATH=/lib/init:/sbin:/bin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i rmnologin && \
		sed -e "s|# chkconfig: 2345 99 0|# chkconfig: 2345 69 0|" -i rmnologin && \
		sed -e "s|readlink -f /etc/nologin|readlink -f /var/tmp/nologin|g" -i rmnologin ) 
	( cd $(prefix)/$*cdkroot/etc/default/ && \
		sed -e "s|EDITMOTD=yes|EDITMOTD=no|g" -i rcS )
	( cd root/etc && for i in $(INITSCRIPTS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) || true 
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in init.d/mountvirtfs bootlogd checkroot.sh checkfs.sh mountall.sh \
		hostname.sh mountnfs.sh bootmisc.sh urandom \
		sendsigs umountnfs.sh umountfs halt reboot \
		rmnologin single stop-bootlogd ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; done && rm *rpmsave *.orig 2>/dev/null || true )
	touch $@

#
# NETBASE
#
NETBASE := netbase
NETBASE_VERSION := 4.34-9
NETBASE_SPEC := stm-target-$(NETBASE).spec
NETBASE_SPEC_PATCHES :=
NETBASE_PATCHES :=

NETBASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm

$(NETBASE_RPM): \
		$(addprefix Patches/,$(NETBASE_SPEC_PATCH) $(NETBASE_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(NETBASE)-$(NETBASE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	$(if $(NETBASE_SPEC_PATCH),( cd SPECS && patch -p1 $(NETBASE_SPEC) < $(buildprefix)/Patches/$(NETBASE_PATCH) ) &&) \
	$(if $(NETBASE_PATCHES),cp $(addprefix Patches/,$(NETBASE_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NETBASE).spec

$(DEPDIR)/$(NETBASE): $(NETBASE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc/network && $(INSTALL) interfaces $(prefix)/$*cdkroot/etc/network/interfaces || true ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in networking ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; \
		done && rm *rpmsave 2>/dev/null || true ) && \
	( cd $(prefix)/$*cdkroot/etc/network && \
		for i in if-down.d if-post-down.d if-pre-up.d if-up.d run; do \
			$(INSTALL) -d $$i; \
		done )
	touch $@

#
# BC
#
BC := bc
BC_VERSION := 1.06-6
BC_SPEC := stm-target-$(BC).spec
BC_SPEC_PATCH :=
BC_PATCHES :=

BC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm

$(BC_RPM): \
		$(addprefix Patches/,$(BC_SPEC_PATCH) $(BC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(BC)-$(BC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BC_SPEC_PATCH),( cd SPECS && patch -p1 $(BC_SPEC) < $(buildprefix)/Patches/$(BC_PATCH) ) &&) \
	$(if $(BC_PATCHES),cp $(addprefix Patches/,$(BC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BC_SPEC)

$(DEPDIR)/$(BC): $(BC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# FINDUTILS
#
FINDUTILS := findutils
FINDUTILS_VERSION := 4.1.20-13
FINDUTILS_SPEC := stm-target-$(FINDUTILS).spec
FINDUTILS_SPEC_PATCH :=
FINDUTILS_PATCHES := 

FINDUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm

$(FINDUTILS_RPM): \
		$(addprefix Patches/,$(FINDUTILS_SPEC_PATCH) $(FINDUTILS_PATCHES)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(FINDUTILS)-$(FINDUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(FINDUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(FINDUTILS_SPEC) < $(buildprefix)/Patches/$(FINDUTILS_PATCH) ) &&) \
	$(if $(FINDUTILS_PATCHES),cp $(addprefix Patches/,$(FINDUTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(FINDUTILS_SPEC)

$(DEPDIR)/$(FINDUTILS): $(FINDUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $<
	touch $@

#
# DISTRIBUTIONUTILS
#
DISTRIBUTIONUTILS := distributionutils
DISTRIBUTIONUTILS_DOC := distributionutils-doc
DISTRIBUTIONUTILS_VERSION := 3.2.1-10
DISTRIBUTIONUTILS_SPEC := stm-target-$(DISTRIBUTIONUTILS).spec
DISTRIBUTIONUTILS_SPEC_PATCH :=
DISTRIBUTIONUTILS_PATCHES :=

DISTRIBUTIONUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
DISTRIBUTIONUTILS_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm

$(DISTRIBUTIONUTILS_RPM) $(DISTRIBUTIONUTILS_DOC_RPM): \
		$(addprefix Patches/,$(DISTRIBUTIONUTILS_SPEC_PATCH) $(DISTRIBUTIONUTILS_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(DISTRIBUTIONUTILS_SPEC) < $(buildprefix)/Patches/$(DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(DISTRIBUTIONUTILS_PATCHES),cp $(addprefix Patches/,$(DISTRIBUTIONUTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(DISTRIBUTIONUTILS_SPEC)

$(DEPDIR)/$(DISTRIBUTIONUTILS): $(DISTRIBUTIONUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(DISTRIBUTIONUTILS_DOC): $(DISTRIBUTIONUTILS_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# HOST-MTD-UTILS
#
MTD_UTILS := mtd-utils
MTD_UTILS_VERSION := TODO
MTD_UTILS_SPEC := stm-target-$(MTD_UTILS).spec
MTD_UTILS_SPEC_PATCH :=
MTD_UTILS_PATCHES :=

MTD_UTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm

$(MTD_UTILS_RPM): \
		$(addprefix Patches/,$(MTD_UTILS_SPEC_PATCH) $(MTD_UTILS_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MTD_UTILS)-$(MTD_UTILS_VERSION).src.rpm libz
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(MTD_UTILS_SPEC) < $(buildprefix)/Patches/$(MTD_UTILS_PATCH) ) &&) \
	$(if $(MTD_UTILS_PATCHES),cp $(addprefix Patches/,$(MTD_UTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(MTD_UTILS_SPEC)

$(DEPDIR)/$(MTD_UTILS): $(MTD_UTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# COREUTILS
#
COREUTILS := coreutils
COREUTILS_VERSION := 8.9-19
COREUTILS_SPEC := stm-target-$(COREUTILS).spec
COREUTILS_SPEC_PATCH :=
COREUTILS_PATCHES :=

COREUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(COREUTILS)-$(COREUTILS_VERSION).sh4.rpm

$(COREUTILS_RPM): \
		$(addprefix Patches/,$(COREUTILS_SPEC_PATCH) $(COREUTILS_PATCHES)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(COREUTILS)-$(COREUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(COREUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(COREUTILS_SPEC) < $(buildprefix)/Patches/$(COREUTILS_PATCH) ) &&) \
	$(if $(COREUTILS_PATCHES),cp $(addprefix Patches/,$(COREUTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(COREUTILS_SPEC)

$(DEPDIR)/$(COREUTILS): $(DEPDIR)/%$(GLIBC) $(COREUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# NET-TOOLS
#
NET_TOOLS := net-tools
NET_TOOLS_VERSION := 1.60-9
NET_TOOLS_SPEC := stm-target-$(NET_TOOLS).spec
NET_TOOLS_SPEC_PATCH :=
NET_TOOLS_PATCHES :=

NET_TOOLS_RPM = RPMS/sh4/$(STLINUX)-sh4-$(NET_TOOLS)-$(NET_TOOLS_VERSION).sh4.rpm

$(NET_TOOLS_RPM): \
		$(addprefix Patches/,$(NET_TOOLS_SPEC_PATCH) $(NET_TOOLS_PATCHES)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(NET_TOOLS)-$(NET_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NET_TOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(NET_TOOLS_SPEC) < $(buildprefix)/Patches/$(NET_TOOLS_PATCH) ) &&) \
	$(if $(NET_TOOLS_PATCHES),cp $(addprefix Patches/,$(NET_TOOLS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(NET_TOOLS_SPEC)

$(DEPDIR)/$(NET_TOOLS): $(DEPDIR)/%$(GLIBC) $(NET_TOOLS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# STRACE
#
STRACE := strace
STRACE_VERSION := 4.5.20-24
STRACE_SPEC := stm-target-$(STRACE).spec
STRACE_SPEC_PATCH :=
STRACE_PATCHES :=

STRACE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STRACE)-$(STRACE_VERSION).sh4.rpm

$(STRACE_RPM): \
		$(addprefix Patches/,$(STRACE_SPEC_PATCH) $(STRACE_PATCHES)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(STRACE)-$(STRACE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STRACE_SPEC_PATCH),( cd SPECS && patch -p1 $(STRACE_SPEC) < $(buildprefix)/Patches/$(STRACE_PATCH) ) &&) \
	$(if $(STRACE_PATCHES),cp $(addprefix Patches/,$(STRACE_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STRACE_SPEC)

$(DEPDIR)/$(STRACE): $(DEPDIR)/%$(GLIBC) $(STRACE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# UTIL LINUX
# 
#UTIL_LINUX := util-linux
#UTIL_LINUX_MOUNT := mount
#UTIL_LINUX_BSDUTILS := bsdutils
#UTIL_LINUX_VERSION := 2.16.1-29
#UTIL_LINUX_SPEC := stm-target-$(UTIL_LINUX).spec
#UTIL_LINUX_SPEC_PATCH :=
#UTIL_LINUX_PATCHES :=
#
#UTIL_LINUX_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).sh4.rpm
#UTIL_LINUX_MOUNT_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UTIL_LINUX_MOUNT)-$(UTIL_LINUX_VERSION).sh4.rpm
#UTIL_LINUX_BSDUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UTIL_LINUX_BSDUTILS)-$(UTIL_LINUX_VERSION).sh4.rpm
#
#$(UTIL_LINUX_RPM): \
#		$(addprefix Patches/,$(UTIL_LINUX_SPEC_PATCH) $(UTIL_LINUX_PATCHES)) \
#		$(archivedir)/$(STLINUX)-target-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).src.rpm \
#		| $(NCURSES) $(NCURSES_DEV)
#	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
#	$(if $(UTIL_LINUX_SPEC_PATCH),( cd SPECS && patch -p1 $(UTIL_LINUX_SPEC) < $(buildprefix)/Patches/$(UTIL_LINUX_SPEC_PATCH) ) &&) \
#	$(if $(UTIL_LINUX_PATCHES),cp $(addprefix Patches/,$(UTIL_LINUX_PATCHES)) SOURCES/ &&) \
#	export PATH=$(hostprefix)/bin:$(PATH) && \
#	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(UTIL_LINUX_SPEC)
#
#$(DEPDIR)/$(UTIL_LINUX): $(UTIL_LINUX_RPM)
#	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
#		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
#	touch $@
#	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/lib{blkid,uuid}.la; \
#	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/lib{blkid,uuid}.la
#
#$(DEPDIR)/$(UTIL_LINUX_MOUNT): $(UTIL_LINUX_MOUNT_RPM)
#	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
#		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
#	touch $@
#
#$(DEPDIR)/$(UTIL_LINUX_BSDUTILS): $(UTIL_LINUX_BSDUTILS_RPM)
#	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
#		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
#	touch $@
