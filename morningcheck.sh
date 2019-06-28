#!/bin/bash
PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin
export $PATH
source /home/chensen/.functions
check-agent
dokeychainmagic
myday=`date +%Y-%m-%d`
exec > /home/chensen/log/check_${myday}.txt 2>&1
cat <<- EOF
Subject: David Jones morning check
From: linuxup@au1.xxx.com
To: chensen@cn.xxx.com,hhhuang@cn.xxx.com,zmku@cn.xxx.com,tfpan@cn.xxx.com,ycfang@cn.xxx.com,sunjch@cn.xxx.com,xiexjxj@cn.xxx.com,gdclinx1@cn.xxx.com
EOF

echo "=================================uptime============================"
/home/chensen/pssh-2.3.1/bin/pssh -l chensen -h /home/chensen/djs_srvlist --inline-stdout "uptime" |xargs -L 2
sleep 10
echo "===============================space above 80%====================="
/home/chensen/p.sh -f /home/chensen/djs_srvlist -c "df -hTP|egrep '[8-9][0-9]%|100%'|egrep -v 'cifs|nfs|rackware'"
sleep 10
echo "===============================root password expiration============"
/home/chensen/pssh-2.3.1/bin/pssh -l chensen -h djs_srvlist -x '-t -t' --inline-stdout "sudo /usr/bin/chage -l root |grep 'Password expires'" |xargs -L 2
echo "=============================TSM backup status====================="
/home/chensen/pssh-2.3.1/bin/pssh -l chensen -h /home/chensen/djs_srvlist -x '-t -t' --inline-stdout "sudo /home/chensen/bin/dsmc_ok |tail -22|egrep 'transferred|processing'"
echo "============================Finished check========================="
djs_srv=`cat /home/chensen/djs_srvlist`
log="/home/chensen/log/check_`date +%Y-%m-%d`.txt"
s_uptime=`sed -n '/uptime/,/space/p' ${log} |awk '/au04/{print $4}'|sort -u`
s_backup=`sed -n '/TSM/,/Finished/p' ${log} |awk '/SUCCESS/{print $4}'|sort -u`

for srv in $djs_srv
do
echo $s_uptime|grep -q $srv 
[ $? -eq 0 ] || echo "$srv has connection issue"
done
for srv in $djs_srv
do 
echo $s_backup|grep -q $srv
[ $? -eq 0 ] || echo "$srv TSM backup failed" 
done
#echo "=======================file system more than 100GB=================="
# df -hP is similar to "df -h|tail -n +2|xargs -n 6"
#for u in `cat /home/chensen/djs_srvlist`;do echo "------$u------";ssh $u "bash -c $(printf '%q' "df -hTP|egrep -v 'cifs|nfs' |grep '[0-9]\{3,\}G'")";done
/usr/sbin/sendmail -f linuxup@au1.xxx.com -t chensen@cn.xxx.com,hhhuang@cn.xxx.com,zmku@cn.xxx.com,tfpan@cn.xxx.com,ycfang@cn.xxx.com,sunjch@cn.xxx.com,xiexjxj@cn.xxx.com,gdclinx1@cn.xxx.com < /home/chensen/log/check_`date +%Y-%m-%d`.txt
