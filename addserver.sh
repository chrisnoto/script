#!/bin/bash
if [ $# != 1 ];then
echo "Usage ./addserver filename"
else
myfile=$1
fi
while read line
do
cat <<-EOF >> 111
	$line:
	  user: chensen
	  host: $line
	  priv: /home/sam/.ssh/id_rsa
EOF
done< $myfile
