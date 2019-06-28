#!/bin/bash
#echo `uname -n`":"`sudo cat /etc/sudoers |grep '='|egrep -vi 'alias|default|^#'|awk '{print $1}'|sort -u|grep -v ALL`|sed 's/ /:/g'
echo `uname -n`
a=`sudo cat /etc/sudoers |grep '='|egrep -vi 'alias|default|^#'|awk '{print $1}'|sort -u|grep -v ALL`
for u in $a
do
echo $u |grep -q '%'
if [ $? -eq 0 ];then
#echo "$u is group"
user=`grep -w ${u##%} /etc/group|awk -F: '{print $NF}'|awk -F',' '{for(i=1;i<=NF;i++){print $i}}'`
echo -n $u
for b in $user
do
echo -n ":"$b":"`grep $b /etc/passwd |awk -F':' '{for(i=1;i<=NF;i++)if($i ~/@/){print $i}}'|awk '{print $NF}'`
done
echo
fi
echo $u |grep -q '[A-Z]\+$'
if [ $? -eq 0 ];then
#echo "$u is user alias"
user=`sudo grep -w $u /etc/sudoers|grep User_Alias|awk '{print $NF}'|awk -F',' '{for(i=1;i<=NF;i++){print $i}}'`
echo -n $u
for b in $user
do
echo -n ":"$b":"`grep $b /etc/passwd |awk -F':' '{for(i=1;i<=NF;i++)if($i ~/@/){print $i}}'|awk '{print $NF}'`
done
echo
fi
grep -wq $u /etc/passwd
if [ $? -eq 0 ];then
#echo "$u is user"
echo $u":"`grep $u /etc/passwd |awk -F':' '{for(i=1;i<=NF;i++)if($i ~/@/){print $i}}'|awk '{print $NF}'`
fi

done
