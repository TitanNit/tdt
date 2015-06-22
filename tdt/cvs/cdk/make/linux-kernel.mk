#
# IMPORTANT: it is expected that only one define is set
#
CUBEMOD = $(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)
MODNAME = $(UFS910)$(UFS912)$(UFS913)$(UFS922)$(UFC960)$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(CUBEMOD)$(FORTIS_HDBOX)$(ATEVIO7500)$(OCTAGON1008)$(HS7810A)$(HS7110)$(ATEMIO530)$(ATEMIO520)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)$(SPARK)$(SPARK7162)$(VITAMIN_HD5000)
DEPMOD = $(hostprefix)/bin/depmod

#
# Patches Kernel 24
#
COMMONPATCHES_24 = \
		linux-sh4-linuxdvb_stm24$(PATCH_STR).patch \
		$(if $(P0207)$(P0209),linux-sh4-makefile_stm24.patch) \
		linux-sh4-sound_stm24$(PATCH_STR).patch \
		linux-sh4-time_stm24$(PATCH_STR).patch \
		linux-sh4-init_mm_stm24$(PATCH_STR).patch \
		linux-sh4-copro_stm24$(PATCH_STR).patch \
		linux-sh4-strcpy_stm24$(PATCH_STR).patch \
		linux-sh4-ext23_as_ext4_stm24$(PATCH_STR).patch \
		linux-squashfs-lzma_stm24$(PATCH_STR).patch \
		bpa2_procfs_stm24$(PATCH_STR).patch \
		$(if $(P0207),xchg_fix_stm24$(PATCH_STR).patch) \
		$(if $(P0207),mm_cache_update_stm24$(PATCH_STR).patch) \
		$(if $(P0207),linux-sh4-ehci_stm24$(PATCH_STR).patch) \
		linux-ftdi_sio.c_stm24$(PATCH_STR).patch \
		linux-sh4-lzma-fix_stm24$(PATCH_STR).patch \
		linux-tune_stm24.patch \
		linux-sh4-permit_gcc_command_line_sections_stm24.patch \
		$(if $(P0209)$(P0211)$(P0215)$(P0217),linux-sh4-mmap_stm24.patch) \
		$(if $(P0215)$(P0217),linux-ratelimit-bug_stm24$(PATCH_STR).patch) \
		$(if $(P0209),linux-sh4-dwmac_stm24_0209.patch) \
		$(if $(P0207),linux-sh4-sti7100_missing_clk_alias_stm24$(PATCH_STR).patch) \
		$(if $(P0209),linux-sh4-directfb_stm24$(PATCH_STR).patch) \
		$(if $(P0211)$(P0214)$(P0215)$(P0217),linux-sh4-console_missing_argument_stm24$(PATCH_STR).patch) \
		linux-squashfs-downgrade-stm24$(PATCH_STR)-to-stm23.patch \
		linux-squashfs3.0_lzma_stm24.patch \
		linux-squashfs-downgrade-stm24-2.6.25.patch \
		linux-squashfs-downgrade-stm24-rm_d_alloc_anon.patch

TF7700PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-tf7700_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		$(if $(P0209),linux-sh4-sata-v06_stm24$(PATCH_STR).patch)

UFS910PATCHES_24 = $(COMMONPATCHES_24) \
		stx7100_fdma_fix_stm24$(PATCH_STR).patch \
		sata_32bit_fix_stm24$(PATCH_STR).patch \
		sata_stx7100_B4Team_fix_stm24$(PATCH_STR).patch \
		linux-sh4-ufs910_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-ufs910_reboot_stm24$(PATCH_STR).patch \
		linux-sh4-smsc911x_dma_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-pcm_noise_fix_stm24$(PATCH_STR).patch

UFS912PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ufs912_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		$(if $(P0207),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch)

UFS913PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ufs913_setup_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch

OCTAGON1008PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-octagon1008_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch

ATEVIO7500PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-atevio7500_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch

HS7810APATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-hs7810a_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch

HS7110PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-hs7110_setup_stm24$(PATCH_STR).patch \
		$(if $(P0209)$(P0211)$(P0214)$(P0215)$(P0217),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch)

ATEMIO520PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-atemio520_setup_stm24$(PATCH_STR).patch \
		$(if $(P0209)$(P0211)$(P0214)$(P0215)$(P0217),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch)

ATEMIO530PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-atemio530_setup_stm24$(PATCH_STR).patch \
		$(if $(P0209)$(P0211)$(P0214)$(P0215)$(P0217),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch)

UFS922PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ufs922_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-fortis_hdbox_i2c_st40_stm24$(PATCH_STR).patch

UFC960PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ufs922_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-fortis_hdbox_i2c_st40_stm24$(PATCH_STR).patch

HL101_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-hl101_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch

VIP2_PATCHES_24  = $(COMMONPATCHES_24) \
		linux-sh4-vip2_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch

SPARK_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-spark_setup_stm24$(PATCH_STR).patch \
		$(if $(P0209),linux-sh4-linux_yaffs2_stm24_0209.patch) \
		$(if $(P0209),linux-sh4-lirc_stm.patch) \
		$(if $(P0211)$(P0214)$(P0215)$(P0217),linux-sh4-lirc_stm_stm24$(PATCH_STR).patch) \
		$(if $(P0211)$(P0214)$(P0215)$(P0217),af901x-NXP-TDA18218.patch) \
		dvb-as102.patch

SPARK7162_PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		linux-sh4-spark7162_setup_stm24$(PATCH_STR).patch

FORTISPATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-fortis_hdbox_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		$(if $(P0209),linux-sh4-fortis_hdbox_i2c_st40_stm24$(PATCH_STR).patch)

ADB_BOXPATCHES_24 = $(COMMONPATCHES_24) \
		stx7100_fdma_fix_stm24$(PATCH_STR).patch \
		sata_32bit_fix_stm24$(PATCH_STR).patch \
		linux-sh4-adb_box_setup_stm24$(PATCH_STR).patch \
		linux-usbwait123_stm24.patch \
		linux-sh4-ufs910_reboot_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-pcm_noise_fix_stm24$(PATCH_STR).patch

IPBOX9900PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ipbox9900_setup_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-ipbox_bdinfo_stm24$(PATCH_STR).patch \
		linux-sh4-ipbox_dvb_ca_stm24$(PATCH_STR).patch

IPBOX99PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ipbox99_setup_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-ipbox_bdinfo_stm24$(PATCH_STR).patch

IPBOX55PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-ipbox55_setup_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-ipbox_bdinfo_stm24$(PATCH_STR).patch

CUBEREVOPATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-$(CUBEMOD)_setup_stm24$(PATCH_STR).patch \
		linux-sh4-i2c-st40-pio_stm24$(PATCH_STR).patch \
		linux-sh4-cuberevo_rtl8201_stm24$(PATCH_STR).patch \
		$(if $(P0215)$(P0217)$(CUBEMOD),linux-sh4-$(CUBEMOD)_sound_stm24$(PATCH_STR).patch)

VITAMINHD5000PATCHES_24 = $(COMMONPATCHES_24) \
		linux-sh4-vitamin_hd5000_setup_stm24$(PATCH_STR).patch \
		linux-sh4-stmmac_stm24$(PATCH_STR).patch \
		linux-sh4-lmb_stm24$(PATCH_STR).patch \
		$(if $(P0207),linux-sh4-i2c-stm-downgrade_stm24$(PATCH_STR).patch)

KERNELPATCHES_24 = \
		$(if $(UFS910),$(UFS910PATCHES_24)) \
		$(if $(UFS912),$(UFS912PATCHES_24)) \
		$(if $(UFS913),$(UFS913PATCHES_24)) \
		$(if $(UFS922),$(UFS922PATCHES_24)) \
		$(if $(UFC960),$(UFC960PATCHES_24)) \
		$(if $(TF7700),$(TF7700PATCHES_24)) \
		$(if $(HL101),$(HL101_PATCHES_24)) \
		$(if $(VIP1_V2),$(VIP2_PATCHES_24)) \
		$(if $(VIP2_V1),$(VIP2_PATCHES_24)) \
		$(if $(SPARK),$(SPARK_PATCHES_24)) \
		$(if $(SPARK7162),$(SPARK7162_PATCHES_24)) \
		$(if $(FORTIS_HDBOX),$(FORTISPATCHES_24)) \
		$(if $(HS7810A),$(HS7810APATCHES_24)) \
		$(if $(HS7110),$(HS7110PATCHES_24)) \
		$(if $(ATEMIO520),$(ATEMIO520PATCHES_24)) \
		$(if $(ATEMIO530),$(ATEMIO530PATCHES_24)) \
		$(if $(ATEVIO7500),$(ATEVIO7500PATCHES_24)) \
		$(if $(OCTAGON1008),$(OCTAGON1008PATCHES_24)) \
		$(if $(ADB_BOX),$(ADB_BOXPATCHES_24)) \
		$(if $(IPBOX9900),$(IPBOX9900PATCHES_24)) \
		$(if $(IPBOX99),$(IPBOX99PATCHES_24)) \
		$(if $(IPBOX55),$(IPBOX55PATCHES_24)) \
		$(if $(CUBEMOD),$(CUBEREVOPATCHES_24)) \
		$(if $(VITAMIN_HD5000),$(VITAMINHD5000PATCHES_24))

if DEBUG
DEBUG_STR=.debug
else !DEBUG
DEBUG_STR=
endif !DEBUG

#
# HOST-KERNEL
#
if ENABLE_P0209
HOST_KERNEL_REVISION = 8c676f1a85935a94de1fb103c0de1dd25ff69014
endif
if ENABLE_P0211
HOST_KERNEL_REVISION = 3bce06ff873fb5098c8cd21f1d0e8d62c00a4903
endif
if ENABLE_P0214
HOST_KERNEL_REVISION = 5cf7f6f209d832a4cf645125598f86213f556fb3
endif
if ENABLE_P0215
HOST_KERNEL_REVISION = 5384bd391266210e72b2ca34590bd9f543cdb5a3
endif
if ENABLE_P0217
HOST_KERNEL_REVISION = b43f8252e9f72e5b205c8d622db3ac97736351fc
endif
HOST_KERNEL_PATCHES = $(KERNELPATCHES_24)
HOST_KERNEL_CONFIG = linux-sh4-$(subst _stm24_,_,$(KERNELVERSION))_$(MODNAME).config$(DEBUG_STR)

$(D)/linux-kernel: $(D)/bootstrap $(buildprefix)/Patches/$(BUILDCONFIG)/$(HOST_KERNEL_CONFIG) | $(HOST_U_BOOT_TOOLS)
	rm -rf linux-sh4*
	REPO=git://git.stlinux.com/stm/linux-sh4-2.6.32.y.git;protocol=git;branch=stmicro; \
	[ -d "$(archivedir)/linux-sh4-2.6.32.y.git" ] && \
	(echo "Updating STlinux kernel source"; cd $(archivedir)/linux-sh4-2.6.32.y.git; git pull;); \
	[ -d "$(archivedir)/linux-sh4-2.6.32.y.git" ] || \
	(echo "Getting STlinux kernel source"; git clone -n $$REPO $(archivedir)/linux-sh4-2.6.32.y.git); \
	(echo "Copying kernel source code to build environment"; cp -ra $(archivedir)/linux-sh4-2.6.32.y.git $(buildprefix)/$(KERNEL_DIR)); \
	(echo "Applying patch level P0$(KERNELLABEL)"; cd $(KERNEL_DIR); git checkout -q $(HOST_KERNEL_REVISION))
	$(if $(HOST_KERNEL_PATCHES),cd $(KERNEL_DIR) && cat $(HOST_KERNEL_PATCHES:%=$(buildprefix)/Patches/$(BUILDCONFIG)/%) | patch -p1)
	$(INSTALL) -m644 Patches/$(BUILDCONFIG)/$(HOST_KERNEL_CONFIG) $(KERNEL_DIR)/.config
	-rm $(KERNEL_DIR)/localversion*
	echo "$(KERNELSTMLABEL)" > $(KERNEL_DIR)/localversion-stm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh oldconfig
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/asm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/linux/version.h
	$(MAKE) -C $(KERNEL_DIR) uImage modules \
		ARCH=sh \
		CROSS_COMPILE=$(target)-
	$(MAKE) -C $(KERNEL_DIR) modules_install \
		ARCH=sh \
		CROSS_COMPILE=$(target)- \
		INSTALL_MOD_PATH=$(targetprefix)
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $(bootprefix)/vmlinux.ub && \
	$(INSTALL) -m644 $(KERNEL_DIR)/vmlinux $(targetprefix)/boot/vmlinux-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/System.map $(targetprefix)/boot/System.map-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/COPYING $(targetprefix)/boot/LICENSE && \
	cp $(KERNEL_DIR)/arch/sh/boot/uImage $(targetprefix)/boot/ && \
	rm $(targetprefix)/lib/modules/$(KERNELVERSION)/build || true && \
	rm $(targetprefix)/lib/modules/$(KERNELVERSION)/source || true
	touch $@

$(D)/tfkernel.do_compile:
	cd $(KERNEL_DIR) && \
		$(MAKE) $(if $(TF7700),TF7700=y) ARCH=sh CROSS_COMPILE=$(target)- uImage
	touch $@

linux-kernel-clean:
	rm -f $(DEPDIR)/linux-kernel

#
# Helper
#
linux-kernel.menuconfig linux-kernel.xconfig: \
linux-kernel.%:
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=sh4-linux- $*
	@echo
	@echo "You have to edit m a n u a l l y Patches/linux-$(KERNELVERSION).config to make changes permanent !!!"
	@echo ""
	diff $(KERNEL_DIR)/.config.old $(KERNEL_DIR)/.config
	@echo ""