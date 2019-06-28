#!/bin/bash
df |cut -c52- |grep -vE "Use%|^$" | while read usage filesystem
do
if [ ${usage%\%} -gt 50 ]; then echo $usage $filesystem
fi
done
