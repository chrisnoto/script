#!/bin/bash
### for David jones ####
PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/java/jdk1.5.0_07/bin:/opt/ibm/director/bin:/home/chensen/bin
export $PATH
source /home/chensen/.functions
check_agent
dokeychainmagic
db="/home/chensen/secfixdb.RedHat5Server"
if [ -e $db ];then
rm -f $db
fi
./secfixdb_download.sh secfixdb.RedHat5Server
/home/chensen/pssh-2.3.1/bin/pscp -h djs_srvlist secfixdb.RedHat5Server /home/chensen
