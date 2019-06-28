#!/bin/bash
Usage() {
cat <<- EOF
    =================================================================
    Description: parallel ssh script
    Basic usage: $0 -f file -c "command"
    Useful option:
    =================================================================
    -x: put ssh option here. eg: -l user -R 1880:mrepo:80
    -o: put ssh config option here. eg:CheckHostIP=no TCPKeepAlive=yes
    Default output same as dsh output
    -1:  change to pssh output
    -h:  print HELP
    =================================================================
EOF
exit 1
}
SHOW=0
xflag=()
oflag=""
while getopts 1c:f:ho:x: opt;do
    case $opt in
    1)SHOW=1;;
    c)cmd=$OPTARG;;
    f)file=$OPTARG;;
    o)ARRAY=($OPTARG) ;;
    x)xflag=($OPTARG) ;;
    h)Usage ;;
    \?) Usage ;;
    esac
done
oflag=`for u in ${ARRAY[@]};do echo -en "-o$u ";done`
ssh="ssh ${xflag[*]} $oflag"

cleanup()
{
exec 6>&-
kill -- -$$
rm -f /tmp/tmp.*
kill -9 $$
}
########setup queue number for threading#######
threads=30
tmp_fifo="/tmp/$$.fifo"
mkfifo $tmp_fifo
exec 6<>$tmp_fifo
rm -f $tmp_fifo
trap 'cleanup' SIGTERM SIGINT
for ((i=0;i<$threads;i++))
do
  echo
done >&6

############run multiple ssh####
for u in `cat $file`
do
  read -u6
  (
  tmpfile=`mktemp -u`
#################################dsh output  
  if test $SHOW -eq 0;then
  $ssh $u "bash -c $(printf '%q' "$cmd")" |sed "1s/^.*$/[$u] &/" >>$tmpfile
  else
#################################pssh output
  $ssh $u "bash -c $(printf '%q' "$cmd")" >>$tmpfile
  [ $? -eq 0 ] && status="Success" || status="Failure"
  echo >> $tmpfile
  sed -i "1i\ `date +%T` [$status] $u" $tmpfile
  fi
  cat $tmpfile
  rm -f $tmpfile
  echo >&6
  )&
done | awk 'BEGIN{c=0}/\[/{c++;print "["c"]",$0;next}1'
wait
exec 6>&-
