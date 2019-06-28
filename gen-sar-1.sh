#!/bin/bash
PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/java/jdk1.5.0_07/bin:/opt/ibm/director/bin:/home/chensen/bin
export $PATH
source /home/chensen/.functions
check_agent
dokeychainmagic
myday=`date -d "-1 day" +%Y%m%d`

/home/chensen/pssh-2.3.1/build/scripts-2.4/pssh -l chensen -h /home/chensen/djs_srvlist -x '-t -t' "sudo find /var/log/sa -iname 'sar*' -mtime -1 |xargs -tI{} sudo cp {} /home/chensen"

/home/chensen/pssh-2.3.1/build/scripts-2.4/pssh -l chensen -h /home/chensen/djs_srvlist -x '-t -t' "sudo chown chensen sar*"

(cd SAR
 for u in `cat /home/chensen/djs_srvlist`
 do
 scp chensen@$u:~/sar* ${myday}_${u}_sar1
 done
)
/home/chensen/pssh-2.3.1/build/scripts-2.4/pssh -l chensen -h /home/chensen/djs_srvlist "rm -f sar*"

for u in `ls /home/chensen/SAR`
do
/usr/bin/java -jar /home/chensen/montest/kSar/kSar.jar -input "/home/chensen/SAR/${u}" -outputPDF /home/chensen/SAR_PDF/${u}.pdf
/usr/bin/uuencode /home/chensen/SAR_PDF/${u}.pdf ${u}.pdf | /bin/mailx -s "DJ Linux server performance report --- ${u}" chensen@cn.ibm.com,cdevaney@au1.ibm.com
sleep 120
done

rm -f /home/chensen/SAR/*
rm -f /home/chensen/SAR_PDF/*.pdf
