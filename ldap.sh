#!/bin/bash
Usage() {
cat <<- EOF
        -s 071940-672/071940672
        -u chensen
        -m chensen@cn.xxx.com
        -n "Sen SC Chen/China/xxx@xxxCN"
EOF
      exit 1
}

function search() {
key=$1
value=$2
ldapsearch -h bluepages.xxx.com -x -b "ou=bluepages,o=xxx.com" -s sub "($key=$value)"|egrep '^uid|^mail|^notesEmail|^job|^tieline|^tele|^iptel|^build|^floor|^timestampHRMS|^manager:'|sed -e 's/OU=//' -e 's/O=//' -e 's/CN=//'
}

if [ $# == 0 ];then
Usage
fi

while getopts s:u:m:n: opt;do
     case $opt in
          s) uid=$OPTARG
             uid=${uid/-/}
             search uid $uid
          ;;
          u) primaryuserid=$OPTARG
             search primaryuserid $primaryuserid
 ;;
          m) mail=$OPTARG
             search mail $mail
 ;;
          n) notesEmail=$OPTARG
		len=`echo $notesEmail|awk -F"/" '{print NF}'`
		if [ $len == 3 ];then
		notesEmail=`echo $notesEmail|sed 's#\(.*\)/\(.*\)/\(.*\)#CN=\1/OU=\2/O=\3#'`
		else
		notesEmail=`echo $notesEmail|sed 's#\(.*\)/\(.*\)/\(.*\)/\(.*\)#CN=\1/OU=\2/OU=\3/O=\4#'`
		fi
             search notesEmail "$notesEmail"
          ;;
          \?) Usage ;;
    esac
done
