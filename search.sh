#!/bin/bash
user=$1
cat /etc/passwd|grep $user >result.txt
