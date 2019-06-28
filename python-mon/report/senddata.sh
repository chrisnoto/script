#!/bin/bash
PATH=/usr/lib/qt-3.3/bin:/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/java/jdk1.5.0_07/bin:/opt/xxx/director/bin:/home/chensen/bin:/home/chensen/python2.6/bin
export $PATH
source /home/chensen/.functions

/usr/bin/python2.6 ${HOME}/report/report.py

/usr/bin/uuencode ${HOME}/report/CPUMonitor_Boxing_Day_2015.xlsx CPUMonitor_Boxing_Day_2015.xlsx | /bin/mailx -s "CPU Monitor Boxing Day 2015" chensen@cn.xxx.com,robinnic@au1.xxx.com,ddhatabaya@davidjones.com.au,kim.reynolds@davidjones.com.au,drobinso@davidjones.com.au,tony.latella@countryroadgroup.com.au,steve.binns@countryroadgroup.com.au,dthomas@davidjones.com.au,gbloemen@davidjones.com.au,gauravaggarwal@in.xxx.com

