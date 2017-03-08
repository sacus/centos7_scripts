#!/bin/bash
a=0
b=0
c=0
d=0
e=0
clcemail=474335602@qq.com
warn_value=60
while true
do
a_php=`/bin/ps -ef |grep "php-fpm"|grep -v "grep" |wc -l`
b_nginx=`/bin/ps -ef |grep "nginx"|awk '{print $8}'|grep -v "grep"|grep "nginx"|wc -l`
c_redis=`/bin/ps -ef |grep "redis"|grep -v "grep"|wc -l`
d_es=`/bin/ps -ef |grep "elasticsearch" |grep -v "grep"|wc -l`
#e_df=`df -h |grep "vda1"|awk '{print $4}'|awk -F 'G' '{print $1}'`

if [ $a_php -ne 0 ]
then
echo "the php is ok!!!" >/dev/null 
else
echo "the php is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "php is down"  $clcemail
echo "the php is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)" >> /home/chenlc/scripts/check_php.log 
((a++))
if [ $a -eq 5 ];then
exit
fi
fi


if [ $b_nginx -ne 0 ]
then
echo "the nginx is ok!!!" >/dev/null
else
echo "the nginx is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "nginx is down"  $clcemail
echo "the nginx is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)" >> /home/chenlc/scripts/check_nginx.log
((b++))
if [ $b -eq 5 ];then
exit
fi
fi


if [ $c_redis -ne 0 ]
then
echo "the redis is ok!!!" >/dev/null
else
echo "the redis is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "redis is down"  $clcemail
echo "the redis is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)" >> /home/chenlc/scripts/check_redis.log
((c++))
if [ $c -eq 5 ];then
exit
fi
fi


if [ $d_es -ne 0 ]
then
echo "the es is ok!!!" >/dev/null
else
echo "the es is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "es is down"  $clcemail
echo "the es is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)" >> /home/chenlc/scripts/check_es.log
((d++))
if [ $d -eq 5 ];then
exit
fi
fi

#if [ $e_df -gt 6 ]
#then
#   echo "the disk free is ok" >/dev/null
#else
#  echo "the disk space is $e_df G,the server name is hanfeishi,the time is $(date) " |mail -s "xingou disk space is not enough " $clcemail chenlc@yunduo.com
#  ((e++))
# if [ $e -eq 5 ] ;then
#	exit
# fi
#fi


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


sleep 60
done
