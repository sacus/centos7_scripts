#!/bin/bash
cd /opt/www/ && /bin/tar -zcf   www_$(date +%F).tar.gz  --exclude=abc-php/logs/wechat.log  ./*  && /bin/mv ./www_$(date +%F).tar.gz  /backup/www_all_tar/  &>/dev/null

avarg1=$?
avarg2=1
#delete file 21days ago

/bin/find  /backup/www_all_tar/ -type f -mtime +22 |xargs /bin/rm -f
if [ $avarg1 -eq  0 ]
    then
        a=`date +%H:%M:%S`
        /usr/bin/rsync -az --port=873    /backup/www_all_tar/  rsync_backup@IP::www_all_abc  --password-file=/etc/rsync.password
 	    avarg2=$?
        b=`date +%H:%M:%S`
fi

if [ $avarg2 -eq 0 ]
    then
        echo "abc web 01 ,rsync backup www tar to company is  successful,the start time is $a,the end time is $b" |mail -s "abc  backup tar to company  success" abc@admin.com 
    else
        echo "abc web 01 ,rsync backup www tar is fail,the avarg1 is $avarg1,the avarg2 is $avarg2,the start time is $a ,the end time is $b " |mail -s "abc  backup tar to company  fail" abc@admin.com 
fi
