#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-31)"
 echo "Parameter 2: kernel (1-4)"
 echo "Parameter 3: debug (y/N)"
 echo "Parameter 4: player (1-2)"
 echo "Parameter 5: Media Framework (1-4)"
 echo "Parameter 6: External LCD support (1-2)"
 exit
fi

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}

CONFIGPARAM=" \
 --enable-maintainer-mode \
 --prefix=$KATIDIR/tufsbox \
 --with-cvsdir=$KATIDIR/cvs \
 --with-customizationsdir=$KATIDIR/custom \
 --with-flashscriptdir=$KATIDIR/flash \
 --with-archivedir=$HOME/Archive \
 --enable-ccache"

##############################################

echo "
  _______                     _____              _     _         _
 |__   __|                   |  __ \            | |   | |       | |
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/

"

##############################################

# config.guess generates different answers for some packages
# Ensure that all packages use the same host by explicitly specifying it.

# First obtain the triplet
AM_VER=`automake --version | awk '{print $NF}' | grep -oEm1 "^[0-9]+.[0-9]+"`
host_alias=`/usr/share/automake-${AM_VER}/config.guess`

# Then undo Suse specific modifications, no harm to other distribution
case `echo ${host_alias} | cut -d '-' -f 1` in
	i?86) VENDOR=pc ;;
	*   ) VENDOR=unknown ;;
esac
host_alias=`echo ${host_alias} | sed -e "s/suse/${VENDOR}/"`

# And add it to the config parameters.
CONFIGPARAM="${CONFIGPARAM} --host=${host_alias} --build=${host_alias}"

##############################################

echo "Targets:"
echo " 1) Kathrein UFS-910"
echo " 3) Kathrein UFS-912"
echo " 4) Kathrein UFS-922"
echo " 5) Topfield 7700 HDPVR"
echo " 6) Fortis based (HDBOX)"
echo " 7) SpiderBox HL-101"
echo " 8) Edision Argus vip"
echo " 9) Cuberevo (IPBOX 9000)"
echo "10) Cuberevo mini (IPBOX 900)"
echo "11) Cuberevo mini2 (IPBOX 910)"
echo "12) Cuberevo 250 (IPBOX 91)"
echo "13) Cuberevo 9500HD (7000HD)"
echo "14) Cuberevo 2000HD"
echo "15) Cuberevo mini_fta (200HD)"
echo "16) Homecast 5101"
echo "17) Octagon 1008"
echo "18) SPARK"
echo "19) Atevio7500"
echo "20) SPARK7162"
echo "21) IPBOX9900"
echo "22) IPBOX99"
echo "23) IPBOX55"
echo "24) Fortis HS7810A"
echo "25) B4Team ADB 5800S"
echo "26) Fortis HS7110"
echo "27) Atemio520"
echo "28) Kathrein UFS-913"
echo "29) Kathrein UFC-960"
echo "30) Vitamin HD5000"
echo "31) Atemio530"

case $1 in
	[1-9] | 1[0-9] | 2[0-9]) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-31)? ";;
esac

case "$REPLY" in
	 1) TARGET="--enable-ufs910";BOXTYPE="--with-boxtype=ufs910";;
	 3) TARGET="--enable-ufs912";BOXTYPE="--with-boxtype=ufs912";;
	 4) TARGET="--enable-ufs922";BOXTYPE="--with-boxtype=ufs922";;
	 5) TARGET="--enable-tf7700";BOXTYPE="--with-boxtype=tf7700";;
	 6) TARGET="--enable-fortis_hdbox";BOXTYPE="--with-boxtype=fortis_hdbox";;
	 7) TARGET="--enable-hl101";BOXTYPE="--with-boxtype=hl101";;
	 8) TARGET="--enable-vip";BOXTYPE="--with-boxtype=vip";;
	 9) TARGET="--enable-cuberevo";BOXTYPE="--with-boxtype=cuberevo";;
	10) TARGET="--enable-cuberevo_mini";BOXTYPE="--with-boxtype=cuberevo_mini";;
	11) TARGET="--enable-cuberevo_mini2";BOXTYPE="--with-boxtype=cuberevo_mini2";;
	12) TARGET="--enable-cuberevo_250hd";BOXTYPE="--with-boxtype=cuberevo_250hd";;
	13) TARGET="--enable-cuberevo_9500hd";BOXTYPE="--with-boxtype=cuberevo_9500hd";;
	14) TARGET="--enable-cuberevo_2000hd";BOXTYPE="--with-boxtype=cuberevo_2000hd";;
	15) TARGET="--enable-cuberevo_mini_fta";BOXTYPE="--with-boxtype=cuberevo_mini_fta";;
	16) TARGET="--enable-homecast5101";BOXTYPE="--with-boxtype=homecast5101";;
	17) TARGET="--enable-octagon1008";BOXTYPE="--with-boxtype=octagon1008";;
	18) TARGET="--enable-spark";BOXTYPE="--with-boxtype=spark";;
	19) TARGET="--enable-atevio7500";BOXTYPE="--with-boxtype=atevio7500";;
	20) TARGET="--enable-spark7162";BOXTYPE="--with-boxtype=spark7162";;
	21) TARGET="--enable-ipbox9900";BOXTYPE="--with-boxtype=ipbox9900";;
	22) TARGET="--enable-ipbox99";BOXTYPE="--with-boxtype=ipbox99";;
	23) TARGET="--enable-ipbox55";BOXTYPE="--with-boxtype=ipbox55";;
	24) TARGET="--enable-hs7810a";BOXTYPE="--with-boxtype=hs7810a";;
	25) TARGET="--enable-adb_box";BOXTYPE="--with-boxtype=adb_box";;
	26) TARGET="--enable-hs7110";BOXTYPE="--with-boxtype=hs7110";;
	27) TARGET="--enable-atemio520";BOXTYPE="--with-boxtype=atemio520";;
	28) TARGET="--enable-ufs913";BOXTYPE="--with-boxtype=ufs913";;
	29) TARGET="--enable-ufc960";BOXTYPE="--with-boxtype=ufc960";;
	30) TARGET="--enable-vitamin_hd5000";BOXTYPE="--with-boxtype=vitamin_hd5000";;
	31) TARGET="--enable-atemio530";BOXTYPE="--with-boxtype=atemio530";;
	 *) TARGET="--enable-atevio7500";BOXTYPE="--with-boxtype=atevio7500";;
esac
CONFIGPARAM="$CONFIGPARAM $TARGET $BOXTYPE"

case "$REPLY" in
	8) REPLY=$3
		echo -e "\nModels:"
		echo " 1) VIP1 v1 [ single tuner + 2 CI + 2 USB ]"
		echo " 2) VIP1 v2 [ single tuner + 2 CI + 1 USB + plug & play tuner (dvb-s2/t/c) ]"
		echo " 3) VIP2 v1 [ twin tuner ]"

		read -p "Select Model (1-3)? "

		case "$REPLY" in
			1) MODEL="--enable-hl101";;
			2) MODEL="--enable-vip1_v2";;
			3) MODEL="--enable-vip2_v1";;
			*) MODEL="--enable-vip2_v1";;
		esac
		CONFIGPARAM="$CONFIGPARAM $MODEL"
		cd ./integrated_firmware
		if [ -L fdma_STx7100_0.elf ]; then
			rm fdma_STx7100_0.elf
		fi
		ln -s fdma2_7100-v3.1.elf fdma_STx7100_0.elf
		cd - &>/dev/null
		;;
	1|5) # for UFS910 and TF7700 the old fdma version
		cd ./integrated_firmware
		if [ -L fdma_STx7100_0.elf ]; then
			rm fdma_STx7100_0.elf
		fi
		ln -s fdma2_7100-v3.0.elf fdma_STx7100_0.elf
		cd - &>/dev/null
		;;
	*)
		cd ./integrated_firmware
		if [ -L fdma_STx7100_0.elf ]; then
			rm fdma_STx7100_0.elf
		fi
		ln -s fdma2_7100-v3.1.elf fdma_STx7100_0.elf
		cd - &>/dev/null
		;;
esac

##############################################

echo -e "\nKernel:"
echo "   1) STM 24 P0207"
echo "   2) STM 24 P0211 (recommended)"
echo "   3) STM 24 P0214 (experimental)"
echo "   4) STM 24 P0215 (experimental)"
case $2 in
	[1-4]) REPLY=$2
	echo -e "\nSelected kernel: $REPLY\n"
	;;
	*)
	read -p "Select kernel (1-4)? ";;
esac

case "$REPLY" in
	1)  KERNEL="--enable-stm24 --enable-p0207";STMFB="stm24";;
	2)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
	3)  KERNEL="--enable-stm24 --enable-p0214";STMFB="stm24";;
	4)  KERNEL="--enable-stm24 --enable-p0215";STMFB="stm24";;
	*)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
esac
CONFIGPARAM="$CONFIGPARAM $KERNEL"

##############################################

echo -e "\nKernel debug:"
if [ "$3" ]; then
	REPLY="$3"
	echo "Activate debug (y/N)? "
	echo -e "\nSelected option: $REPLY\n"
else
	REPLY=N
	read -p "Activate debug (y/N)? "
fi
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"

##############################################

cd ../driver/
echo "# Automatically generated config: don't edit" > .config
echo "#" >> .config
echo "export CONFIG_ZD1211REV_B=y" >> .config
echo "export CONFIG_ZD1211=n" >> .config
cd - &>/dev/null

##############################################

echo -e "\nPlayer:"
echo "   1) Player 191 (stmfb-3.1_stm24_0102)"
echo "   2) Player 191 (stmfb-3.1_stm24_0104, recommended)"
case $4 in
	[1-2]) REPLY=$4
	echo -e "\nSelected player: $REPLY\n"
	;;
	*)
	read -p "Select player (1-2)? ";;
esac

case "$REPLY" in
	1) PLAYER="--enable-player191 --enable-multicom324"
		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi

		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0102 stmfb
		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s player2_191 player2
		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_PLAYER_191=y" >> .config
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0102 stmfb
		cd - &>/dev/null
	;;
	2) PLAYER="--enable-player191 --enable-multicom324"
		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi

		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0104 stmfb
		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s player2_191 player2
		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_PLAYER_191=y" >> .config
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null
	;;
	*) PLAYER="--enable-player191 --enable-multicom324";;
esac

##############################################

echo -e "\nMedia Framework:"
echo "   1) eplayer3"
echo "   2) gstreamer"
echo "   3) use build-in (recommended)"
echo "   4) gstreamer+eplayer3"
case $5 in
	[1-4]) REPLY=$5
	echo -e "\nSelected media framework: $REPLY\n"
	;;
	*)
	read -p "Select media framework (1-4)? ";;
esac

case "$REPLY" in
	1) MEDIAFW="--enable-eplayer3";;
	2) MEDIAFW="--enable-mediafwgstreamer";;
	3) MEDIAFW="--enable-buildinplayer";;
	4) MEDIAFW="--enable-eplayer3 --enable-mediafwgstreamer";;
	*) MEDIAFW="--enable-eplayer3";;
esac

##############################################

echo -e "\nExternal LCD support:"
echo "   1) No external LCD"
echo "   2) graphlcd for external LCD"
case $6 in
	[1-2]) REPLY=$6
	echo -e "\nSelected LCD support: $REPLY\n"
	;;
	*)
	read -p "Select external LCD support (1-2)? ";;
esac

case "$REPLY" in
	1) EXTERNAL_LCD="";;
	2) EXTERNAL_LCD="--enable-externallcd";;
	*) EXTERNAL_LCD="--enable-externallcd";;
esac

##############################################

# Check this option if you want to use the version of GCC.
#CONFIGPARAM="$CONFIGPARAM --enable-gcc47"

##############################################

CONFIGPARAM="$CONFIGPARAM $PLAYER $MULTICOM $MEDIAFW $EXTERNAL_LCD"

##############################################

echo && \
echo "Performing autogen.sh..." && \
echo "------------------------" && \
./autogen.sh && \
echo && \
echo "Performing configure..." && \
echo "-----------------------" && \
echo && \
./configure $CONFIGPARAM

##############################################

echo $CONFIGPARAM >lastChoice
echo " "
echo "----------------------------------------"
echo "Your build enivroment is ready :-)"
echo "Your next step could be:"
echo "----------------------------------------"
echo "make yaud-neutrino"
echo "make yaud-neutrino-mp"
echo "make yaud-neutrino-mp-next"
echo "make yaud-neutrino-hd2-exp"
echo "make yaud-enigma2-pli-nightly"
echo "----------------------------------------"
