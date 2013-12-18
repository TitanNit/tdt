#!/bin/bash
if [ `id -u` != 0 ]; then
	echo "You are not running this script as root. Try it again as root or with su/sudo command."
	echo "Bye Bye..."
	exit
fi

CURDIR=`pwd`
BASEDIR=$CURDIR/../..

TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk

SCRIPTDIR=$CURDIR/scripts
TMPDIR=$CURDIR/tmp
TMPROOTDIR=$TMPDIR/ROOT
TMPKERNELDIR=$TMPDIR/KERNEL
TMPFWDIR=$TMPDIR/FW

OUTDIR=$CURDIR/out

if [ -e $TMPDIR ]; then
	rm -rf $TMPDIR/*
fi

mkdir -p $TMPDIR
mkdir -p $TMPROOTDIR
mkdir -p $TMPKERNELDIR
mkdir -p $TMPFWDIR

echo "This script creates flashable images for Kathrein UFS912"
echo "Author: Schischu, BPanther"
echo "Date: 05-05-2013"
echo "-----------------------------------------------------------------------"
echo "It's expected that an image was already build prior to this execution!"
echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found targets:"
if [  -e $TUFSBOXDIR/release ]; then
	echo "Preparing Enigma2..."
	$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR
fi
if [  -e $TUFSBOXDIR/release_neutrino ]; then
	echo "Preparing Neutrino..."
	$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release_neutrino $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR
fi
echo "Root prepared"
echo "Checking if flashtool mup exists..."
if [ ! -e $CURDIR/mup ]; then
  echo "Flashtool mup is missing, trying to compile it..."
  cd $CURDIR/../common/mup.src
  $CURDIR/../common/mup.src/compile.sh
  mv $CURDIR/../common/mup.src/mup $CURDIR/mup
  cd $CURDIR
  if [ ! -e $CURDIR/mup ]; then
    echo "Compiling failed! Exiting..."
    exit 3
  else
    echo "Compiling successfull"
  fi
fi
echo "Flashtool mup exists"
echo "-----------------------------------------------------------------------"
#echo "Checking targets..."
#echo "Found flashtarget:"
#echo "   1) KERNEL with ROOT"
#echo "   2) KERNEL with ROOT and FW"
#echo "   3) KERNEL"
#echo "   4) FW"
#read -p "Select flashtarget (1-4)? "
echo "Creating flash image..."
REPLY=2
case "$REPLY" in
	1)  echo "Creating KERNEL with ROOT..."
		$SCRIPTDIR/flash_part_wo_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPROOTDIR;;
	2)  echo "Creating KERNEL with ROOT and FW..."
		$SCRIPTDIR/flash_part_w_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPFWDIR $TMPROOTDIR;;
	3)  echo "Creating KERNEL..."
		$SCRIPTDIR/flash_part_kernel.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR;;
	4)  echo "Creating FW..."
		$SCRIPTDIR/flash_part_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 3;;
esac
#clear
echo "-----------------------------------------------------------------------"
AUDIOELFSIZE=`stat -c %s $TMPFWDIR/audio.elf`
if [ "$AUDIOELFSIZE" == "0" -o "$AUDIOELFSIZE" == "" ]; then
  echo -e "\033[01;31m"
  echo "!!! WARNING: AUDIOELF SIZE IS ZERO OR MISSING !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo  "-----------------------------------------------------------------------"
  echo -e "\033[00m"
fi
VIDEOELFSIZE=`stat -c %s $TMPFWDIR/video.elf`
if [ "$VIDEOELFSIZE" == "0" -o "$VIDEOELFSIZE" == "" ]; then
  echo -e "\033[01;31m"
  echo "!!! WARNING: VIDEOELF SIZE IS ZERO OR MISSING !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo  "-----------------------------------------------------------------------"
  echo -e "\033[00m"
fi
if [ ! -e $TMPROOTDIR/dev/mtd0 ]; then
  echo -e "\033[01;31m"
  echo "!!! WARNING: DEVS ARE MISSING !!!"
  echo "IF YOUR ARE CREATING THE ROOT PART MAKE SURE THAT YOU USE A CORRECT DEV.TAR"
  echo "-----------------------------------------------------------------------"
  echo -e "\033[00m"
fi

echo ""
echo ""
echo ""
echo "-----------------------------------------------------------------------"
echo "Flashimage created:"
ls -o $OUTDIR | awk -F " " '{print $7}'

echo "-----------------------------------------------------------------------"
echo "To flash the created image copy the *.img file to"
echo "your usb drive in the subfolder /kathrein/ufs912/"
echo ""
echo "Remember, if this is the first time you flash Enigma2 or Neutrino,"
echo "you will need to flash the updatescript.sh first."
echo "The script can be found in the extras folder, copy it to /kathrein/ufs912/ on your usb drive."
