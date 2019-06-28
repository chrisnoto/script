#!/bin/bash
while read srv day
do
echo -n $srv >>tmp.suggestion
date -d "$day" +%Y%m%d >>tmp.suggestion
done< <(grep 2014 change_suggest.list|awk '{print $2,$3}'|grep -f myserver)

day=`date -d "90 days" +%Y%m%d`
cat tmp.suggestion|awk -F: '{if($2<'$day')print $0}'
rm -f tmp.suggestion

