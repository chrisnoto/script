#!/bin/bash

# ensure script is being run as root
if [ `whoami` != root ]; then
   echo "ERROR: This script must be run as root" 1>&2
   exit 1
fi

# check for image name
if [ $# != 3 ]; then
        echo "Usage: ./centoskvm.sh srvname(imagename) ipaddr disksize(G)"
	exit 1
fi

# name of the image/vm name, ip address and disk size
IMGNAME=$1
IPADDR=$2
SIZE=$3
# default kickstart file   kickstarts/$KICKSTART
[ -d kickstarts ] || mkdir kickstarts
KICKSTART="mycentos6x.cfg"

#customise the image/hostname and ip address in kickstart file
cat <<- EOF > ./kickstarts/$KICKSTART
install
url --url http://192.168.122.32/centos6.5
lang en_US.UTF-8
keyboard us
network --device eth0 --bootproto static --ip=$IPADDR --netmask=255.255.255.0 --gateway=192.168.122.1 --nameserver=192.168.122.1 --noipv6 --onboot yes --hostname=$IMGNAME
rootpw  changeme
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Asia/Shanghai
bootloader --location=mbr --driveorder=vda --append="crashkernel=auto rhgb quiet"
zerombr
clearpart --all
ignoredisk --only-use=vda
part /boot --fstype ext3 --size=400
part swap --size=2048
part pv.01 --size=1 --grow
volgroup myvg pv.01
logvol / --vgname=myvg --size=6000 --name=lv_root
logvol /var --vgname=myvg --size=5000 --name=lv_var
logvol /opt --vgname=myvg --size=4000 --name=lv_opt
%packages
@base
@console-internet
@core
@debugging
@basic-desktop
@development
@directory-client
@hardware-monitoring
@java-platform
@large-systems
@network-file-system-client
@performance
@perl-runtime
@server-platform
@server-policy
@system-admin-tools
@workstation-policy
mtools
pax
oddjob
sgpio
device-mapper-persistent-data
systemtap-client
jpackage-utils
samba-winbind
certmonger
pam_krb5
krb5-workstation
perl-DBD-SQLite

EOF



echo "Generating VM ..."

# create image file
virt-install \
--connect=qemu:///system \
--virt-type kvm \
--network network=default \
--name $IMGNAME \
--ram 1024 \
--disk path=/var/lib/libvirt/images/$IMGNAME.img,size=$SIZE \
--vcpus 1 \
--nographics \
--os-type=linux \
--os-variant=rhel6 \
--location=http://192.168.122.32/centos6.5 \
--initrd-inject=kickstarts/$KICKSTART \
--extra-args="ks=file:/$KICKSTART text console=tty0 utf8 console=ttyS0,115200" \
--force \
--noreboot \
--hvm \
--accelerate 

echo "VM created!!"

