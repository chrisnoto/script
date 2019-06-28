cd /sys/class/fc_host/
for i in `ls -ld host* | awk {'print $9'}`
do
#echo "wwpn for $i"
cat /sys/class/fc_host/$i/port_name | cut -b 3-18
#cat /sys/class/fc_host/$i/node_name
done

