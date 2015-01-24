#
# auxiliary targets for model-specific builds
#

#
# release_common_utils
#
release_titan_common_utils:
#	remove the slink to busybox
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp -f $(targetprefix)/etc/init.d/umountfs $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/reboot $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/rc $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/network $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/networking $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/mountvirtfs $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/mountall $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/hostname $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/vsftpd $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/bootclean.sh $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/getfb.awk $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/makedev $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/udhcpc $(prefix)/release_titan/etc/init.d/
	cp -f $(targetprefix)/etc/init.d/autofs $(prefix)/release_titan/etc/init.d/
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

#
# release_cube_common
#
release_titan_cube_common:
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/bin/eeprom $(prefix)/release_titan/bin
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox/micom.ko $(prefix)/release_titan/lib/modules/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx21143}.fw
#	rm -f $(prefix)/release_titan/bin/vfdctl

#
# release_cube_common_tunner
#
release_titan_cube_common_tunner:
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release_titan/lib/modules/

#
# release_cuberevo_9500hd
#
release_titan_cuberevo_9500hd: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-9500hd" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo_2000hd
#
release_titan_cuberevo_2000hd: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-2000hd" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo_250hd
#
release_titan_cuberevo_250hd: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-250hd" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo_mini_fta
#
release_titan_cuberevo_mini_fta: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-mini-fta" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo_mini2
#
release_titan_cuberevo_mini2: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-mini2" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo_mini
#
release_titan_cuberevo_mini: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo-mini" > $(prefix)/release_titan/etc/hostname

#
# release_cuberevo
#
release_titan_cuberevo: release_titan_common_utils release_titan_cube_common release_titan_cube_common_tunner
	echo "cuberevo" > $(prefix)/release_titan/etc/hostname

#
# release_common_ipbox
#
release_titan_common_ipbox:
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release_titan/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release_titan/usr/bin/lircd
	rm -f $(prefix)/release_titan/lib/firmware/*
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/lib/modules/bpamem.ko
	rm -f $(prefix)/release_titan/lib/modules/ramzswap.ko
	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvbi.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvout.ko
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/etc/network/interfaces

#
# release_ipbox9900
#
release_titan_ipbox9900: release_titan_common_utils release_titan_common_ipbox
	echo "ipbox9900" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/rmu/rmu.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_titan/usr/bin/tvmode

#
# release_ipbox99
#
release_titan_ipbox99: release_titan_common_utils release_titan_common_ipbox
	echo "ipbox99" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_titan/usr/bin/tvmode

#
# release_ipbox55
#
release_titan_ipbox55: release_titan_common_utils release_titan_common_ipbox
	echo "ipbox55" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox55/front.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox55 $(prefix)/release_titan/usr/bin/tvmode

#
# release_ufs910
#
release_titan_ufs910: release_titan_common_utils
	echo "ufs910" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_titan/lib/firmware/video.elf
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,stv6306}.fw
	mv $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_titan/etc/
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/
	rm -f $(prefix)/release_titan/bin/vdstandby
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_ufs912
#
release_titan_ufs912: release_titan_common_utils
	echo "ufs912" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_ufs913
#
release_titan_ufs913: release_titan_common_utils
	echo "ufs913" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_ufs922
#
release_titan_ufs922: release_titan_common_utils
	echo "ufs922" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl6222,cx24116}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_ufc960
#
release_titan_ufc960: release_titan_common_utils
	echo "ufc960" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_spark
#
release_titan_spark: release_titan_common_utils
	echo "spark" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom_spark/aotom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	[ -e $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko ] && cp $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko $(prefix)/release_titan/lib/modules/encrypt.ko || true
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/vdstandby
	rm -f $(prefix)/release_titan/bin/eeprom
	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_titan/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_titan/sbin

#
# release_spark7162
#
release_titan_spark7162: release_titan_common_utils
	echo "spark7162" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_spark7162 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom_spark/aotom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp -f $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/i2c_spi/i2s.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/bin/vdstandby
	rm -f $(prefix)/release_titan/bin/eeprom
	cp -dp $(buildprefix)/root/etc/lircd_spark7162.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/
	cp -f $(buildprefix)/root/sbin/flashcp $(prefix)/release_titan/sbin
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_titan/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_titan/sbin

#
# release_fortis_hdbox
#
release_titan_fortis_hdbox: release_titan_common_utils
	echo "fortis" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_atevio7500
#
release_titan_atevio7500: release_titan_common_utils
	echo "atevio7500" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_titan/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_titan/lib/firmware/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/lib/modules/mpeg2hw.ko
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_octagon1008
#
release_titan_octagon1008: release_titan_common_utils
	echo "octagon1008" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_titan/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_titan/lib/firmware/
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	rm -f $(prefix)/release_titan/bin/eeprom

#
# release_hs7810a
#
release_titan_hs7810a: release_titan_common_utils
	echo "hs7810a" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_hs7810a $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw

#
# release_hs7110
#
release_titan_hs7110: release_titan_common_utils
	echo "hs7110" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_hs7110 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw

#
# release_atemio520
#
release_titan_atemio520: release_titan_common_utils
	echo "atemio520" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_atemio520 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/cn_micom/cn_micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw

#
# release_atemio530
#
release_titan_atemio530: release_titan_common_utils
	echo "atemio530" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_atemio530 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/cn_micom/cn_micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/lib/firmware/audio.elf
	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw

#
# release_hl101
#
release_titan_hl101: release_titan_common_utils
	echo "hl101" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_hl101 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_titan/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_titan/lib/firmware/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/

#
# release_adb_box
#
release_titan_adb_box: release_titan_common_utils
	echo "Adb_Box" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_adb_box $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp $(buildprefix)/root/firmware/as102_data1_st.hex $(prefix)/release_titan/lib/firmware/
	cp $(buildprefix)/root/firmware/as102_data2_st.hex $(prefix)/release_titan/lib/firmware/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release_titan/etc/fstab
	cp -dp $(buildprefix)/root/etc/lircd_adb_box.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/lircd

#
# release_vip1_v2
#
release_titan_vip1_v2: release_titan_common_utils
	echo "Edision-v2" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_vip2 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	cp -f $(buildprefix)/root/release/fstab_vip2 $(prefix)/release_titan/etc/fstab
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_titan/etc/
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/

#
# release_vip2_v1
#
release_titan_vip2_v1: release_titan_vip1_v2
	echo "Edision-v1" > $(prefix)/release_titan/etc/hostname

#
# release_hs5101
#
release_titan_hs5101: release_titan_common_utils
	echo "hs5101" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button_hs5101/button.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs5101/vfd.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_titan/etc/
	cp -p $(targetprefix)/usr/sbin/lircd $(prefix)/release_titan/usr/bin/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-{avl2108,avl6222,cx21143,stv6306}.fw
	rm -f $(prefix)/release_titan/bin/vdstandby

#
# release_tf7700
#
release_titan_tf7700: release_titan_common_utils
	echo "tf7700" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/lib/firmware/video.elf
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_titan/etc/fstab

#
# release_base
#
# the following target creates the common file base
release_titan_base:
	rm -rf $(prefix)/release_titan || true
	$(INSTALL_DIR) $(prefix)/release_titan && \
	$(INSTALL_DIR) $(prefix)/release_titan/{bin,boot,dev,dev.static,etc,hdd,lib,media,mnt,proc,ram,root,sbin,swap,sys,tmp,usr,var} && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/{fonts,init.d,network,mdev} && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network/{if-down.d,if-post-down.d,if-pre-up.d,if-up.d} && \
	$(INSTALL_DIR) $(prefix)/release_titan/lib/{modules,firmware} && \
	$(INSTALL_DIR) $(prefix)/release_titan/hdd/{movie,music,picture} && \
	$(INSTALL_DIR) $(prefix)/release_titan/media/{dvd,nfs,usb} && \
	ln -sf /hdd $(prefix)/release_titan/media/hdd && \
	$(INSTALL_DIR) $(prefix)/release_titan/mnt/{hdd,nfs,usb} && \
	$(INSTALL_DIR) $(prefix)/release_titan/usr/{bin,lib,share} && \
	$(INSTALL_DIR) $(prefix)/release_titan/usr/share/{fonts,udhcpc,zoneinfo} && \
	$(INSTALL_DIR) $(prefix)/release_titan/usr/share/tuxbox/titan && \
	$(INSTALL_DIR) $(prefix)/release_titan/usr/share/tuxbox/titan/icons/logo && \
	$(INSTALL_DIR) $(prefix)/release_titan/var/{bin,etc,lib} && \
	$(INSTALL_DIR) $(prefix)/release_titan/var/lib/nfs && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_titan && \
	touch $(prefix)/release_titan/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_titan/bin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/shutdown $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_titan/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_titan/sbin/MAKEDEV && \
	cp $(targetprefix)/boot/uImage $(prefix)/release_titan/boot/ && \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/lib/firmware/audio.elf && \
	cp -a $(targetprefix)/dev/* $(prefix)/release_titan/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_titan/etc/ && \
	cp $(buildprefix)/root/etc/inetd.conf $(prefix)/release_titan/etc/ && \
	cp $(buildprefix)/root/etc/modules.available $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_titan/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_titan/etc/network/ && \
	cp -aR $(buildprefix)/root/etc/mdev/* $(prefix)/release_titan/etc/mdev/ && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_titan/usr/share/udhcpc/ && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_titan/usr/share/zoneinfo/ && \
	echo "576i50" > $(prefix)/release_titan/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_titan$(if $(TF7700),_$(TF7700))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(ATEMIO520),_$(ATEMIO520))$(if $(ATEMIO530),_$(ATEMIO530))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(ADB_BOX),_$(ADB_BOX))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(UFS922),_$(UFS922))$(if $(UFC960),_$(UFC960))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) $(prefix)/release_titan/etc/init.d/rcS
	chmod 755 $(prefix)/release_titan/etc/init.d/rcS && \
	cp -dp $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_titan/usr/bin/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_titan/bin/ && \
	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_titan/usr/bin/ && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_titan/sbin/ && \
	rm -f $(prefix)/release_titan/bin/hotplug && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_titan/sbin/ && \
	cp -p $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_titan/sbin/ && \
	ln -sf ../../bin/busybox $(prefix)/release_titan/usr/bin/ether-wake && \
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release_titan/sbin/
if !ENABLE_UFS910
if !ENABLE_UFS922
if !ENABLE_UFC960
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release_titan/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release_titan/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release_titan/sbin/
endif
endif
endif

	cp -dp $(buildprefix)/root/etc/inittab$(if $(FORTIS_HDBOX)$(OCTAGON1008)$(CUBEREVO)$(CUBEREVO_MINI2)$(CUBEREVO_2000HD),_ttyAS1) $(prefix)/release_titan/etc/inittab
	cp $(buildprefix)/root/etc/fw_env.config$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(TF7700),_$(TF7700))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(UFS922),_$(UFS922))$(if $(UFC960),_$(UFC960))$(if $(ADB_BOX),_$(ADB_BOX))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) $(prefix)/release_titan/etc/fw_env.config

#
# Player
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_titan/lib/modules/
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
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_titan/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_titan/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_titan/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";

#
# modules
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_titan/lib/modules/

#
# multicom 323
#
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_titan/lib/modules || true

#
# multicom 406
#
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embx/embx.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embx/embx.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embxmailbox/embxmailbox.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embxmailbox/embxmailbox.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embxshm/embxshm.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/embxshm/embxshm.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/ics/ics.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/ics/ics.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/ics/ics_user.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/ics/ics_user.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/mme/mme.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/mme/mme.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/mme/mme_user.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/src/mme/mme_user.ko $(prefix)/release_titan/lib/modules || true

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_titan/lib/modules/
if !ENABLE_VIP2_V1
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_titan/lib/modules/
endif
endif
endif
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/net/tun.ko ] && cp $(kernelprefix)/linux-sh4/drivers/net/tun.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release_titan/lib/modules || true

if !ENABLE_UFS910
	[ -e $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko $(prefix)/release_titan/lib/modules || true
endif
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/sata_switch/sata.ko $(prefix)/release_titan/lib/modules || true
#
# lib usr/lib
#
	cp -R $(targetprefix)/lib/* $(prefix)/release_titan/lib/
	rm -f $(prefix)/release_titan/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_titan/lib/*
	ln -s /var/plugins/libfx2.so $(prefix)/release_titan/lib/libfx2.so

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_titan/usr/lib/
	rm -rf $(prefix)/release_titan/usr/lib/{engines,enigma2,gconv,ldscripts,libxslt-plugins,pkgconfig,python$(PYTHON_VERSION),sigc++-1.2,X11,lua}
	rm -f $(prefix)/release_titan/usr/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_titan/usr/lib/*

#
# fw_printenv / fw_setenv
#
	if [ -e $(targetprefix)/usr/sbin/fw_printenv ]; then \
		cp -dp $(targetprefix)/usr/sbin/fw_* $(prefix)/release_titan/usr/sbin/; \
	fi

#
# tuxtxt
#
	if [ -e $(targetprefix)/usr/bin/tuxtxt ]; then \
		cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/release_titan/usr/bin/; \
	fi

	if [ -e $(targetprefix)/usr/share/fonts/tuxtxt.otb ] && [ -e $(prefix)/release/usr/share/fonts ]; then \
		cp $(targetprefix)/usr/share/fonts/tuxtxt.otb $(prefix)/release/usr/share/fonts/; \
	fi

#
# fonts
#
#	cp -aR $(targetprefix)/usr/share/fonts/{titan,DejaVuLGCSansMono-Bold}.ttf $(prefix)/release_titan/usr/share/fonts
#	ln -s /usr/share/fonts/DejaVuLGCSansMono-Bold.ttf $(prefix)/release_titan/usr/share/fonts/tuxtxt.ttf

#
# titan
#
	mkdir -p $(prefix)/release_titan/usr/local/bin
	ln -sf /usr/share $(prefix)/release_titan/usr/local/share
	cp $(targetprefix)/usr/local/bin/titan $(prefix)/release_titan/usr/local/bin/
#	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_titan/usr/local/bin/
#	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_titan/usr/local/bin/
#	mkdir -p $(prefix)/release_titan/usr/local/sbin
#	if [ -e $(targetprefix)/usr/local/sbin/udpstreampes ]; then \
#		cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_titan/usr/local/sbin/; \
#	fi
#	if [ -e $(targetprefix)/usr/local/bin/udpstreampes ]; then \
#		cp $(targetprefix)/usr/local/bin/udpstreampes $(prefix)/release_titan/usr/local/bin/; \
#	fi

#
# channellist / tuxtxt
#
#	cp -aR $(targetprefix)/var/tuxbox/config/* $(prefix)/release_titan/var/tuxbox/config
#	cp -aR $(buildprefix)/root/usr/local/share/config/zapit $(prefix)/release_titan/var/tuxbox/config
#	mkdir -p $(prefix)/release_titan/var/tuxbox/config/tuxtxt
#	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_titan/var/tuxbox/config/tuxtxt
#if !ENABLE_CUBEREVO_MINI2
#if !ENABLE_ATEVIO7500
#if !ENABLE_SPARK7162
#	rm -f $(prefix)/release_titan/var/tuxbox/config/cables.xml
#	rm -f $(prefix)/release_titan/var/tuxbox/config/terrestrial.xml
#endif
#endif
#endif

#
# iso-codes
#
#	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_titan/usr/share/

#
# httpd/icons/locale/themes
#
#	cp -aR $(targetprefix)/usr/share/tuxbox/titan/* $(prefix)/release_titan/usr/share/tuxbox/titan

#
# backup/restore NMP
#
	[ -e $(targetprefix)/usr/local/bin/backup.sh ] && cp -aR $(targetprefix)/usr/local/bin/backup.sh $(prefix)/release_titan/bin || true
	[ -e $(targetprefix)/usr/local/bin/restore.sh ] && cp -aR $(targetprefix)/usr/local/bin/restore.sh $(prefix)/release_titan/bin || true

#
# Delete unnecessary files
#
	rm -rf $(prefix)/release_titan/lib/autofs
	rm -rf $(prefix)/release_titan/lib/modules/$(KERNELVERSION)
	rm -rf $(prefix)/release_titan/usr/lib/alsa-lib
	rm -rf $(prefix)/release_titan/usr/lib/alsaplayer
	rm -rf $(prefix)/release_titan/usr/lib/gio
	rm -rf $(prefix)/release_titan/usr/lib/glib-2.0
	rm -rf $(prefix)/release_titan/usr/lib/libffi-3.0.10
	rm -f $(prefix)/release_titan/usr/lib/libbfd*
	rm -f $(prefix)/release_titan/usr/lib/libgmp*
	rm -f $(prefix)/release_titan/usr/lib/libmpfr*
	rm -f $(prefix)/release_titan/usr/lib/libmpc*
	rm -f $(prefix)/release_titan/usr/lib/libexpat*
	rm -f $(prefix)/release_titan/usr/lib/libfontconfig*
	rm -f $(prefix)/release_titan/usr/lib/libtermcap*
	rm -f $(prefix)/release_titan/usr/lib/libmenu*
	rm -f $(prefix)/release_titan/usr/lib/libpanel*
#	rm -f $(prefix)/release_titan/usr/lib/libdvdcss*
#	rm -f $(prefix)/release_titan/usr/lib/libdvdnav*
#	rm -f $(prefix)/release_titan/usr/lib/libdvdread*
	rm -f $(prefix)/release_titan/lib/libncurses*
	rm -f $(prefix)/release_titan/usr/lib/libopcodes*
	rm -f $(prefix)/release_titan/lib/libSegFault*
	rm -f $(prefix)/release_titan/lib/libthread_db*
	rm -f $(prefix)/release_titan/usr/lib/libthread_db*
	rm -f $(prefix)/release_titan/lib/libanl*
	rm -f $(prefix)/release_titan/usr/lib/libanl*
	rm -rf $(prefix)/release_titan/lib/m4-nofpu/
	rm -f $(prefix)/release_titan/usr/lib/libcurses.so
	rm -f $(prefix)/release_titan/usr/lib/libncurses.so
	rm -f $(prefix)/release_titan/usr/lib/libopkg*
	rm -f $(prefix)/release_titan/lib/modules/lzo*.ko
	rm -f $(prefix)/release_titan/bin/gitVCInfo
	rm -f $(prefix)/release_titan/bin/libstb-hal-test

#
# NFS-UTILS
#
	if [ -e $(targetprefix)/usr/sbin/rpc.nfsd ]; then \
		cp -f $(targetprefix)/etc/exports $(prefix)/release_titan/etc/; \
		cp -f $(targetprefix)/etc/init.d/nfs-common $(prefix)/release_titan/etc/init.d/; \
		cp -f $(targetprefix)/etc/init.d/nfs-kernel-server $(prefix)/release_titan/etc/init.d/; \
		cp -f $(targetprefix)/usr/sbin/exportfs $(prefix)/release_titan/usr/sbin/; \
		cp -f $(targetprefix)/usr/sbin/rpc.nfsd $(prefix)/release_titan/usr/sbin/; \
		cp -f $(targetprefix)/usr/sbin/rpc.mountd $(prefix)/release_titan/usr/sbin/; \
		cp -f $(targetprefix)/usr/sbin/rpc.statd $(prefix)/release_titan/usr/sbin/; \
	fi

#
# AUTOFS
#
	if [ -d $(prefix)/release_titan/usr/lib/autofs ]; then \
		cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/; \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release_titan/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release_titan/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release_titan/etc/init.d/; \
		ln -s /usr/sbin/automount $(prefix)/release_titan/sbin/automount; \
	fi

#
# GSTREAMER
#
	if [ -d $(prefix)/release_titan/usr/lib/gstreamer-0.10 ]; then \
		#removed rm \
		rm -rf $(prefix)/release_titan/usr/lib/libgstfft*; \
		rm -rf $(prefix)/release_titan/usr/lib/gstreamer-0.10/*; \
		cp -a $(targetprefix)/usr/bin/gst-* $(prefix)/release_titan/usr/bin/; \
		sh4-linux-strip --strip-unneeded $(prefix)/release_titan/usr/bin/gst-launch*; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstalsa.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapetag.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapp.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstasf.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstassrender.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioconvert.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioparsers.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioresample.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstautodetect.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstavi.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcdxaparse.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreelements.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreindexers.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin2.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbvideosink.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvdsub.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflac.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflv.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstfragmented.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsticydemux.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstid3demux.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstisomp4.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmad.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmatroska.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegdemux.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegstream.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstogg.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstplaybin.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtmp.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtp.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtpmanager.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtsp.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubparse.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstudp.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstvcdsrc.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstwavparse.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpegscale.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstpostproc.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		fi; \
		if [ -e $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so $(prefix)/release_titan/usr/lib/gstreamer-0.10/; \
		fi; \
		sh4-linux-strip --strip-unneeded $(prefix)/release_titan/usr/lib/gstreamer-0.10/*; \
	fi

#
# GRAPHLCD
#
	if [ -e $(prefix)/release_titan/usr/lib/libglcddrivers.so ]; then \
		cp -f $(targetprefix)/etc/graphlcd.conf $(prefix)/release_titan/etc/graphlcd.conf; \
		rm -f $(prefix)/release_titan/usr/lib/libglcdskin.so*; \
	fi

#
# Tuxbox Commander
#
	if [ -e $(targetprefix)/var/plugins/tuxcom.so -a -e $(targetprefix)/var/plugins/tuxcom.cfg ]; then \
		cp -f $(targetprefix)/var/plugins/tuxcom* $(prefix)/release_titan/var/plugins; \
	fi

#
# Plugins
#
	if [ -e $(targetprefix)/var/plugins/libfx2.so ]; then \
		cp -f $(targetprefix)/var/plugins/*.so $(prefix)/release_titan/var/plugins; \
		cp -f $(targetprefix)/var/plugins/*.cfg $(prefix)/release_titan/var/plugins; \
		cp -af $(targetprefix)/bin/{shellexec,msgbox,getrc,input} $(prefix)/release_titan/bin; \
	fi
	if [ -e $(prefix)/release_titan/var/plugins/tuxwetter.so ]; then \
		cp -rf $(targetprefix)/var/tuxbox/config/tuxwetter $(prefix)/release_titan/var/tuxbox/config; \
	fi
	if [ -e $(prefix)/release_titan/var/plugins/soko.so ]; then \
		cp -rf $(targetprefix)/usr/share/tuxbox/sokoban $(prefix)/release_titan/var/plugins; \
		ln -s /var/plugins/sokoban $(prefix)/release_titan/usr/share/tuxbox/sokoban; \
	fi
#
# shairport
#
	if [ -e $(targetprefix)/usr/bin/shairport ]; then \
		cp -f $(targetprefix)/usr/bin/shairport $(prefix)/release_titan/usr/bin; \
		cp -f $(targetprefix)/usr/bin/mDNSPublish $(prefix)/release_titan/usr/bin; \
		cp -f $(targetprefix)/usr/bin/mDNSResponder $(prefix)/release_titan/usr/bin; \
		cp -f $(buildprefix)/root/etc/init.d/shairport $(prefix)/release_titan/etc/init.d/shairport; \
		chmod 755 $(prefix)/release_titan/etc/init.d/shairport; \
		cp -f $(targetprefix)/usr/lib/libhowl.so* $(prefix)/release_titan/usr/lib; \
		cp -f $(targetprefix)/usr/lib/libmDNSResponder.so* $(prefix)/release_titan/usr/lib; \
	fi
#
# titan HD2 Workaround Build in Player
#
	if [ -e $(targetprefix)/usr/local/bin/eplayer3 ]; then \
		cp -f $(targetprefix)/usr/local/bin/eplayer3 $(prefix)/release_titan/bin/; \
		cp -f $(targetprefix)/usr/local/bin/meta $(prefix)/release_titan/bin/; \
	fi

#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/release_titan: \
$(DEPDIR)/%release_titan: release_titan_base release_titan_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(UFS922)$(UFC960)$(SPARK)$(SPARK7162)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(ATEMIO520)$(ATEMIO530)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(ADB_BOX)
	touch $@

#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/titan
#
#	default for all receiver
	find $(buildprefix)/own_build/titan/ -mindepth 1 -maxdepth 1 -exec cp -at$(prefix)/release_titan/ -- {} +
#	receiver specific (only if directory exist)
	[ -d "$(buildprefix)/own_build/titan.$(BOXTYPE)" ] && find $(buildprefix)/own_build/titan.$(BOXTYPE)/ -mindepth 1 -maxdepth 1 -exec cp -at$(prefix)/release_titan/ -- {} + || true
	rm -f $(prefix)/release_titan/for_your_own_changes

# nicht die feine Art, aber funktioniert ;)
	cp -dpfr $(prefix)/release_titan/etc $(prefix)/release_titan/var
	rm -fr $(prefix)/release_titan/etc
	ln -sf /var/etc $(prefix)/release_titan

	ln -s /tmp $(prefix)/release_titan/lib/init
	ln -s /tmp $(prefix)/release_titan/var/lib/urandom
	ln -s /tmp $(prefix)/release_titan/var/lock
	ln -s /tmp $(prefix)/release_titan/var/log
	ln -s /tmp $(prefix)/release_titan/var/run
	ln -s /tmp $(prefix)/release_titan/var/tmp

#
#
#
#	mv -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/scan.jpg $(prefix)/release_titan/var/boot/
#	ln -s /var/boot/scan.jpg $(prefix)/release_titan/usr/share/tuxbox/titan/icons/
#	mv -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/mp3.jpg $(prefix)/release_titan/var/boot/
#	ln -s /var/boot/mp3.jpg $(prefix)/release_titan/usr/share/tuxbox/titan/icons/
#	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/mp3-?.jpg
#	mv -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/shutdown.jpg $(prefix)/release_titan/var/boot/
#	ln -s /var/boot/shutdown.jpg $(prefix)/release_titan/usr/share/tuxbox/titan/icons/
#	mv -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/radiomode.jpg $(prefix)/release_titan/var/boot/
#	ln -s /var/boot/radiomode.jpg $(prefix)/release_titan/usr/share/tuxbox/titan/icons/
#	mv -f $(prefix)/release_titan/usr/share/tuxbox/titan/icons/start.jpg $(prefix)/release_titan/var/boot/
#	ln -s /var/boot/start.jpg $(prefix)/release_titan/usr/share/tuxbox/titan/icons/

#	mkdir -p $(prefix)/release_titan/usr/share/alsa
#	cp -dp $(targetprefix)/usr/share/alsa/alsa.conf $(prefix)/release_titan/usr/share/alsa/alsa.conf

	rm -f $(prefix)/release_titan/bin/pic2m2v
	rm -f $(prefix)/release_titan/usr/lib/*.py
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v1.jpg
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v2.jpg
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v3.jpg
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v4.jpg
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v5.jpg
	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_cst_v6.jpg
#if !ENABLE_SPARK
#if !ENABLE_SPARK7162
#	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_spark_new.jpg
#	rm -f $(prefix)/release_titan/usr/share/tuxbox/titan/httpd/images/rc_spark_old.jpg
#endif
#endif

#
# sh4-linux-strip all
#
	find $(prefix)/release_titan/ -name '*' -exec sh4-linux-strip --strip-unneeded {} &>/dev/null \;

#
# release-clean
#
release_titan-clean:
	rm -f $(DEPDIR)/release_titan
