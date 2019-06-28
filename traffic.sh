#!/bin/bash
#ls -1 /sys/class/net|grep br- |xargs -tI{} ifconfig {} |grep 'RX bytes' >/root/traffic.log
for u in `ls -1 /sys/class/net|grep br-`
do
echo -n $u
ifconfig $u |grep 'RX bytes'
done
