#!/bin/bash
PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/java/jdk1.5.0_07/bin:/opt/ibm/director/bin:/home/chensen/bin
export $PATH
source /home/chensen/.functions
check_agent
dokeychainmagic

${HOME}/app/bin/dsh -M -f ${HOME}/djs_prod -c "sar -P ALL 2 5|grep Average|grep all|awk '{print \$NF}'" >${HOME}/report/rawinput
for u in `cat ${HOME}/djs_prod`
do
grep $u ${HOME}/report/rawinput
done >${HOME}/report/input
rm -f ${HOME}/report/rawinput
${HOME}/report/append.py
