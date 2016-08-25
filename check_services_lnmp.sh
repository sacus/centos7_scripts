#!/bin/bash
a=0
b=0
c=0
d=0
while true
do
a_php=`/bin/ps -ef |grep "php-fpm"|grep -v "grep" |wc -l`
b_nginx=`/bin/ps -ef |grep "nginx"|awk '{print $8}'|grep -v "grep"|grep "nginx"|wc -l`
c_redis=`/bin/ps -ef |grep "redis"|grep -v "grep"|wc -l`
d_mysql=`/bin/ps  -ef |grep mysql|grep -v "grep"|wc -l`

if [ $a_php -ne 0 ]
then
echo "the php is ok!!!" >/dev/null 
else
echo "the php is down !!! the server name is `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "php is down"  474335602@qq.com
((a++))
if [ $a -eq 5 ];then
exit
fi
fi


if [ $b_nginx -ne 0 ]
then
echo "the nginx is ok!!!" >/dev/null
else
echo "the nginx is down !!! the server name is `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "nginx is down"  474335602@qq.com
((b++))
if [ $b -eq 5 ];then
exit
fi
fi


if [ $c_redis -ne 0 ]
then
echo "the redis is ok!!!" >/dev/null
else
echo "the redis is down !!! the server name is `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail  -s "redis is down"  474335602@qq.com
((c++))
if [ $c -eq 5 ];then
exit
fi
fi


if [ $d_mysql -ne 0 ]
then
echo "the mysql is ok!!!" >/dev/null
else
echo "the mysql is down !!! the server name is `hostname` ,the time is $(date +%F" "%H:%M:%S)"|/bin/mail -s "mysql is down"  474335602@qq.com
((d++))
if [ $d -eq 5 ];then
exit
fi
fi

sleep 60
done
