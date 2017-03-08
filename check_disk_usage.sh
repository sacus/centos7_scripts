#!/bin/bash
#this scripts is monitor soft and disk and cpu

clcemail=474335602@qq.com
warn_value=60
#检查磁盘的使用情况,使用率的%去掉了，不去掉不好比较大小，60代表%60。
function check_disk_usage(){
warn_value=60
array_dev=($(df -h |grep "dev"|grep -v "tmpfs"|awk '{print $1}'))
array_usage=($(df -h |grep "dev"|grep -v "tmpfs"|awk '{print $5}'|awk -F "%" '{print $1}'))
array_dir=($(df -h |grep "dev"|grep -v "tmpfs"|awk '{print $6}'))
  for((i=0;i<${#array_usage[*]};i++))
    do
	if [ ${array_usage[i]} -gt $warn_value  ]
	    then
	      echo "disk usage is higher,it is ${array_usage[i]}% ,the disk_dev is ${array_dev[i]} ,the mount dir is ${array_dir[i]}"|mail -s "!!!! disk usage is higher" $clcemail
	fi 
done
}
check_disk_usage
