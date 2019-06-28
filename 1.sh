#!/bin/bash
myfile="sar.file.tar.gz"

check() {
a=$1
result=`file $a`

for t in XZ gzip bzip2
do
echo $result |grep -q "$t compressed data"
if [ $? -eq 0 ]
then
echo "file is $t compressed data"
ctype=$t
fi
done

case "$ctype" in
  XZ)
    tar Jxvf $a
    ;;
  gzip)
    tar zxvf $a
    ;;
  bzip2)
    tar jxvf $a
    ;;
esac
}

check $myfile
