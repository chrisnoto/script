#! /bin/bash
idlist=` virsh list --all |awk '/running/{print $1}'`
printf '%.s-' {1..35};printf "kvm resource usage";printf '%.s-' {1..35};echo
printf "%-20s %-20s %-20s %-20s %-20s \n" Vmname State Vcpu Mem Disk 
printf '%.s-' {1..88};echo

Total_vcpu=0
Total_mem=0
Total_disk=0

for vm in $idlist
do
vmname=`virsh dominfo $vm|awk '/Name/{print $2}'`
state=`virsh dominfo $vm| awk '/State/{print $2}'`
cpunum=`virsh dominfo $vm |awk '/CPU\(s\)/{print $2}'`
mem=`virsh dominfo $vm| awk '/Max/{print $3}' `
Mem=`expr $mem / 1024 / 1024 `
sum=0
for disk in `virsh domblklist $vm|awk '/qcow2/{print $2}'`
do 
b=`qemu-img info $disk | awk '/virtual/{print int($3)}'`
sum=`expr $sum + ${b%%G}` 
done
Total_vcpu=`expr $Total_vcpu + $cpunum`
Total_mem=`expr $Total_mem + $Mem`
Total_disk=`expr $Total_disk + $sum`

printf "%-20s %-20s %-20s %-20s %-20s \n" $vmname $state $cpunum ${Mem}G ${sum}G  
done

printf '%.s-' {1..88};echo
printf "%-20s %-20s %-20s %-20s %-20s \n" "Total" " " $Total_vcpu ${Total_mem}G ${Total_disk}G

