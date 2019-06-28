#!/bin/bash
Usage() {
cat <<- EOF
  ============================================
  Description: check ESX and VMs information
  Basic usage: $0 -f serverlist -a "command"
            or $0 -c ip -a "command"
  command example:
  nodeinfo
  list --all
  dominfo vmid
  dumpxml vmid
  snapshot-list vmid
  net-list
  pool-list
  pool-info 50.252\ Storage
  vol-list 50.252\ Storage
  vol-info --pool 50.252\ Storage Zabbix2/Zabbix2.vmdk
  ============================================
EOF
exit 1
}

while getopts f:c:ha: opt;do
  case $opt in
  f)file=$OPTARG;;
  c)srv=$OPTARG;;
  a)cmd=$OPTARG;;
  h)Usage ;;
  \?) Usage ;;
  esac
done


password='Cesbg\$server'
if [ -f `pwd`/$file ]
then
while read hostname
do
expect -c "
set timeout 10;
spawn virsh -c "esx://$hostname?no_verify=1" $cmd;
    expect {
        \"username\" {send \"root\r\";exp_continue}
        \"password\" {send \"$password\r\";}
    }
expect eof "
done <$file
else
expect -c "
set timeout 10;
spawn virsh -c "esx://$srv?no_verify=1" $cmd;
    expect {
        \"username\" {send \"root\r\";exp_continue}
        \"password\" {send \"$password\r\";}
    }
expect eof "

fi
