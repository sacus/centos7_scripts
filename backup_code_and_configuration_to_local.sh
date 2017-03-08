#!/bin/bash
#this scripts is backup online_code_to_company (contain images and program logs) 
#backup tools is rsync ,increase type.

#no.1 backup configuration to code directory

a=`date +%F_%H:%M:%S`
/usr/bin/rsync -az /etc/nginx/  /data/gitcode/nginx_redis_mysql_php_config-bakcup/nginx/ \
&& /usr/bin/rsync -az /etc/php.ini /data/gitcode/nginx_redis_mysql_php_config-bakcup/php/ \
&& /usr/bin/rsync -az /etc/php-fpm.conf /data/gitcode/nginx_redis_mysql_php_config-bakcup/php/ \
&& /usr/bin/rsync -az /etc/php-fpm.d/  /data/gitcode/nginx_redis_mysql_php_config-bakcup/php/ \
&& /usr/bin/rsync -az /etc/php.d/  /data/gitcode/nginx_redis_mysql_php_config-bakcup/php/ \
&& /usr/bin/rsync -az /etc/redis/  /data/gitcode/nginx_redis_mysql_php_config-bakcup/redis/ \
&& /usr/bin/rsync -az /opt/redis_data/  /data/gitcode/nginx_redis_mysql_php_config-bakcup/redis/ \
&& /usr/bin/rsync -az /etc/my.cnf  /data/gitcode/nginx_redis_mysql_php_config-bakcup/mysql/ \

avarg1=$?

/usr/bin/rsync -az --port=873 --bwlimit=100   /data/gitcode/  rsync@ip::www  --password-file=/etc/rsync1.password 

avarg2=$?

b=`date +%F_%H:%M:%S`

if [ $avarg1 -eq 0 -a $avarg2 -eq 0 ]
	then
	echo "php,redis,mysql,nginx configuration  and penny_test code data backup to company is successful! the start time is $a,the end time is $b"|mail -s "penny_test_code_data and config backup success" chenlc@sacus.com
	else
	echo "php,redis,mysql,nginx configuration  and penny_test code data backup to company is fail! the config backup fail_code is $avarg1 ,the code data backup fail_code is $avarg2, the start time is $a,the end time is $b"|mail -s "penny_test_code_data and config backup is fail" chenlc@sacus.com qqqq@qq.com
fi
