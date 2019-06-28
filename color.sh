function color()
{
for((i=1;i<=100;i++))
 do
 if [ $i -le $1 ];then
 echo -en "\033[41;1m "
 else
 echo -en "\033[42;1m "
 fi
 echo -en "\033[0m"
 done
}
while read part percent tsize
do
echo -n "$part $percent:"
color ${percent%\%} 
echo " $tsize"
echo
done < <(for fs in `df -h|egrep '[0-9]M|[0-9]G|[0-9]T'|awk '{print $NF}'`;do echo `df -h $fs`|awk '{print $NF,$12,$9}';done)

