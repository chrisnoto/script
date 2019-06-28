#!/bin/bash
if [ -e /home/chensen/`uname -n`.manual ];then
rm -f `uname -n`.manual
fi
if [ $# != 1 ];then
echo "Usage: ./manualcheck.sh command-file"
else
myfile=$1
fi
function output ()
{
u=`whoami`
h=`uname -n`
h=${h%%.*}
if test `pwd` == `echo $HOME`;then
   w="~"
else
   w=`pwd`
   w=`basename $w`
fi
printf "[%s@%s %s]$ %s\n" "$u" "$h" "$w" "$1"
eval "$1"
}
while read LINE
do
output "$LINE" >> `uname -n`.manual 2>&1
done< <(grep -v '^#' $myfile)
