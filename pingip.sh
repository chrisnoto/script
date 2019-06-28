#!/bin/bash
exec > /home/sam/ping.log 2>&1
echo "## Start ping at `date +%Y%m%d_%H%M%S`"
FILENAME="$1"
while read LINE
do
ping -c 1 $LINE >/dev/null 2>&1
if [ $? == 0 ]
 then echo "$LINE is pingable."
else
echo "$LINE is not pingable XXXXXXXX"
fi
done < $FILENAME
