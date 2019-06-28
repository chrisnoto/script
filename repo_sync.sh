#!/bin/bash
> /root/yumreposync.log
date |tee -a /root/yumreposync.log

#/bin/reposync --repoid=zabbix --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/zabbix

/bin/reposync --repoid=kubernetes --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
/bin/createrepo --update /var/www/html/kubernetes

/bin/reposync --repoid=docker-ce-stable --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
/bin/createrepo --update /var/www/html/docker-ce-stable

#/bin/reposync --repoid=epel --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/epel

#/bin/reposync --repoid=mariadb --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/mariadb

#/bin/reposync --repoid=remi-safe --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/remi-safe

#/bin/reposync --repoid=remi-php70 --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/remi-php70

#/bin/reposync --repoid=remi-php71 --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/remi-php71

#/bin/reposync --repoid=extras --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/extras

#/bin/reposync --repoid=base --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/base

#/bin/reposync --repoid=updates --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/updates

#/bin/reposync --repoid=centos-ceph-jewel --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/centos-ceph-jewel

#/bin/reposync --repoid=centos-openstack-newton --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/centos-openstack-newton

#/bin/reposync --repoid=centos-qemu-ev --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/centos-qemu-ev

#/bin/reposync --repoid=dockerrepo --download_path=/var/www/html -a x86_64 |tee -a /root/yumreposync.log
#/bin/createrepo --update /var/www/html/dockerrepo

