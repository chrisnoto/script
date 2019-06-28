#!/bin/bash
FILENAME="$1"
password="r00tme"
user="root"
while read hostname
do
expect -c "
set timeout 10;
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $user@$hostname;
        expect {
                \"*yes/no*\" {send \"yes\r\"; exp_continue}
                \"*assword*\" {send \"$password\r\";}
        }
expect eof "
done < $FILENAME
