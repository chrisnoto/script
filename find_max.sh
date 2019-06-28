#!/bin/bash
dir=$1
number=`find $dir -maxdepth 1 -type d -print0|xargs -0 du -sk|sed -n '2,$p'|sort -gr|wc -l`
subdir=`find $dir -maxdepth 1 -type d -print0|xargs -0 du -sk|sed -n '2,$p'|sort -gr|head -1|awk '{print $2}'`

du -sh $dir
du -sh $subdir
cd $subdir
while [ $number -ge 1 ]
do 
a=`find . -maxdepth 1 -type d -print0|xargs -0 du -sk|sed -n '2,$p'|sort -gr|head -1|awk '{print $2}'`
du -sh `pwd`/`basename $a`
number=`find $a -maxdepth 1 -type d -print0|xargs -0 du -sk|sed -n '2,$p'|sort -gr|wc -l`
cd $a
done
