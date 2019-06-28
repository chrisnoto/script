#!/bin/bash

OStype=`cat /etc/*release`
[ `echo $OStype|grep -ic "red hat"` -gt 0 ] && MODGRP="/usr/bin/gpasswd -d"
[ `echo $OStype|grep -ic "suse"` -gt 0 ] && MODGRP="/usr/sbin/groupmod -R"
ID=`which id`
GROUPDEL="/usr/sbin/groupdel"

exec > "cleanupwheel_"`hostname`_`date +%d%b%Y`.log 2>&1
grep tempwheel /etc/group >/dev/null 2>&1
[ $? -eq 0 ] && echo "Removing group tempwheel" && $GROUPDEL tempwheel

vuser=()
exlist=(root jintaoxu chzhbo szliuysz wuyssz harryz xuhying heyongsz chensen fangang tanlong guiwanc dangcz mattpark gocallag ragnarva)
alluser=`grep "\<wheel\>" /etc/group|cut -d: -f4|sed -e 's/,/ /g'`

for a in ${exlist[@]}
do
alluser=`echo $alluser|sed -e 's/'"$a"'//g'`
done

for u in $alluser
do
$ID $u >/dev/null 2>&1
if [ $? -eq 0 ];then
vuser=("${vuser[@]}" $u)
grp=`grep $u /etc/group|grep chensen|cut -d: -f1`
if [ ${grp}x = "wheelx" ];then
$MODGRP $u wheel
fi
fi
done

for i in ${vuser[@]}
do
$ID $i
done
