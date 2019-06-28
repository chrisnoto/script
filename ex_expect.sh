#!/bin/bash
#iplist="cfibml08"
ip="cfibml08"
#for ip in $iplist
#do
#set timeout 10   before spawn clauses
expect -c "
spawn ssh -l chensen $ip;
expect \"Password:\";
send \"pqhkr88CTW\r\";
expect \"*chensen*\";
#send \"mkdir /sam3\r\";
send \"uptime\r\";
send \"ifconfig\r\";
send \"df -h\r\";
expect eof "
#done
