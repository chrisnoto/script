#!/bin/bash
function color()
{
case $2 in
U) c=42;;
s) c=41;;
W) c=44;;
esac
if test $1 -gt 0;then
for((i=0;i<$1;i+=2))
 do
 echo -en "\033[${c}m$2"
 done
 echo -en "\033[0m"
fi
}

function x(){
while read User Sys Wait
do
User=${User%\.[0-9]*}
Sys=${Sys%\.[0-9]*}
Wait=${Wait%\.[0-9]*}
color $User U
color $Sys s
color $Wait W
echo
done < <(echo $1 $2 $3)
}
while(true);do
clear
#printf "%-s\t%-s\t%-s\t%-s\t%-s\n" CPU User% Sys% Wait% Idle
echo -en "CPU\t\033[32mUser%\033[0m\t\033[31mSys%\033[0m\t\033[34mWait%\033[0m\tIdle\n"
while read line
do
want=`echo $line|awk '{print $2,$3,$4}'`
printf "%-3s\t%-5s\t%-7s\t%-7s\t%-5s" $line
x $want
done< <(sar -P ALL 1 1|grep Average|awk '{print $2,$3,$5,$6,$NF}'|sed -n '1!p')
sleep 3
done
