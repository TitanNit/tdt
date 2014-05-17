AC_DEFUN([TUXBOX_RULES_MAKE],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
INSTALL_$1=`${srcdir}/rules.pl install ${srcdir}/rules-install $1`
DISTCLEANUP_$1="rm -rf $DIR_$1"
DISTCLEANUP="$DISTCLEANUP $DIR_$1"
DEPSCLEANUP_$1="rm .deps/$1"
DEPSCLEANUP="$DEPSCLEANUP .deps/$1"
LIST_CLEAN="$LIST_CLEAN $1-clean"
AC_SUBST(DEPENDS_$1)dnl
AC_SUBST(DIR_$1)dnl
AC_SUBST(PREPARE_$1)dnl
AC_SUBST(VERSION_$1)dnl
AC_SUBST(INSTALL_$1)dnl
AC_SUBST(DISTCLEANUP_$1)dnl
AC_SUBST(DEPSCLEANUP_$1)dnl
AC_SUBST(DEPSCLEANUP)dnl
AC_SUBST(LIST_CLEAN)dnl
AC_MSG_RESULT(done)
])

AC_DEFUN([TUXBOX_RULES_MAKE_EXDIR],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
SOURCEDIR_$1=$DIR_$1
CONFIGURE_$1="../$DIR_$1/configure"
PREPARE_$1="$PREPARE_$1 && ( rm -rf build_$1 || /bin/true ) && mkdir build_$1"
INSTALL_$1=`${srcdir}/rules.pl install ${srcdir}/rules-install $1`
CLEANUP_$1="rm -rf $DIR_$1 build_$1"
CLEANUP="$CLEANUP $DIR_$1"
DIR_$1="build_$1"
AC_SUBST(CLEANUP_$1)dnl
AC_SUBST(CONFIGURE_$1)dnl
AC_SUBST(DEPENDS_$1)dnl
AC_SUBST(DIR_$1)dnl
AC_SUBST(INSTALL_$1)dnl
AC_SUBST(PREPARE_$1)dnl
AC_SUBST(SOURCEDIR_$1)dnl
AC_SUBST(VERSION_$1)dnl
AC_MSG_RESULT(done)
])

AC_DEFUN([TUXBOX_RULES_MAKE_RPM],[
AC_MSG_CHECKING([$1 rules])
eval `${srcdir}/rules.pl make ${srcdir}/rules-make $1 cdkoutput`
RPMDEPSCLEANUP_$1="rm .deps/$1"
RPMDEPSCLEANUP="$RPMDEPSCLEANUP .deps/$1"
RPMLIST_CLEAN="$RPMLIST_CLEAN $1-clean"
RPMDISTCLEANUP_$1="rm -rf $DIR_$1"
RPMDEPSDISTCLEANUP_$1="rm .deps/$1 .deps/$1.do_compile .deps/$1.do_prepare"
RPMLIST_DISTCLEAN="$RPMLIST_DISTCLEAN $1-distclean"
AC_SUBST(DIR_$1)dnl
AC_SUBST(RPMDEPSCLEANUP_$1)dnl
AC_SUBST(RPMDEPSCLEANUP)dnl
AC_SUBST(RPMLIST_CLEAN)dnl
AC_SUBST(RPMDISTCLEANUP_$1)dnl
AC_SUBST(RPMDEPSDISTCLEANUP_$1)dnl
AC_SUBST(RPMLIST_DISTCLEAN)dnl
AC_MSG_RESULT(done)
])

AC_DEFUN([TUXBOX_BOXTYPE],[

CPU_ARCH="sh4"
target_alias="sh4-linux"

AC_ARG_WITH(boxtype,
	[  --with-boxtype    valid values: ufs910, ufs912, ufs913, ufs922, ufc960
                             valid values: ipbox55, ipbox99, ipbox9900, cuberevo, cuberevo_mini, cuberevo_mini2, cuberevo_mini_fta, cuberevo_250hd, cuberevo_2000hd, cuberevo_9500hd
                             valid values: tf7700, fortis_hdbox, octagon1008, atevio7500, spark, spark7162, hl101, hs7110, hs7810a, adb_box, atemio520, atemio530, vip, homecast5101
                             valid values: vitamin_hd5000, sagemcom88],
	[case "${withval}" in
dnl		To-Do: extend CPU types and kernel versions when needed
		ufs910)
			BOXTYPE="$withval"
			;;
		ufs912)
			BOXTYPE="$withval"
			;;
		ufs913)
			BOXTYPE="$withval"
			;;
		ufs922)
			BOXTYPE="$withval"
			;;
		ufc960)
			BOXTYPE="$withval"
			;;
		ipbox55)
			BOXTYPE="$withval"
			;;
		ipbox99)
			BOXTYPE="$withval"
			;;
		ipbox9900)
			BOXTYPE="$withval"
			;;
		cuberevo)
			BOXTYPE="$withval"
			;;
		cuberevo_mini)
			BOXTYPE="$withval"
			;;
		cuberevo_mini2)
			BOXTYPE="$withval"
			;;
		cuberevo_mini_fta)
			BOXTYPE="$withval"
			;;
		cuberevo_250hd)
			BOXTYPE="$withval"
			;;
		cuberevo_2000hd)
			BOXTYPE="$withval"
			;;
		cuberevo_9500hd)
			BOXTYPE="$withval"
			;;
		tf7700)
			BOXTYPE="$withval"
			;;
		fortis_hdbox)
			BOXTYPE="$withval"
			;;
		octagon1008)
			BOXTYPE="$withval"
			;;
		atevio7500)
			BOXTYPE="$withval"
			;;
		spark)
			BOXTYPE="$withval"
			;;
		spark7162)
			BOXTYPE="$withval"
			;;
		hl101)
			BOXTYPE="$withval"
			;;
		hs7110)
			BOXTYPE="$withval"
			;;
		hs7810a)
			BOXTYPE="$withval"
			;;
		adb_box)
			BOXTYPE="$withval"
			;;
		vip)
			BOXTYPE="$withval"
			;;
		atemio520)
			BOXTYPE="$withval"
			;;
		atemio530)
			BOXTYPE="$withval"
			;;
		homecast5101)
			BOXTYPE="$withval"
			;;
		vitamin_hd5000)
			BOXTYPE="$withval"
			;;
		sagemcom88)
			BOXTYPE="$withval"
			;;
		*)
			AC_MSG_ERROR([bad value $withval for --with-boxtype]) ;;
	esac], [BOXTYPE="ufs912"])

AC_SUBST(BOXTYPE)
AC_SUBST(CPU_ARCH)

AM_CONDITIONAL(BOXTYPE_UFS910, test "$BOXTYPE" = "ufs910")
AM_CONDITIONAL(BOXTYPE_UFS912, test "$BOXTYPE" = "ufs912")
AM_CONDITIONAL(BOXTYPE_UFS913, test "$BOXTYPE" = "ufs913")
AM_CONDITIONAL(BOXTYPE_UFS922, test "$BOXTYPE" = "ufs922")
AM_CONDITIONAL(BOXTYPE_UFC960, test "$BOXTYPE" = "ufc960")
AM_CONDITIONAL(BOXTYPE_IPBOX55, test "$BOXTYPE" = "ipbox55")
AM_CONDITIONAL(BOXTYPE_IPBOX99, test "$BOXTYPE" = "ipbox99")
AM_CONDITIONAL(BOXTYPE_IPBOX9900, test "$BOXTYPE" = "ipbox9900")
AM_CONDITIONAL(BOXTYPE_CUBEREVO, test "$BOXTYPE" = "cuberevo")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_MINI, test "$BOXTYPE" = "cuberevo_mini")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_MINI2, test "$BOXTYPE" = "cuberevo_mini2")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_MINI_FTA, test "$BOXTYPE" = "cuberevo_mini_fta")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_250HD, test "$BOXTYPE" = "cuberevo_250hd")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_2000HD, test "$BOXTYPE" = "cuberevo_2000hd")
AM_CONDITIONAL(BOXTYPE_CUBEREVO_9500HD, test "$BOXTYPE" = "cuberevo_9500hd")
AM_CONDITIONAL(BOXTYPE_TF7700, test "$BOXTYPE" = "tf7700")
AM_CONDITIONAL(BOXTYPE_FORTIS_HDBOX, test "$BOXTYPE" = "fortis_hdbox")
AM_CONDITIONAL(BOXTYPE_OCTAGON1008, test "$BOXTYPE" = "octagon1008")
AM_CONDITIONAL(BOXTYPE_ATEVIO7500, test "$BOXTYPE" = "atevio7500")
AM_CONDITIONAL(BOXTYPE_SPARK, test "$BOXTYPE" = "spark")
AM_CONDITIONAL(BOXTYPE_SPARK7162, test "$BOXTYPE" = "spark7162")
AM_CONDITIONAL(BOXTYPE_HL101, test "$BOXTYPE" = "hl101")
AM_CONDITIONAL(BOXTYPE_HS7110, test "$BOXTYPE" = "hs7110")
AM_CONDITIONAL(BOXTYPE_HS7810A, test "$BOXTYPE" = "hs7810a")
AM_CONDITIONAL(BOXTYPE_ADB_BOX, test "$BOXTYPE" = "adb_box")
AM_CONDITIONAL(BOXTYPE_ATEMIO520, test "$BOXTYPE" = "atemio520")
AM_CONDITIONAL(BOXTYPE_ATEMIO530, test "$BOXTYPE" = "atemio530")
AM_CONDITIONAL(BOXTYPE_VIP, test "$BOXTYPE" = "vip")
AM_CONDITIONAL(BOXTYPE_HOMECAST5101, test "$BOXTYPE" = "homecast5101")
AM_CONDITIONAL(BOXTYPE_VITAMIN_HD5000, test "$BOXTYPE" = "vitamin_hd5000")
AM_CONDITIONAL(BOXTYPE_SAGEMCOM88, test "$BOXTYPE" = "sagemcom88")

if test "$BOXTYPE" = "ufs910"; then
	AC_DEFINE(HAVE_UFS910_HARDWARE, 1, [building for a ufs910])
elif test "$BOXTYPE" = "ufs912"; then
	AC_DEFINE(HAVE_UFS912_HARDWARE, 1, [building for a ufs912])
elif test "$BOXTYPE" = "ufs913"; then
	AC_DEFINE(HAVE_UFS913_HARDWARE, 1, [building for a ufs913])
elif test "$BOXTYPE" = "ufs922"; then
	AC_DEFINE(HAVE_UFS922_HARDWARE, 1, [building for an ufs922])
elif test "$BOXTYPE" = "ufc960"; then
	AC_DEFINE(HAVE_UFC960_HARDWARE, 1, [building for an ufc960])
elif test "$BOXTYPE" = "ipbox55"; then
	AC_DEFINE(HAVE_IPBOX55_HARDWARE, 1, [building for a ipbox55])
elif test "$BOXTYPE" = "ipbox99"; then
	AC_DEFINE(HAVE_IPBOX99_HARDWARE, 1, [building for a ipbox99])
elif test "$BOXTYPE" = "ipbox9900"; then
	AC_DEFINE(HAVE_IPBOX9900_HARDWARE, 1, [building for a ipbox9900])
elif test "$BOXTYPE" = "cuberevo"; then
	AC_DEFINE(HAVE_CUBEREVO_HARDWARE, 1, [building for a cuberevo])
elif test "$BOXTYPE" = "cuberevo_mini"; then
	AC_DEFINE(HAVE_CUBEREVO_MINI_HARDWARE, 1, [building for an cuberevo_mini])
elif test "$BOXTYPE" = "cuberevo_mini2"; then
	AC_DEFINE(HAVE_CUBEREVO_MINI2_HARDWARE, 1, [building for a cuberevo_mini2])
elif test "$BOXTYPE" = "cuberevo_mini_fta"; then
	AC_DEFINE(HAVE_CUBEREVO_MINI_FTA_HARDWARE, 1, [building for a cuberevo_mini_fta])
elif test "$BOXTYPE" = "cuberevo_250hd"; then
	AC_DEFINE(HAVE_CUBEREVO_250HD_HARDWARE, 1, [building for a cuberevo_250hd])
elif test "$BOXTYPE" = "cuberevo_2000hd"; then
	AC_DEFINE(HAVE_CUBEREVO_2000HD_HARDWARE, 1, [building for a cuberevo_2000hd])
elif test "$BOXTYPE" = "cuberevo_9500hd"; then
	AC_DEFINE(HAVE_CUBEREVO_9500HD_HARDWARE, 1, [building for an cuberevo_9500hd])
elif test "$BOXTYPE" = "tf7700"; then
	AC_DEFINE(HAVE_TF7700_HARDWARE, 1, [building for a tf7700])
elif test "$BOXTYPE" = "fortis_hdbox"; then
	AC_DEFINE(HAVE_FORTIS_HDBOX_HARDWARE, 1, [building for a fortis_hdbox])
elif test "$BOXTYPE" = "octagon1008"; then
	AC_DEFINE(HAVE_OCTAGON1008_HARDWARE, 1, [building for a octagon1008])
elif test "$BOXTYPE" = "atevio7500"; then
	AC_DEFINE(HAVE_ATEVIO7500_HARDWARE, 1, [building for a atevio7500])
elif test "$BOXTYPE" = "spark"; then
	AC_DEFINE(HAVE_SPARK_HARDWARE, 1, [building for an spark])
elif test "$BOXTYPE" = "spark7162"; then
	AC_DEFINE(HAVE_SPARK7162_HARDWARE, 1, [building for a spark7162])
elif test "$BOXTYPE" = "hl101"; then
	AC_DEFINE(HAVE_HL101_HARDWARE, 1, [building for a hl101])
elif test "$BOXTYPE" = "hs7110"; then
	AC_DEFINE(HAVE_HS7110_HARDWARE, 1, [building for a hs7110])
elif test "$BOXTYPE" = "hs7810a"; then
	AC_DEFINE(HAVE_HS7810A_HARDWARE, 1, [building for a hs7810a])
elif test "$BOXTYPE" = "adb_box"; then
	AC_DEFINE(HAVE_ADB_BOX_HARDWARE, 1, [building for a adb_box])
elif test "$BOXTYPE" = "atemio520"; then
	AC_DEFINE(HAVE_ATEMIO520_HARDWARE, 1, [building for a atemio520])
elif test "$BOXTYPE" = "atemio530"; then
	AC_DEFINE(HAVE_ATEMIO530_HARDWARE, 1, [building for a atemio530])
elif test "$BOXTYPE" = "vip"; then
	AC_DEFINE(HAVE_VIP_HARDWARE, 1, [building for an vip])
elif test "$BOXTYPE" = "homecast5101"; then
	AC_DEFINE(HAVE_HOMECAST5101_HARDWARE, 1, [building for a homecast5101])
elif test "$BOXTYPE" = "vitamin_hd5000"; then
	AC_DEFINE(HAVE_VITAMIN_HD5000_HARDWARE, 1, [building for a vitamin_hd5000])
elif test "$BOXTYPE" = "sagemcom88"; then
	AC_DEFINE(HAVE_SAGEMCOM88_HARDWARE, 1, [building for a sagemcom88])
fi

])
