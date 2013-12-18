# This file contains different cleaning targets. They try to be, at least
# in spirit, compatible with the GNU Makefiles standards.

# Note: automake defines targets clean etc, the Makefile author
# therefore should not. Instead, we define targets like clean-local,
# which are called from automake's clean.


# Delete all marker files in .deps, except those belonging to bootstrap,
# thus forcing unpack-patch-install-delete-targets to be rebuilt.
depsclean:
	$(DEPSCLEANUP)

# currently rpmdepsclean is including targets made by tuxbox rules
rpmdepsclean:
	( cd .deps && find . ! -name "*\.*" -delete )

mostlyclean-local: cdk-clean

# Clean tuxbox source directories
cdk-clean:
	-$(MAKE) -C linux-sh4 clean
	-$(MAKE) -C $(driverdir) KERNEL_LOCATION=$(buildprefix)/linux-sh4 \
		BIN_DEST=$(targetprefix)/bin \
		INSTALL_MOD_PATH=$(targetprefix) clean
	-$(MAKE) -C $(appsdir)/misc/tools distclean
#	-$(MAKE) -C $(appsdir)/dvb/dvbsnoop clean
	-rm -rf build

# Clean tuxbox source directories. Clean up in cdkroot as much as the
# uninstall facilities of the components allow.
clean-local: mostlyclean-local depsclean rpmdepsclean
	-rm -rf $(hostprefix)
	-rm -rf $(configprefix)
	-rm -rf $(devkitprefix)
	-rm -rf $(prefix)/*cdkroot
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(prefix)/release*
	-rm -rf SOURCES SPECS BUILD && install -d SOURCES SPECS BUILD
	-rm -rf build.env
	-rm -rf $(DEPDIR)/u-boot-utils*
	-rm -rf $(DEPDIR)/linux-kernel*

# Be brutal...just nuke it!
distclean-local:
	-$(MAKE) -C $(appsdir) distclean
#	-$(MAKE) -C $(appsdir)/dvb/dvbsnoop distclean
	-$(MAKE) -C $(appsdir)/misc/tools distclean
	-$(MAKE) -C $(hostappsdir) distclean
	-$(MAKE) driver-clean
	-rm -f Makefile-archive
	-rm -f rules-downcheck.pl
	-rm -f linux-sh4
	-rm -rf $(appsdir)/enigma2-*
	-rm -rf $(appsdir)/neutrino-*
	-rm -rf $(appsdir)/nhd2-*
	-rm -rf $(appsdir)/libstb-*
	-rm -rf $(appsdir)/xbmc-*
	-rm -rf $(DEPDIR)
#	-rm -rf $(targetprefix)
	-rm -rf $(hostprefix)
	-rm -rf $(serversupport)
	-rm -rf $(crossprefix)/
	-rm -rf $(configprefix)/
	-rm -rf $(devkitprefix)/
	-rm -rf $(prefix)/*cdkroot/
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(rpmdbprefix)/
	-rm -rf SOURCES SPECS BUILD BUILDROOT SRPMS RPMS
	-rm -rf $(prefix)/ccache
	-rm -rf $(kernelprefix)/u-boot
	-rm -rf $(STGFB_DIR)
	-@DISTCLEANUP@

#
# RPM stuff
#
list-clean:
	make $(LIST_CLEAN)

$(LIST_CLEAN): \
%-clean:
	-$(DEPSCLEANUP_$*)

$(RPMLIST_CLEAN): \
%-clean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -clean,,$@)
	-$(DEPSCLEANUP_$*)

%-clean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-$(subst -clean,,$@)
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -clean,,$@)
	-rm .deps/$(subst -clean,,$@)

list-distclean:
	make $(LIST_DISTCLEAN)

$(LIST_DISTCLEAN): \
%-distclean:
	-$(DISTCLEANUP_$*)
	-$(DEPSDISTCLEANUP_$*)

$(RPMLIST_DISTCLEAN): \
%-distclean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -distclean,,$@)
	-rm RPMS/sh4/$(STLINUX)-sh4-$(subst -distclean,,$@)*
	-$(DEPSDISTCLEANUP_$*)

%-distclean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-$(subst -distclean,,$@)
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -distclean,,$@)
	-rm RPMS/${host_arch}/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/noarch/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/sh4/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/sh4/$(STLINUX)-sh4-$(subst -distclean,,$@)*
	-rm .deps/$(subst -distclean,,$@)*

.PHONY: depsclean mostlyclean-local cdk-clean distclean-local list-clean
