#!/bin/bash
# ---------------------------------------------------------------------
#
#                      PROPERTY OF xxx
#                      COPYRIGHT xxx CORP. 2006
#
# ---------------------------------------------------------------------
# Author.............: mckinnon@au1.xxx.com
# Source.............: ~/bin/pre-apar.sh
# Version............: 0.01
# Version hist..v0.01: Moded version of Luke's preapar.sh script
# SYNOPSIS...........: Pre and Post APAR check script
# Purpose............: capture per / post APAR information
# Invocation.........: sudo ~/bin/pre-apar.sh
# ---------------------------------------------------------------------
[ -d /var/spool/apars/`date +%Y%m%d` ] || mkdir -p /var/spool/apars/`date +%Y%m%d`
# ---------------------------------------------------------------------
/usr/local/bin/lssecfixes -p > /var/spool/apars/`date +%Y%m%d`/lssecfixes-post.txt
rpm -qa |sort > /var/spool/apars/`date +%Y%m%d`/rpms-post.txt
/sbin/chkconfig --list > /var/spool/apars/`date +%Y%m%d`/chkconfig-post.txt
find /etc -type f|xargs md5sum > /var/spool/apars/`date +%Y%m%d`/etc-md5sum-post.txt 
#rpm -qaV > /var/spool/apars/`date +%Y%m%d`/rpm-qaV-post.txt
/usr/bin/tonic -c /etc/tonic/tonic.conf -qo ITCS > /var/spool/apars/`date +%Y%m%d`/tonic-post.txt
chmod 640 /var/spool/apars/`date +%Y%m%d`/*
chown root:wheel /var/spool/apars/`date +%Y%m%d`/*
