URL3=ftp://ftp.stlinux.com/pub/stlinux/2.3/STLinux/sh4
URL3U=ftp://ftp.stlinux.com/pub/stlinux/2.3/updates/RPMS/sh4
URL4=ftp://ftp.stlinux.com/pub/stlinux/2.4/STLinux/sh4
URL4U=ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/RPMS/sh4

URL3S=ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS
URL3SU=ftp://ftp.stlinux.com/pub/stlinux/2.3/updates/SRPMS
URL4S=ftp://ftp.stlinux.com/pub/stlinux/2.4/SRPMS
URL4SU=ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS

$(archivedir)/stlinux23-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3)/$(notdir $@) || $(WGET) $(URL3U)/$(notdir $@)) || true
$(archivedir)/stlinux24-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4)/$(notdir $@) || $(WGET) $(URL4U)/$(notdir $@)) || true

$(archivedir)/stlinux23-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true

$(archivedir)/stlinux23-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true

$(archivedir)/stlinux23-target-%.src.rpm:
	[ ! -f $(archivedir)/$@ ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-target-%.src.rpm:
	[ ! -f $(archivedir)/$@ ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true

################################

$(archivedir)/lcd4linux.svn:
	false || mkdir -p $(archivedir) && ( \
	svn co -r$(LCD4LINUX_SVN) https://ssl.bulix.org/svn/lcd4linux/trunk $(archivedir)/lcd4linux.svn || \
	false )
	@touch $@

$(archivedir)/xupnpd.svn:
	false || mkdir -p $(archivedir) && ( \
	svn co http://tsdemuxer.googlecode.com/svn/trunk/xupnpd/src $(archivedir)/xupnpd.svn || \
	false )
	@touch $@


