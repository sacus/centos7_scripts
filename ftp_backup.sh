#!/bin/bash
#ntpdate us.pool.ntp.org
hostname=88.88.88.88
username=e
n=0
file=`date -d "yesterday" +%Y%m%d`
myPath="/opt/tencentbackup/web/$file"
if [ -d $myPath ];
then
       echo "file is exist!"
exit
else
        echo "ftp start!"
fi
array=("web" "search" "api" "admin" "imagengine"  "rds" "scheduler" "schedulerjob" "elb")
password="123456"
for data in ${array[@]}  
do :  
((n=n+1))
mkdir /opt/tencentbackup/${data}/$file
ftp -v -n $hostname <<ENDFTP
user $username $password
binary
hash 
cd /app/${data}/
lcd /opt/tencentbackup/${data}/$file
prompt
mget *.*
mdelete *.* 
close  
bye
ENDFTP
done 

if [ "$n" == 9 ]
then
	/bin/echo "备份成功!" |/bin/mail -s "e.cn  successful to all" xx@yxx.com
else	
	/bin/echo "备份失败，$n"|/bin/mail -s "e.cn $n fail" xx@xx.com
fi
