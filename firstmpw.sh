#!/bin/bash
FILENAME="$1"
oldpass=""
newpass=""
user=""
while read hostname
do
expect -c "
set timeout 10;
spawn ssh -l $user $hostname;
expect {
	\"*yes/no*\" {send \"yes\r\"; exp_continue}
        \"*assword*\" {send \"$oldpass\r\";}
       }
expect \"*current*\";
send \"$oldpass\r\";
expect \"*New*\";
send \"$newpass\r\";
expect \"*Retype*\";
send \"$newpass\r\";
expect eof "
done < $FILENAME
