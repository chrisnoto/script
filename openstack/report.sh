#!/bin/bash

. /root/openrc
date

echo "#### report of instances ###"
nova list
mysql nova -t -e "select host,hostname,vcpus,memory_mb,root_gb,vm_state,created_at from instances where vm_state='active' order by host;"

echo "### report of hypervisor usage ###"
mysql nova -t -e "select hypervisor_hostname,vcpus_used,vcpus,memory_mb_used,memory_mb,local_gb_used,local_gb,running_vms from compute_nodes;"

echo "### report of volumes ###"
mysql cinder -t -e "select volumes.display_name as Name,volumes.display_description as Description,volumes.size as size_gb,volumes.status,volumes.attach_status,volume_attachment.instance_uuid as 'Attached to',volume_attachment.mountpoint,volumes.bootable from volumes,volume_attachment where volumes.id=volume_attachment.volume_id and volumes.deleted='false';"

echo "### report of volume backups ###"
mysql cinder -t -e "select id,volume_id,status,display_name,size as size_gb,object_count,container from backups where deleted='0';"

echo "### report of volume snapshots ###"
cinder snapshot-list
mysql cinder -t -e "select id,volume_id,status,display_name,volume_size as size_gb,created_at from snapshots where deleted='0';"

echo "### report of image ###"
mysql glance -t -e "select name,round(size/1024/1024) as size_mb,status,is_public,disk_format,container_format,protected,created_at from images where status='active';"

