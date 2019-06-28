#!/bin/bash
docker-machine create -d openstack \
  --engine-env HTTP_PROXY=http://10.62.32.27:33128 \
  --engine-env HTTPS_PROXY=http://10.62.32.27:33128 \
  --engine-env NO_PROXY=*.local,169.254/16 \
  --openstack-auth-url="https://10.67.36.80:5000/" \
  --openstack-flavor-name="amd_4C_4G_40G" \
  --openstack-image-name="centos7_proxy" \
  --openstack-insecure="true" \
  --openstack-net-name="admin_floating_net" \
  --openstack-username="admin" \
  --openstack-password="F0xc0nn!23" \
  --openstack-sec-groups="default" \
  --openstack-ssh-user="centos" \
  --openstack-tenant-name="admin" \
  --openstack-user-data-file="/root/userdata" \
  $1

