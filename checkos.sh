#!/bin/bash
os=`cat /etc/*release|grep -i linux|uniq`
[ `echo $os|grep -i "red hat"|grep -c "5\."` -gt 0 ] && echo "redhat 5"
[ `echo $os|grep -i "red hat"|grep -c "6\."` -gt 0 ] && echo "redhat 6"
[ `echo $os|grep -i "suse"|grep -c "11"` -gt 0 ] && echo "suse 11"
[ `echo $os|grep -i "suse"|grep -c "10"` -gt 0 ] && echo "suse 10"
