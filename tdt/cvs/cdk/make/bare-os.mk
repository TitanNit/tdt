#
# TZDATA
#
TZDATA := tzdata
TZDATA_VERSION := 2012j-1
TZDATA_SPEC := stm-target-$(TZDATA).spec
TZDATA_SPEC_PATCH :=
TZDATA_PATCHES :=

TZDATA_RPM := RPMS/noarch/$(STLINUX)-sh4-$(TZDATA)-$(TZDATA_VERSION).noarch.rpm

$(TZDATA_RPM): \
		$(addprefix Patches/,$(TZDATA_SPEC_PATCH) $(TZDATA_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(TZDATA)-$(TZDATA_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(TZDATA_SPEC_PATCH),( cd SPECS && patch -p1 $(TZDATA_SPEC) < $(buildprefix)/Patches/$(TZDATA_SPEC_PATCH) ) &&) \
	$(if $(TZDATA_PATCHES),cp $(addprefix Patches/,$(TZDATA_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(TZDATA_SPEC)

$(DEPDIR)/$(TZDATA): $(TZDATA_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@

#
# GLIBC
#
GLIBC := glibc
GLIBC_DEV := glibc-dev
GLIBC_VERSION := 2.10.2-42
GLIBC_RAWVERSION := $(firstword $(subst -, ,$(GLIBC_VERSION)))
GLIBC_SPEC := stm-target-$(GLIBC).spec
GLIBC_SPEC_PATCH :=
GLIBC_PATCHES :=

GLIBC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm
GLIBC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm

$(GLIBC_RPM) $(GLIBC_DEV_RPM): \
		$(addprefix Patches/,$(GLIBC_SPEC_PATCH) $(GLIBC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GLIBC)-$(GLIBC_VERSION).src.rpm \
		| filesystem
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GLIBC_SPEC_PATCH),( cd SPECS && patch -p1 $(GLIBC_SPEC) < $(buildprefix)/Patches/$(GLIBC_SPEC_PATCH) ) &&) \
	$(if $(GLIBC_PATCHES),cp $(addprefix Patches/,$(GLIBC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(GLIBC_SPEC)

$(DEPDIR)/$(GLIBC): $(GLIBC_RPM) | $(DEPDIR)/filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(GLIBC_DEV): $(DEPDIR)/$(GLIBC) $(GLIBC_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# BINUTILS
#
BINUTILS := binutils
BINUTILS_DEV := binutils-dev
if GCC47
BINUTILS_VERSION = 2.23.2-72
else
BINUTILS_VERSION = 2.22-68
endif
BINUTILS_SPEC := stm-target-$(BINUTILS).spec
BINUTILS_SPEC_PATCH := $(BINUTILS_SPEC).$(BINUTILS_VERSION).diff
BINUTILS_PATCHES :=

BINUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm
BINUTILS_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm

$(BINUTILS_RPM) $(BINUTILS_DEV_RPM): \
		$(addprefix Patches/,$(BINUTILS_SPEC_PATCH) $(BINUTILS_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(BINUTILS)-$(BINUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(BINUTILS_SPEC) < $(buildprefix)/Patches/$(BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(BINUTILS_PATCHES),cp $(addprefix Patches/,$(BINUTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(BINUTILS_SPEC)

$(DEPDIR)/$(BINUTILS): $(BINUTILS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $<
	touch $@

$(DEPDIR)/$(BINUTILS_DEV): $(BINUTILS_DEV_RPM)
	@rpm $(DRPM) --ignorearch --nodeps --noscripts -Uhv $<
	touch $@

#
# GMP
#
GMP := gmp
GMP_VERSION := 5.1.0-8
GMP_SPEC := stm-target-$(GMP).spec
GMP_SPEC_PATCH :=
GMP_PATCHES :=

GMP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GMP)-$(GMP_VERSION).sh4.rpm

$(GMP_RPM): \
		$(addprefix Patches/,$(GMP_SPEC_PATCH) $(GMP_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GMP)-$(GMP_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GMP_SPEC_PATCH),( cd SPECS && patch -p1 $(GMP_SPEC) < $(buildprefix)/Patches/$(GMP_SPEC_PATCH) ) &&) \
	$(if $(GMP_PATCHES),cp $(addprefix Patches/,$(GMP_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(GMP_SPEC)

$(DEPDIR)/$(GMP): $(GMP_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libgmp.la; \
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/libgmp.la
	touch $@

#
# MPFR
#
MPFR := mpfr
MPFR_VERSION := 3.1.2-9
MPFR_SPEC := stm-target-$(MPFR).spec
MPFR_SPEC_PATCH :=
MPFR_PATCHES :=

MPFR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPFR)-$(MPFR_VERSION).sh4.rpm

$(MPFR_RPM): \
		$(addprefix Patches/,$(MPFR_SPEC_PATCH) $(MPFR_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPFR)-$(MPFR_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPFR_SPEC_PATCH),( cd SPECS && patch -p1 $(MPFR_SPEC) < $(buildprefix)/Patches/$(MPFR_SPEC_PATCH) ) &&) \
	$(if $(MPFR_PATCHES),cp $(addprefix Patches/,$(MPFR_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MPFR_SPEC)

$(DEPDIR)/$(MPFR): $(MPFR_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpfr.la; \
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/libmpfr.la
	touch $@

#
# MPC
#
MPC := mpc
MPC_VERSION := 1.0.1-5
MPC_SPEC := stm-target-$(MPC).spec
MPC_SPEC_PATCH := 
MPC_PATCHES := 

MPC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPC)-$(MPC_VERSION).sh4.rpm

$(MPC_RPM): \
		$(addprefix Patches/,$(MPC_SPEC_PATCH) $(MPC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPC)-$(MPC_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPC_SPEC_PATCH),( cd SPECS && patch -p1 $(MPC_SPEC) < $(buildprefix)/Patches/$(MPC_SPEC_PATCH) ) &&) \
	$(if $(MPC_PATCHES),cp $(addprefix Patches/,$(MPC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MPC_SPEC)

$(DEPDIR)/$(MPC): $(MPC_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpc.la; \
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/libmpc.la
	touch $@

#
# LIBELF
#
LIBELF := libelf
LIBELF_VERSION := 0.8.13-2
LIBELF_SPEC := stm-target-$(LIBELF).spec
LIBELF_SPEC_PATCH :=
LIBELF_PATCHES :=

LIBELF_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBELF)-$(LIBELF_VERSION).sh4.rpm

$(LIBELF_RPM): \
		$(addprefix Patches/,$(LIBELF_SPEC_PATCH) $(LIBELF_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(LIBELF)-$(LIBELF_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBELF_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBELF_SPEC) < $(buildprefix)/Patches/$(LIBELF_SPEC_PATCH) ) &&) \
	$(if $(LIBELF_PATCHES),cp $(addprefix Patches/,$(LIBELF_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBELF_SPEC)

$(DEPDIR)/$(LIBELF): $(LIBELF_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^)
	touch $@

#
# GCC LIBSTDC++
#
LIBSTDC := libstdc++
LIBSTDC_DEV := libstdc++-dev
LIBGCC := libgcc
GCC := gcc
if GCC47
GCC_VERSION := 4.7.2-124
else
GCC_VERSION := 4.6.3-115
endif
GCC_SPEC := stm-target-$(GCC).spec
GCC_SPEC_PATCH := $(GCC_SPEC).$(GCC_VERSION).diff
GCC_PATCHES := stm-target-$(GCC).$(GCC_VERSION).diff

GCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm
LIBGCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm

$(GCC_RPM) $(LIBSTDC_RPM) $(LIBSTDC_DEV_RPM) $(LIBGCC_RPM): \
		$(addprefix Patches/,$(GCC_SPEC_PATCH) $(GCC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GCC)-$(GCC_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GCC_SPEC_PATCH),( cd SPECS && patch -p1 $(GCC_SPEC) < $(buildprefix)/Patches/$(GCC_SPEC_PATCH) ) &&) \
	$(if $(GCC_PATCHES),cp $(addprefix Patches/,$(GCC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(GCC_SPEC)

$(DEPDIR)/$(GCC): $(DEPDIR)/$(GLIBC_DEV) $(GCC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBSTDC): $(DEPDIR)/$(CROSS_LIBGCC) $(LIBSTDC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBSTDC_DEV): $(DEPDIR)/$(LIBSTDC) $(LIBSTDC_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/lib{std,sup}c++.la; \
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/lib{std,sup}c++.la

$(DEPDIR)/$(LIBGCC): $(LIBGCC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

# END OF BOOTSTRAP

#
# LIBFFI
#
LIBFFI := libffi
LIBFFI_VERSION := 3.0.10-1
LIBFFI_SPEC := stm-target-$(LIBFFI).spec
LIBFFI_SPEC_PATCH :=
LIBFFI_PATCHES :=

LIBFFI_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBFFI)-dev-$(LIBFFI_VERSION).sh4.rpm

$(LIBFFI_RPM): \
		$(addprefix Patches/,$(LIBFFI_SPEC_PATCH) $(LIBFFI_PATCH)) \
		$(if $(LIBFFI_PATCHES),$(LIBFFI_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBFFI)-$(LIBFFI_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBFFI_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBFFI_SPEC) < $(buildprefix)/Patches/$(LIBFFI_SPEC_PATCH) ) &&) \
	$(if $(LIBFFI_PATCHES),cp $(addprefix Patches/,$(LIBFFI_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBFFI_SPEC)

$(DEPDIR)/$(LIBFFI): $(LIBFFI_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libffi.la
	touch $@

#
# GLIB2
#
GLIB2 := #glib2
GLIB2_DEV := glib2-dev
GLIB2_VERSION := 2.32.1-33
GLIB2_SPEC := stm-target-$(GLIB2).spec
GLIB2_SPEC_PATCH :=
GLIB2_PATCHES :=

GLIB2_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIB2)-$(GLIB2_VERSION).sh4.rpm
GLIB2_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIB2_DEV)-$(GLIB2_VERSION).sh4.rpm

$(GLIB2_RPM) $(GLIB2_DEV_RPM): \
		$(addprefix Patches/,$(GLIB2_SPEC_PATCH) $(GLIB2_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GLIB2)-$(GLIB2_VERSION).src.rpm
	rpm $(DRPM) --nosignature -ihv $(lastword $^) && \
	$(if $(GLIB2_SPEC_PATCH),( cd SPECS && patch -p1 $(GLIB2_SPEC) < $(buildprefix)/Patches/$(GLIB2_SPEC_PATCH) ) &&) \
	$(if $(GLIB2_PATCHES),cp $(addprefix Patches/,$(GLIB2_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(GLIB2_SPEC)

$(DEPDIR)/$(GLIB2): bootstrap $(HOST_GLIB2) $(GLIB2_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(GLIB2_DEV): $(DEPDIR)/$(GLIB2) $(GLIB2_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/{libgio,libglib,libgmodule,libgobject,libgthread}-2.0.la; \
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/{libgio,libglib,libgmodule,libgobject,libgthread}-2.0.la; \
	sed -i '/^prefix=/{ s#/usr#$(targetprefix)/usr#g }' $(targetprefix)/usr/lib/pkgconfig/{gio,gio-unix,glib,gmodule,gmodule-export,gmodule-no-export,gobject}-2.0.pc
	touch $@

#
# LIBTERMCAP
#
LIBTERMCAP := libtermcap
LIBTERMCAP_DEV := libtermcap-dev
LIBTERMCAP_DOC := libtermcap-doc
LIBTERMCAP_VERSION := 2.0.8-10
LIBTERMCAP_RAWVERSION := $(firstword $(subst -, ,$(LIBTERMCAP_VERSION)))
LIBTERMCAP_SPEC := stm-target-$(LIBTERMCAP).spec
LIBTERMCAP_SPEC_PATCH :=
LIBTERMCAP_PATCHES :=

LIBTERMCAP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DEV)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DOC)-$(LIBTERMCAP_VERSION).sh4.rpm

$(LIBTERMCAP_RPM) $(LIBTERMCAP_DEV_RPM) $(LIBTERMCAP_DOC_RPM): \
		$(addprefix Patches/,$(LIBTERMCAP_SPEC_PATCH) $(LIBTERMCAP_PATCHES)) \
		$(archivedir)/$(STM_SRC)-target-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBTERMCAP_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBTERMCAP_SPEC) < $(buildprefix)/Patches/$(LIBTERMCAP_SPEC_PATCH) ) &&) \
	$(if $(LIBTERMCAP_PATCHES),cp $(addprefix Patches/,$(LIBTERMCAP_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBTERMCAP_SPEC)

$(DEPDIR)/$(LIBTERMCAP): bootstrap $(LIBTERMCAP_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	ln -sf libtermcap.so.2 $(prefix)/$*cdkroot/usr/lib/libtermcap.so && \
	$(INSTALL) -m 644 $(buildprefix)/root/etc/termcap $(prefix)/$*cdkroot/etc
	touch $@

$(DEPDIR)/$(LIBTERMCAP_DEV): $(DEPDIR)/$(LIBTERMCAP) $(LIBTERMCAP_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBTERMCAP_DOC): $(LIBTERMCAP_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# NCURSES
#
NCURSES := ncurses
NCURSES_BASE := ncurses-base
NCURSES_DEV := ncurses-dev
NCURSES_VERSION := 5.5-10
NCURSES_SPEC := stm-target-$(NCURSES).spec
NCURSES_SPEC_PATCH :=
NCURSES_PATCHES :=

NCURSES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm
NCURSES_BASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm
NCURSES_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm

$(NCURSES_RPM) $(NCURSES_BASE_RPM) $(NCURSES_DEV_RPM): \
		$(addprefix Patches/,$(NCURSES_SPEC_PATCH) $(NCURSES_PATCHES)) \
		$(archivedir)/$(STM_SRC)-target-$(NCURSES)-$(NCURSES_VERSION).src.rpm \
		| $(DEPDIR)/$(LIBSTDC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NCURSES_SPEC_PATCH),( cd SPECS && patch -p1 $(NCURSES_SPEC) < $(buildprefix)/Patches/$(NCURSES_SPEC_PATCH) ) &&) \
	$(if $(NCURSES_PATCHES),cp $(addprefix Patches/,$(NCURSES_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(NCURSES_SPEC)

$(DEPDIR)/$(NCURSES_BASE): $(NCURSES_BASE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $<)
	touch $@

$(DEPDIR)/$(NCURSES): $(DEPDIR)/$(NCURSES_BASE) $(NCURSES_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(NCURSES_DEV): $(DEPDIR)/$(NCURSES_BASE) $(NCURSES_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# BASE-PASSWD
#
BASE_PASSWD := base-passwd
BASE_PASSWD_VERSION := 3.5.9-11
BASE_PASSWD_SPEC := stm-target-$(BASE_PASSWD).spec
BASE_PASSWD_SPEC_PATCH :=
BASE_PASSWD_PATCHES :=

BASE_PASSWD_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm

$(BASE_PASSWD_RPM): \
		$(addprefix Patches/,$(BASE_PASSWD_SPEC_PATCH) $(BASE_PASSWD_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_PASSWD_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_PASSWD_SPEC) < $(buildprefix)/Patches/$(BASE_PASSWD_SPEC_PATCH) ) &&) \
	$(if $(BASE_PASSWD_PATCHES),cp $(addprefix Patches/,$(BASE_PASSWD_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASE_PASSWD_SPEC)

$(DEPDIR)/$(BASE_PASSWD): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) $(BASE_PASSWD_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  --nopost -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
		$(hostprefix)/bin/update-passwd -L -p $(prefix)/$*cdkroot/usr/share/base-passwd/passwd.master \
			-g $(prefix)/$*cdkroot/usr/share/base-passwd/group.master -P $(prefix)/$*cdkroot/etc/passwd \
			-S $(prefix)/$*cdkroot/etc/shadow -G $(prefix)/$*cdkroot/etc/group && \
	chmod 600 $(prefix)/$*cdkroot/etc/shadow && \
	( cd $(prefix)/$*cdkroot/etc && sed -e "s|/bin/bash|/bin/sh|g" -i passwd ) && \
	rm -f $(prefix)/$*cdkroot/etc/shadow
	touch $@

#
# MAKEDEV
#
MAKEDEV := makedev
MAKEDEV_VERSION := 2.3.1-27
MAKEDEV_SPEC := stm-target-$(MAKEDEV).spec
MAKEDEV_SPEC_PATCH :=
MAKEDEV_PATCHES :=

MAKEDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm

$(MAKEDEV_RPM): \
		$(addprefix Patches/,$(MAKEDEV_SPEC_PATCH) $(MAKEDEV_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MAKEDEV)-$(MAKEDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MAKEDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(MAKEDEV_SPEC) < $(buildprefix)/Patches/$(MAKEDEV_SPEC_PATCH) ) &&) \
	$(if $(MAKEDEV_PATCHES),cp $(addprefix Patches/,$(MAKEDEV_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MAKEDEV_SPEC)

$(DEPDIR)/$(MAKEDEV): root/sbin/MAKEDEV $(MAKEDEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(INSTALL) -m 755 root/sbin/MAKEDEV $(prefix)/$*cdkroot/sbin
	touch $@

#
# BASE-FILES
#
BASE_FILES := base-files
BASE_FILES_VERSION := 2.0-8
BASE_FILES_SPEC := stm-target-$(BASE_FILES).spec
BASE_FILES_SPEC_PATCH :=
BASE_FILES_PATCHES :=

BASE_FILES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm

$(BASE_FILES_RPM): \
		$(addprefix Patches/,$(BASE_FILES_SPEC_PATCH) $(BASE_FILES_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_FILES)-$(BASE_FILES_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_FILES_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_FILES_SPEC) < $(buildprefix)/Patches/$(BASE_FILES_SPEC_PATCH) ) &&) \
	$(if $(BASE_FILES_PATCHES),cp $(addprefix Patches/,$(BASE_FILES_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASE_FILES_SPEC)

$(DEPDIR)/$(BASE_FILES): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) $(BASE_FILES_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(BASE_FILES_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	echo "proc          /proc               proc    defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	echo "tmpfs         /tmp                tmpfs   defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	touch $@

#
# LIBATTR
#
LIBATTR := libattr
LIBATTR_DEV := libattr-dev
LIBATTR_VERSION := 2.4.43-4
LIBATTR_SPEC := stm-target-$(LIBATTR).spec
LIBATTR_SPEC_PATCH :=
LIBATTR_PATCHES :=

LIBATTR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR)-$(LIBATTR_VERSION).sh4.rpm
LIBATTR_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR_DEV)-$(LIBATTR_VERSION).sh4.rpm

$(LIBATTR_RPM) $(LIBATTR_DEV_RPM): \
		$(addprefix Patches/,$(LIBATTR_SPEC_PATCH) $(LIBATTR_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(LIBATTR)-$(LIBATTR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBATTR_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBATTR_SPEC) < $(buildprefix)/Patches/$(LIBATTR_SPEC_PATCH) ) &&) \
	$(if $(LIBATTR_PATCHES),cp $(addprefix Patches/,$(LIBATTR_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBATTR_SPEC)

$(DEPDIR)/$(LIBATTR): $(LIBATTR_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBATTR_DEV): $(LIBATTR_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(REWRITE_LIBDIR)/libattr.la
	touch $@

#
# LIBACL
#
LIBACL := libacl
LIBACL_DEV := libacl-dev
LIBACL_VERSION := 2.2.47-6
LIBACL_SPEC := stm-target-$(LIBACL).spec
LIBACL_SPEC_PATCH :=
LIBACL_PATCHES :=

LIBACL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL)-$(LIBACL_VERSION).sh4.rpm
LIBACL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL_DEV)-$(LIBACL_VERSION).sh4.rpm

$(LIBACL_RPM) $(LIBACL_DEV_RPM): \
		$(addprefix Patches/,$(LIBACL_SPEC_PATCH) $(LIBACL_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(LIBACL)-$(LIBACL_VERSION).src.rpm
		libattr libattr-dev
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBACL_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBACL_SPEC) < $(buildprefix)/Patches/$(LIBACL_SPEC_PATCH) ) &&) \
	$(if $(LIBACL_PATCHES),cp $(addprefix Patches/,$(LIBACL_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBACL_SPEC)

$(DEPDIR)/$(LIBACL): $(LIBACL_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBACL_DEV): $(LIBACL_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# USBUTILS
#
USBUTILS := usbutils
USBUTILS_VERSION := 0.86-11
USBUTILS_SPEC := stm-target-$(USBUTILS).spec
USBUTILS_SPEC_PATCH :=
USBUTILS_PATCHES :=
USBUTILS_usbutils = libusb
USBUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(USBUTILS)-$(USBUTILS_VERSION).sh4.rpm

$(USBUTILS_RPM): \
		$(addprefix Patches/,$(USBUTILS_SPEC_PATCH) $(USBUTILS_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(USBUTILS)-$(USBUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(USBUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(USBUTILS_SPEC) < $(buildprefix)/Patches/$(USBUTILS_SPEC_PATCH) ) &&) \
	$(if $(USBUTILS_PATCHES),cp $(addprefix Patches/,$(USBUTILS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(USBUTILS_SPEC)

$(DEPDIR)/$(USBUTILS): $(USBUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# UDEV
#
UDEV := udev
UDEV_DEV := udev-dev
UDEV_VERSION := 162-34
UDEV_SPEC := stm-target-$(UDEV).spec
UDEV_SPEC_PATCH := #$(UDEV_SPEC).$(UDEV_VERSION).diff
UDEV_PATCHES :=

UDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm
UDEV_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV_DEV)-$(UDEV_VERSION).sh4.rpm

$(UDEV_RPM) $(UDEV_DEV_RPM): \
		$(addprefix Patches/,$(UDEV_SPEC_PATCH) $(UDEV_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(UDEV)-$(UDEV_VERSION).src.rpm
		glib2 glib2-dev libacl libacl-dev libusb usbutils
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(UDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(UDEV_SPEC) < $(buildprefix)/Patches/$(UDEV_SPEC_PATCH) ) &&) \
	$(if $(UDEV_PATCHES),cp $(addprefix Patches/,$(UDEV_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(UDEV_SPEC)

$(DEPDIR)/$(UDEV): $(UDEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in sysfs udev ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	touch $@

$(DEPDIR)/$(UDEV_DEV): $(UDEV_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
