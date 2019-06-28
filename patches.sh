#!/bin/bash
sudo mkdir -p /var/spool/apars/`date +%Y%m%d`/
sudo touch /var/spool/apars/`date +%Y%m%d`/CH3773
rpm -qa --qf '%{epoch}:%{name}-%{version}-%{release}.%{arch} \n' |sudo tee /var/spool/apars/`date +%Y%m%d`/pre_pkg_info.`date +%Y%m%d`


##post
#rpm -qa --qf '%{epoch}:%{name}-%{version}-%{release}.%{arch} \n' |sudo tee /var/spool/apars/`date +%Y%m%d`/post_pkg_info.`date +%Y%m%d`
