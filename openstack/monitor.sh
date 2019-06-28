#!/bin/bash

. /root/openrc
date
echo
echo "------------------------Ceph Storage------------------------"
echo "#### Usage per OSD ####"
ceph osd df tree
echo "#### Usage per pool ####"
ceph df
echo "###check ceph status###"
ceph -s
echo
echo "------------------------Network-------------------------------"
echo "###List VIP for Management VrouterPub Vrouter Public###"
pcs resource show vip__management |awk -F: '/Attributes/{print $2}'
echo
pcs resource show vip__vrouter_pub |awk -F: '/Attributes/{print $2}'
echo
pcs resource show vip__vrouter |awk -F: '/Attributes/{print $2}'
echo
pcs resource show vip__public |awk -F: '/Attributes/{print $2}'
echo
echo "###List Neutron agents###"
neutron agent-list
echo "####Net list on dhcp agent####"
for a in `neutron agent-list|awk '/DHCP/{print $2}'`;do echo "Agent: $a"; neutron net-list-on-dhcp-agent $a;done
echo
echo "####L3 agent list hosting router####"
for r in `neutron router-list|awk '/network_id/{print $2}'`;do neutron l3-agent-list-hosting-router $r;done
echo
echo "-------------------------Main Openstack Services---------------"
echo "###List Hypervisor###"
nova hypervisor-list
echo "###List Nova service###"
nova service-list
echo "###List Cinder service###"
cinder service-list

IP=`ifconfig br-mgmt|grep -oP "inet addr:\S+"|grep -oP "\d+.\d+.\d+.\d+"`
echo "###check haproxy service###"
echo "show stat"|socat /var/lib/haproxy/stats stdio |awk -F"," '{print $1,$2,$18}'|egrep -i 'UP|down'
echo
echo "###check wsrep status###"
mysql -e 'show variables;' |egrep 'wsrep_cluster_name|wsrep_cluster_address|wsrep_on'
mysql -e 'show status;' |egrep 'wsrep_cluster_size|wsrep_ready|wsrep_local_state_comment|wsrep_cluster_status|wsrep_replicated_bytes|received_bytes|local_commits'
echo
echo "###check corosync/pacemaker status###"
pcs status
echo
echo "###check RabbitMq cluster status###"
rabbitmqctl cluster_status
echo "---------------------------End of services check-------------------"
