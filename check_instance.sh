#!/bin/bash
srv="10.20.0.5 10.20.0.14 10.20.0.16"
for s in $srv
do
  for u in `virsh -c qemu+ssh://root@$s/system list|awk '/running/{print $1}'`
  do 
  virsh -c qemu+ssh://root@$s/system dominfo $u|egrep 'Name|UUID|CPU\(s\)|Used memory'
  virsh -c qemu+ssh://root@$s/system domblklist $u
  virsh -c qemu+ssh://root@$s/system domiflist $u
  done
done

