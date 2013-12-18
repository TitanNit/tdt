#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPKERNELDIR=$4
TMPFWDIR=$5
TMPROOTDIR=$6
TMPEXTDIR=$7

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "TMPFWDIR     = $TMPFWDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"
echo "TMPEXTDIR   = $TMPEXTDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
SUMTOOL=$TUFSBOXDIR/host/bin/sumtool
PAD=$CURDIR/../common/pad
FUP=$CURDIR/fup

HOST=`cat $TMPEXTDIR/etc/hostname`
if [ -d $CURDIR/../../cvs/apps/libstb-hal-exp-next ]; then
	HAL_REV=_HAL-rev`cd $CURDIR/../../cvs/apps/libstb-hal-exp-next && git log | grep "^commit" | wc -l`-exp-next
elif [ -d $CURDIR/../../cvs/apps/libstb-hal-exp ]; then
	HAL_REV=_HAL-rev`cd $CURDIR/../../cvs/apps/libstb-hal-exp && git log | grep "^commit" | wc -l`-exp
else
	HAL_REV=_HAL-rev`cd $CURDIR/../../cvs/apps/libstb-hal && git log | grep "^commit" | wc -l`
fi

if [ -d $CURDIR/../../cvs/apps/neutrino-mp-exp-next ]; then
	NMP_REV=_NMP-rev`cd $CURDIR/../../cvs/apps/neutrino-mp-exp-next && git log | grep "^commit" | wc -l`-exp-next
elif [ -d $CURDIR/../../cvs/apps/neutrino-mp-exp ]; then
	NMP_REV=_NMP-rev`cd $CURDIR/../../cvs/apps/neutrino-mp-exp && git log | grep "^commit" | wc -l`-exp
else
	NMP_REV=_NMP-rev`cd $CURDIR/../../cvs/apps/neutrino-mp && git log | grep "^commit" | wc -l`
fi
gitversion="_BASE-rev`(cd $CURDIR/../../ && git log | grep "^commit" | wc -l)`$HAL_REV$NMP_REV"
OUTFILE=$OUTDIR/update_w_fw.ird
OUTFILE_Z=$OUTDIR/$HOST$gitversion

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
  rm -f $OUTFILE.md5
fi

cp $TMPKERNELDIR/uImage $OUTDIR/uImage.bin

# Create a jffs2 partition for fw's
# Size 6.875  MB = -p0x6E0000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./fw
# ./fw/audio.elf
# ./fw/video.elf
echo "MKFSJFFS2 -qUfv -p0x6E0000 -e0x20000 -r $TMPFWDIR -o $OUTDIR/mtd_fw.bin"
$MKFSJFFS2 -qUfv -p0x6E0000 -e0x20000 -r $TMPFWDIR -o $OUTDIR/mtd_fw.bin > /dev/null
echo "SUMTOOL -v -p -e 0x20000 -i $OUTDIR/mtd_fw.bin -o $OUTDIR/mtd_fw.sum.bin"
$SUMTOOL -v -p -e 0x20000 -i $OUTDIR/mtd_fw.bin -o $OUTDIR/mtd_fw.sum.bin > /dev/null
echo "PAD 0x6E0000 $OUTDIR/mtd_fw.sum.bin $OUTDIR/mtd_fw.sum.pad.bin"
$PAD 0x6E0000 $OUTDIR/mtd_fw.sum.bin $OUTDIR/mtd_fw.sum.pad.bin

# Create a jffs2 partition for ext
# 0x01220000 - 0x01DFFFFF (11.875 MB)
# Should be p0xBE0000 but due to a bug in stock uboot the size had to be decreased
$MKFSJFFS2 -qUfv -p0xBA0000 -e0x20000 -r $TMPEXTDIR -o $OUTDIR/mtd_ext.bin
$SUMTOOL -v -p -e 0x20000 -i $OUTDIR/mtd_ext.bin -o $OUTDIR/mtd_ext.sum.bin
$PAD 0xBA0000 $OUTDIR/mtd_ext.sum.bin $OUTDIR/mtd_ext.sum.pad.bin

# Create a jffs2 partition for root
# Size 30     MB = -p0x1E00000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./release
# ./release/etc
# ./release/usr
echo "MKFSJFFS2 -qUfv -p0x1E00000 -e0x20000 -r $TMPROOTDIR -o $OUTDIR/mtd_root.bin"
$MKFSJFFS2 -qUfv -p0x1E00000 -e0x20000 -r $TMPROOTDIR -o $OUTDIR/mtd_root.bin > /dev/null
echo "SUMTOOL -v -p -e 0x20000 -i $OUTDIR/mtd_root.bin -o $OUTDIR/mtd_root.sum.bin"
$SUMTOOL -v -p -e 0x20000 -i $OUTDIR/mtd_root.bin -o $OUTDIR/mtd_root.sum.bin > /dev/null
echo "PAD 0x1E00000 $OUTDIR/mtd_root.sum.bin $OUTDIR/mtd_root.sum.pad.bin"
$PAD 0x1E00000 $OUTDIR/mtd_root.sum.bin $OUTDIR/mtd_root.sum.pad.bin

# Create a fortis signed update file for fw's
# Note: -g is a workaround which will be removed as soon as the missing conf partition is found
# Note: -e could be used as a extension partition but at the moment we dont use it
echo "FUP -ce $OUTFILE -k $OUTDIR/uImage.bin -f $OUTDIR/mtd_fw.sum.pad.bin -g foo -e foo -r $OUTDIR/mtd_root.sum.pad.bin"
$FUP -ce $OUTFILE -k $OUTDIR/uImage.bin -f $OUTDIR/mtd_fw.sum.pad.bin -r $OUTDIR/mtd_root.sum.pad.bin -g foo -e $OUTDIR/mtd_ext.sum.pad.bin

rm -f $OUTDIR/uImage.bin
rm -f $OUTDIR/mtd_fw.bin
rm -f $OUTDIR/mtd_fw.sum.bin
rm -f $OUTDIR/mtd_fw.sum.pad.bin
rm -f $OUTDIR/mtd_root.bin
rm -f $OUTDIR/mtd_root.sum.bin
rm -f $OUTDIR/mtd_root.sum.pad.bin
rm -f $OUTDIR/mtd_ext.bin
rm -f $OUTDIR/mtd_ext.sum.bin
rm -f $OUTDIR/mtd_ext.sum.pad.bin

md5sum -b $OUTFILE | awk -F' ' '{print $1}' > $OUTFILE.md5
zip -j $OUTFILE_Z.zip $OUTFILE $OUTFILE.md5
rm -f $OUTFILE
rm -f $OUTFILE.md5
