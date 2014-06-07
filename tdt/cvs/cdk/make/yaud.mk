#
# BOOTSTRAP
#
$(DEPDIR)/bootstrap: \
	build.env \
	$(FILESYSTEM) \
	| $(GLIBC_DEV) \
	$(CROSS_LIBGCC) \
	$(BINUTILS) \
	$(BINUTILS_DEV) \
	$(GMP) \
	$(MPFR) \
	$(MPC) \
	$(LIBSTDC) \
	$(LIBSTDC_DEV)
	touch $@

#
# BARE-OS
#
$(DEPDIR)/bare-os: \
	bootstrap \
	$(LIBTERMCAP) \
	$(NCURSES_BASE) \
	$(NCURSES) \
	$(NCURSES_DEV) \
	$(BASE_PASSWD) \
	$(MAKEDEV) \
	$(BASE_FILES) \
	module_init_tools \
	busybox \
	\
	libz \
	$(INITSCRIPTS) \
	$(NETBASE) \
	$(BC) \
	$(SYSVINIT) \
	$(SYSVINITTOOLS) \
	$(DISTRIBUTIONUTILS) \
	\
	u-boot-utils \
	diverse-tools
	touch $@

#	openrdate

#
# NET-UTILS
#
$(DEPDIR)/net-utils: \
	$(NETKIT_FTP) \
	portmap \
	nfs_utils \
	vsftpd \
	autofs \
	$(CIFS)
	touch $@
#	opkg

#
# DISK-UTILS
#
$(DEPDIR)/disk-utils: \
	e2fsprogs \
	$(XFSPROGS) \
	jfsutils \
	$(SG3)
	touch $@

#
# YAUD NONE
#
$(DEPDIR)/yaud-none: \
	bare-os \
	linux-kernel \
	disk-utils \
	net-utils \
	driver \
	misc-tools
	touch $@

#
# YAUD
#
yaud-neutrino: yaud-none lirc \
		boot-elf remote firstboot neutrino release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-next: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp-next release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-plugins: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp neutrino-mp-plugins release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-next-plugins: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp-next neutrino-mp-plugins release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-all: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp neutrino-mp-plugins shairport release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-next-all: yaud-none lirc \
		boot-elf remote firstboot neutrino-mp-next neutrino-mp-plugins shairport release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp: yaud-none lirc \
		boot-elf remote firstboot neutrino-hd2-exp release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp-plugins: yaud-none lirc \
		boot-elf remote firstboot neutrino-hd2-exp neutrino-mp-plugins release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2-pli-nightly enigma2-plugins release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-titan: yaud-none lirc \
		boot-elf remote firstboot titan release_titan
	@TUXBOX_YAUD_CUSTOMIZE@