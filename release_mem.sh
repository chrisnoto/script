sync
echo `free -m` | echo " `awk '{print $10}'` MB Free Memory Available"
echo 3 > /proc/sys/vm/drop_caches
echo `free -m` | echo " `awk '{print $10}'` MB Free Memory Available"
