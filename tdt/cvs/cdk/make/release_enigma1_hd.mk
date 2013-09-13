#Trick ALPHA-Version ;)
$(DEPDIR)/min-release_enigma1_hd $(DEPDIR)/std-release_enigma1_hd $(DEPDIR)/max-release_enigma1_hd $(DEPDIR)/release_enigma1_hd: \
$(DEPDIR)/%release_enigma1_hd:
	rm -rf $(prefix)/release_enigma1_hd || true
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/bin && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/sbin && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/boot && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/dev && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/hdd && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/lib && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/ram && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/var && \
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/var/etc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_enigma1_hd && \
	touch $(prefix)/release_enigma1_hd/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_enigma1_hd/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_enigma1_hd/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_enigma1_hd/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_enigma1_hd/etc/init.d/ && \
cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(ATEVIO7500),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI)$(if $(ADB_BOX),_adb_box) $(prefix)/release_enigma1_hd/sbin/MAKEDEV && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_enigma1_hd/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release_enigma1_hd/bin/ && \
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_enigma1_hd/boot/video.elf && \
	$(if $(TF7700),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(UFS922),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI_FTA),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_250HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_2000HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(CUBEREVO_9500HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(FORTIS_HDBOX),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	$(if $(ATEVIO7500),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_enigma1_hd/boot/video.elf &&) \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_enigma1_hd/boot/audio.elf && \
	cp -a $(targetprefix)/dev/* $(prefix)/release_enigma1_hd/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_enigma1_hd/etc/ && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_enigma1_hd/etc/ &&) \
##	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_enigma1_hd/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_enigma1_hd/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_enigma1_hd/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_enigma1_hd/etc/init.d/ && \
	echo "576i50" > $(prefix)/release_enigma1_hd/etc/videomode && \
cp $(buildprefix)/root/release/rcS_enigma1_hd$(if $(TF7700),_$(TF7700))$(if $(UFS910),_$(UFS910))$(if $(UFS922),_$(UFS922))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_enigma1_hd/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rcS && \
	mkdir -p $(prefix)/release_enigma1_hd/usr/local/bin && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_enigma1_hd/etc/init.d/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_enigma1_hd/lib/ && \
	rm -f $(prefix)/release_enigma1_hd/lib/*.a && \
	rm -f $(prefix)/release_enigma1_hd/lib/*.o && \
	rm -f $(prefix)/release_enigma1_hd/lib/*.la && \
	find $(prefix)/release_enigma1_hd/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;
if !STM22
	cp $(buildprefix)/root/release/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(UFS910),_$(UFS910))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_enigma1_hd/etc/init.d/rcS
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_enigma1_hd/lib/modules/
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_enigma1_hd/lib/modules/)

if ENABLE_TF7700

	echo "tf7700" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_enigma1_hd/etc/fstab

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_enigma1_hd/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_enigma1_hd/etc/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/gotosleep
else
if ENABLE_UFS922

	echo "ufs922" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/gotosleep
else
if ENABLE_CUBEREVO
	echo "cuberevo" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI
	echo "cuberevo-mini" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI2
	echo "cuberevo-mini2" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI_FTA
	echo "cuberevo-mini-fta" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_250HD
	echo "cuberevo-250hd" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_2000HD
	echo "cuberevo-2000hd" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_CUBEREVO_9500HD
	echo "cuberevo-9500hd" > $(prefix)/release_enigma1_hd/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_enigma1_hd/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_enigma1_hd/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_enigma1_hd/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_enigma1_hd/etc/init.d/halt
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/umountfs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/rc
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_enigma1_hd/etc/init.d/halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_enigma1_hd/etc/rc.d
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/reboot
	ln -fs halt $(prefix)/release_enigma1_hd/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_enigma1_hd/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_enigma1_hd/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/modules/simu_button.ko
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/tffpctl
	rm -f $(prefix)/release_enigma1_hd/bin/vfdctl
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
	rm -f $(prefix)/release_enigma1_hd/bin/tfd2mtd
else
if ENABLE_FORTIS_HDBOX

	echo "fortis" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_enigma1_hd/lib/modules/

if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules
endif

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
if ENABLE_ATEVIO7500

	echo "fortis" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
if ENABLE_HS7810A

	echo "hs7810a" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs7810a/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_enigma1_hd/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules
endif

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
if ENABLE_HS7110

	echo "hs7110" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs7110/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_enigma1_hd/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules
endif

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
else
if ENABLE_ATEMIO520

	echo "atemio520" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs7110/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_enigma1_hd/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules
endif

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
if ENABLE_ATEMIO530

	echo "atemio530" > $(prefix)/release_enigma1_hd/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs7110/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_enigma1_hd/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules
endif

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_enigma1_hd/bin/evremote
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_enigma1_hd/lib/modules/

	rm -f $(prefix)/release_enigma1_hd/lib/firmware/dvb-fe-cx21143.fw
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_enigma1_hd/lib/modules/
if !ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_enigma1_hd/lib/modules/
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_enigma1_hd/lib/modules/
endif

if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_enigma1_hd/lib/modules/
endif
endif
if ENABLE_PLAYER131
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
	find $(prefix)/release_enigma1_hd/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/video/stm/stm_v4l2.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_enigma1_hd/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
			echo "`basename $$mod` not found" ; \
		fi;\
	done
endif

if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
	find $(prefix)/release_enigma1_hd/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_enigma1_hd/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_enigma1_hd/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_enigma1_hd/lib/modules/
	find $(prefix)/release_enigma1_hd/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		sound/kreplay/kreplay.ko \
		sound/kreplay/kreplay-fdma.ko \
		sound/ksound/ktone.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_enigma1_hd/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_enigma1_hd/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if STM22
	rm $(prefix)/release_enigma1_hd/lib/modules/p2div64.ko
endif
	rm -rf $(prefix)/release_enigma1_hd/lib/autofs
	rm -rf $(prefix)/release_enigma1_hd/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/media
	ln -s /hdd $(prefix)/release_enigma1_hd/media/hdd
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/media/dvd

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/mnt
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/root

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/proc
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/sys
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/tmp

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr
	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/bin
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_enigma1_hd/usr/bin/
if ENABLE_TF7700
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_enigma1_hd/usr/bin/
endif

if ENABLE_UFS910
#	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_enigma1_hd/usr/bin/
	touch $(prefix)/release_enigma1_hd/usr/bin/lircd
endif

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_enigma1_hd/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_enigma1_hd/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/tuxtxt


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share

#######################################################################################


#######################################################################################

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_enigma1_hd/usr/share/zoneinfo/

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_enigma1_hd/usr/share/udhcpc/


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/local

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/local/bin
	cp -rd $(targetprefix)/usr/bin/enigma $(prefix)/release_enigma1_hd/usr/bin/
	find $(prefix)/release_enigma1_hd/usr/local/bin/ -name  enigma -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################

	mkdir -p $(prefix)/release_enigma1_hd/usr/share/fonts
	mkdir -p $(prefix)/release_enigma1_hd/etc/fonts
	cp -d $(buildprefix)/root/usr/share/fonts/seg.ttf $(prefix)/release_enigma1_hd/usr/share/fonts/


#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/lib

	mkdir -p $(prefix)/release_enigma1_hd/usr/local/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_enigma1_hd/usr/lib/
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/engines
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/enigma2
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/gconv
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/pkgconfig
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_enigma1_hd/usr/lib/X11
	rm -f $(prefix)/release_enigma1_hd/usr/lib/*.a
	rm -f $(prefix)/release_enigma1_hd/usr/lib/*.o
	rm -f $(prefix)/release_enigma1_hd/usr/lib/*.la
	find $(prefix)/release_enigma1_hd/usr/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma1_hd #############
	cp -RP $(buildprefix)/own_build/enigma1_hd/* $(prefix)/release_enigma1_hd/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/include/boost

#	mkdir -p $(prefix)/release_enigma1_hd/usr/include/boost/
##	cp -rd $(targetprefix)/usr/include/boost/shared_container_iterator.hpp $(prefix)/release_enigma1_hd/usr/include/boost/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share/locale

	cp -rd $(targetprefix)/usr/share/locale/* $(prefix)/release_enigma1_hd/usr/share/locale

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share/locale

	cp -rd $(buildprefix)/root/usr/share/tuxbox $(prefix)/release_enigma1_hd/usr/share/
	ln -sf /usr/share/zoneinfo/CET $(prefix)/release_enigma1_hd/etc/localtime
	rm -rf $(prefix)/release_enigma1_hd/var/etc
	ln -sf /etc $(prefix)/release_enigma1_hd/var
	ln -sf /usr/share $(prefix)/release_enigma1_hd/
	ln -sf /usr/share/tuxbox/config/enigma $(prefix)/release_enigma1_hd/
	ln -sf /usr/share/tuxbox/keymaps $(prefix)/release_enigma1_hd/usr/local
##	echo "$(DEFAULT_VIDEOMODE)" >$(prefix)/release_enigma1_hd/etc/videomode

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/etc
	touch $(prefix)/release_enigma1_hd/etc/.firstboot
	cp -rd $(buildprefix)/root/etc/*.xml $(prefix)/release_enigma1_hd/etc/
	cp -rd $(buildprefix)/root/root_enigma1_hd/etc/* $(prefix)/release_enigma1_hd/etc/
	rm -rf $(prefix)/release_enigma1_hd/etc/tuxbox
	ln -sf /usr/share/tuxbox $(prefix)/release_enigma1_hd/etc
	rm -rf $(prefix)/release_enigma1_hd/var/tuxbox
	ln -sf /etc/tuxbox $(prefix)/release_enigma1_hd/var

	$(INSTALL_DIR) $(prefix)/release_enigma1_hd/usr/share/tuxbox
	cp -rd $(buildprefix)/root/root_enigma1_hd/usr/* $(prefix)/release_enigma1_hd/usr/

	rm -rf $(prefix)/release_enigma1_hd/var/vdr

#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release_enigma1_hd/boot/
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release_enigma1_hd/boot/
endif

if STM24
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_enigma1_hd/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_enigma1_hd/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_enigma1_hd/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_enigma1_hd/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_enigma1_hd/lib/modules || true
endif

	touch $@
