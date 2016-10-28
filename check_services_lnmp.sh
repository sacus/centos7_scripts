#!/bin/bash
a=0
b=0
c=0
d=0
e=0
while true
do
a_php=`/bin/ps -ef |grep "php-fpm"|grep -v "grep" |wc -l`
b_nginx=`/bin/ps -ef |grep "nginx"|awk '{print $8}'|grep -v "grep"|grep "nginx"|wc -l`
c_redis=`/bin/ps -ef |grep "redis"|grep -v "grep"|wc -l`
d_es=`/bin/ps -ef |grep "elasticsearch" |grep -v "grep"|wc -l`
e_df=`df -h |grep "vda1"|awk '{print $4}'|awk -F 'G' '{print $1}'`

if [ $a_php -ne 0 ]
then
echo "the php is ok!!!" >/dev/null 
else
echo "the php is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "php is down"  474335602@qq.com
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
echo "the nginx is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "nginx is down"  474335602@qq.com
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
echo "the redis is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "redis is down"  474335602@qq.com
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
echo "the es is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "es is down"  474335602@qq.com
echo "the es is down !!! the server name is hanfieshi the first `hostname` ,the time is $(date +%F" "%H:%M:%S)" >> /home/chenlc/scripts/check_es.log
((d++))
if [ $d -eq 5 ];then
exit
fi
fi

if [ $e_df -gt 6 ]
then
   echo "the disk free is ok" >/dev/null
else
  echo "the disk space is $e_df G,the server name is hanfeishi,the time is $(date) " |mail -s "xingou disk space is not enough " 474335602@qq.com chenlc@yunduo.com
  ((e++))
 if [ $e -eq 5 ] ;then
	exit
 fi
fi

sleep 60
done
