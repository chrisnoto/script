#!/bin/bash

ansible ceph-prod -m shell -a "megacli -pdlist -aall|egrep -i 'media error|other error|firmware state'"
ansible controller-prod -m shell -a "megacli -pdlist -aall|egrep -i 'media error|other error|firmware state'"
