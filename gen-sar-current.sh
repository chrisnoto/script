#!/bin/bash
PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/java/jdk1.5.0_07/bin:/opt/ibm/director/bin:/home/chensen/bin
export $PATH
source /home/chensen/.functions
check_agent
dokeychainmagic
myday=`date +%Y%m%d_%p`
montest="/home/chensen/montest"

/home/chensen/pssh-2.3.1/bin/pssh -l chensen -h /home/chensen/djs_srvlist -x '-t -t' 'LC_TIME="POSIX" sar -A -s 00:00:00 >sar_current'

(cd ${montest}/processed
/home/chensen/pssh-2.3.1/bin/pslurp -l chensen -h /home/chensen/djs_srvlist -r /home/chensen/sar_current .
zip -r ${myday}_sar.zip ./au04*
mv ./au04* ${montest}/sars/
)


/home/chensen/pssh-2.3.1/bin/pssh -l chensen -h /home/chensen/djs_srvlist "rm -f sar*"

mkdir -p ${montest}/data/$myday
mkdir -p ${montest}/graphs/$myday

for i in ${montest}/sars/*
  do
  if [ -f "${i}/sar_current" ]
  then
  cd $i
  gawk -f ${montest}/generate_summary.awk sar_current >> ${montest}/reports/summary_${myday}.txt
  #/usr/bin/java -jar ${montest}/kSar/kSar.jar -input sar_current -outputPDF ${montest}/graphs/${myday}/`basename $i`.pdf
  mv *.dat ${montest}/data/${myday}
  fi
done
#/usr/bin/uuencode ${montest}/reports/summary_${myday}.txt summary_${myday}.txt | /bin/mailx -s "DJ Linux server report --- ${myday}" chensen@cn.ibm.com
/bin/mailx -s "DJ Linux server report  ${myday}" chensen@cn.ibm.com,robinnic@au1.ibm.com,gauravaggarwal@in.ibm.com <${montest}/reports/summary_${myday}.txt

rm -rf ${montest}/sars/*
