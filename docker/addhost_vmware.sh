#!/bin/bash
docker-machine create -d vmwarevsphere \
  --vmwarevsphere-boot2docker-url=http://10.67.51.164/rancheros-vmware.iso \
  --vmwarevsphere-vcenter=10.67.36.10  \
  --vmwarevsphere-username=root  \
  --vmwarevsphere-password=Foxconn123  \
  --vmwarevsphere-cpu-count=4 \
  --vmwarevsphere-memory-size=6144 \
  --vmwarevsphere-disk-size=60000 \
  --vmwarevsphere-datastore=data3 \
  --vmwarevsphere-network='VM Network' \
$1

