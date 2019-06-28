#!/bin/bash
exec > $(hostname).txt 2>&1
echo "==============================================="
echo "Host name:  " `hostname`
echo "IP address infomation"
ifconfig
echo "OS version and kernel"
cat /etc/redhat-release
echo "Kernel version: " `uname -sr`
echo "syslog version"
rpm -qa |grep -E 'syslog|sysklogd'
echo "============Hardware specifications============"
echo "Server Model SN#"
dmidecode |grep -A5 "System Information"
echo 
echo "Processor information"
cat /proc/cpuinfo
echo
echo "Memory information"
dmidecode |grep -A6 "Physical Memory Array"
dmidecode |grep -A11 "Memory Device\$"
echo "Ethernet network port"
dmidecode |grep -A2 "Type: Ethernet"
echo "============Resource utilization==============="
top -bn1 |head -n 5
echo
echo "Disk partition"
echo
fdisk -l
echo
echo "PV infomation"
echo
pvs
echo
echo "VG infomation"
echo
vgs
echo
echo "LV infomation"
echo
lvs
echo
echo "Disk utilization"
echo
df -h
echo "================================================"

