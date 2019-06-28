#!/bin/bash
# SCRIPT: compare_serv_info.sh
# AUTHOR: Sam Chen
# DATE: 1/12/2012
# REV: 1.1
# PLATFORM: Redhat Linux5.x /Solaris 10
# PURPOSE: This script is to compare the output of requested info with wanted system information on real server and generate comparison result.
#
# USAGE: ./compare_serv_info.sh
# Note:  It can compare Memory, IP address and NFS info and print OS information.
#        It cannot compare CPU info and NFS mount option.




case $(uname) in
Linux)

grep "$(hostname)" output.txt | while read LINE
do
key=$(echo $LINE | awk '{print $1}')
case $key in
OS_type)
osvalue=$(echo $LINE | awk '{print $3,$4,$5,$6,$7}')
ostype=$(/usr/bin/lsb_release -a | grep "Description" | awk -F ":" '{print $2}')
echo "required OS Type is: $osvalue" > output.txt
echo "Real OS Type is: $ostype" >> output.txt
 ;;
Memory)
memvalue=$(echo $LINE | awk '{print $3}')
memsize=$(($(/usr/bin/free -m | grep Mem: | awk '{print $2}')/1000))
if [ "$memvalue" == "$memsize" ]
then echo "$LINE ---> memory pass" >> output.txt
else echo "$LINE ---> memory fail" >> output.txt
fi
 ;;
NFS)
mountpoint=$(echo $LINE | awk '{print $6}')
mountvalue=$(echo $LINE | awk '{print $3,$4,$5,$6}' | tr -d ' ')
filername=$(mount | grep $mountpoint | awk -F ":" '{print $1}')
nfssize=$(df -h $mountpoint | grep $mountpoint | awk '{print $1}')
volume=$(mount | grep $mountpoint | awk -F ":" '{print $2}' | awk '{print $1,$3}')
nfsinfo=$(echo "$filername ${nfssize%M} $volume" | tr -d ' ')
if [ "$mountvalue" == "$nfsinfo" ]
then echo "$LINE ---> nfsinfo pass" >> output.txt
else echo "$LINE ---> nfsinfo fail" >> output.txt
fi
  ;;
Interface)
nic=$(echo $LINE | awk '{print $3}')
nicvalue=$(echo $LINE | awk '{print $4,$5,$6}')
ipinfo=$(ifconfig $nic | grep Bcast | awk -F ":" '{print $2,$3,$4}' | awk '{print $1,$5,$3}')
if [ "$nicvalue" == "$ipinfo" ]
then echo "$LINE ---> ipinfo pass" >> output.txt
else echo "$LINE ---> ipinfo fail" >> output.txt
fi
;;
esac
done
;;

SunOS)
grep "$(hostname)" output.txt | while read LINE
do
key=$(echo $LINE | awk '{print $1}')
case $key in
OS_type)
osvalue=$(echo $LINE | awk '{print $3,$4}')
ostype=$(/usr/bin/uname -a | awk '{print $1,$3}')
echo "required OS Type is: $osvalue" > output.txt
echo "Real OS Type is: $ostype" >> output.txt
 ;;
Memory)
memvalue=$(echo $LINE | awk '{print $3}')
memsize=$(($(prtconf | grep "Mem" | awk '{print $3}')/1024))
if [ "$memvalue" == "$memsize" ]
then echo "$LINE ---> memory pass" >> output.txt
else echo "$LINE ---> memory fail" >> output.txt
fi
 ;;
NFS)
mountpoint=$(echo $LINE | awk '{print $6}')
mountvalue=$(echo $LINE | awk '{print $3,$4,$5,$6}' | tr -d ' ')
filername=$(mount | grep $mountpoint | awk -F ":" '{print $1}' | awk '{print $3}')
nfssize=$(df -h $mountpoint | grep $mountpoint | awk '{print $1}')
volume=$(mount | grep $mountpoint | awk '{print $1,$3}' | awk -F ":" '{print $1,$2}' | awk '{print $3,$1}')
nfsinfo=$(echo "$filername ${nfssize%M} $volume" | tr -d ' ')
if [ "$mountvalue" == "$nfsinfo" ]
then echo "$LINE ---> nfsinfo pass" >> output.txt
else echo "$LINE ---> nfsinfo fail" >> output.txt
fi
  ;;
Interface)
nic=$(echo $LINE | awk '{print $3}')
nicvalue=$(echo $LINE | awk '{print $4}')
ipinfo=$(ifconfig $nic | grep inet | awk '{print $2}')
if [ "$nicvalue" == "$ipinfo" ]
then echo "$LINE ---> ipinfo pass" >> output.txt
else echo "$LINE ---> ipinfo fail" >> output.txt
fi
;;
esac
done
;;
*)

;;
esac