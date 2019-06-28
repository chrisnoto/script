echo "#######controller nodes flow table 22 ##########"
ansible controller -m shell -a "ovs-ofctl dump-flows br-tun table=22 |grep 0x2"
echo "#######compute nodes flow table 22 ##########"
ansible compute -m shell -a "ovs-ofctl dump-flows br-tun table=22 |grep 0x2"
