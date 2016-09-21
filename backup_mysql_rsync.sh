#!/bin/bash
port=3306
mysql_user=root
mysql_pwd=''
mysql_log_cmd="mysql -u$mysql_user -p$mysql_pwd "
mysql_dbs=`$mysql_log_cmd -e "show databases;"|egrep -v "Database|test"`
mysql_dump_cmd="mysqldump -u$mysql_user -p$mysql_pwd "
backupdir=/backup/mysql
#delete 4days ago 
/bin/find /backup/mysql/  -type f -mtime +4  |xargs /bin/rm -f 
for dbname in ${mysql_dbs}
  do
    $mysql_dump_cmd --events -B $dbname|gzip >$backupdir/${dbname}_$(date +%F)_bak.sql.gz && a=`date +%H:%M:%S` && /usr/bin/rsync -az --port=873    /backup/mysql/  rsync_backup@IP::mysql_  --password-file=/etc/rsync.password   && b=`date +%H:%M:%S`	
	if [ $? -eq 0 ]
		then
		  echo "clc $dbname is backup to commpany successful!,the start time is $a,the end time is $b " |mail -s "clc $dbname backup succeseful" abc@admin.com 
		else
		  echo "clc $dbname backup fail,the start time is $a,the end time is $b" |mail -s "babaynuts $dbname backup fail" abc@admin.com 
	fi
  done
