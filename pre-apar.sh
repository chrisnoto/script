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
[ -d /var/spool/apars ] || mkdir -p /var/spool/apars
chmod 755 /var/spool/apars
[ -d /var/spool/apars/`date +%Y%m%d` ] || mkdir -p /var/spool/apars/`date +%Y%m%d`
chmod 755 /var/spool/apars/`date +%Y%m%d`
[ -d /root/.change ] || mkdir -p /root/.change
# ---------------------------------------------------------------------
/usr/local/bin/lssecfixes -p > /var/spool/apars/`date +%Y%m%d`/lssecfixes-pre.txt
rpm -qa |sort > /var/spool/apars/`date +%Y%m%d`/rpms-pre.txt
/sbin/chkconfig --list > /var/spool/apars/`date +%Y%m%d`/chkconfig-pre.txt
find /etc -type f|xargs md5sum > /var/spool/apars/`date +%Y%m%d`/etc-md5sum-pre.txt 
#rpm -qaV > /var/spool/apars/`date +%Y%m%d`/rpm-qaV-pre.txt
/usr/bin/tonic -c /etc/tonic/tonic.conf -qo ITCS > /var/spool/apars/`date +%Y%m%d`/tonic-pre.txt
cd / ; tar cfz /var/spool/apars/`date +%Y%m%d`/etc`date +%Y%m%d`.tar.gz etc
chmod 640 /var/spool/apars/`date +%Y%m%d`/*
chown root:wheel /var/spool/apars/`date +%Y%m%d`/*

if [ -f /etc/sysctl.conf ];then
 cp -p /etc/sysctl.conf /root/.change/sysctl.`date +%Y%m%d`.conf
fi

if [ -f /etc/grub.conf ];then
 cp -p /etc/grub.conf /root/.change/grub.`date +%Y%m%d`.conf
fi

if [ -f /etc/yum.conf ];then
cp -p /etc/yum.conf /root/.change/yum.`date +%Y%m%d`.conf
fi

if [ -f /etc/inittab ];then
cp -p /etc/inittab /root/.change/inittab.`date +%Y%m%d`
fi

if [ -f /etc/fstab ];then
cp -p /etc/fstab /root/.change/fstab.`date +%Y%m%d`
fi
