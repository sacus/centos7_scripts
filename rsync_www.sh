!/bin/bash
#every day to backup /application/nginx/www content to local
/usr/bin/rsync -az  /opt/www/   /backup/www/
avarg1=$?
avarg2=1
 if [ $avarg1 -eq 0  ]
        a=`date +%H:%M:%S`
        then
         /usr/bin/rsync -az --port=873    /backup/www/  rsync_backup@IP::www_abc --password-file=/etc/rsync.password
        avarg2=$?
        b=`date +%H:%M:%S`
 fi
if [ $avarg2 -eq 0 ]
   then
         echo "abc web 01 ,rsync backup www dir to company is  successful,the start time is $a,the end time is $b" |mail -s "abc  backup to company  success" abc@admin.com 
   else
       echo "abc web 01 ,rsync backup www dir is fail,the avarg1 is $avarg1,the avarg2 is $avarg2,the start time is $a,the end time is $b " |mail -s "abc  backup to company  fail"abc@admin.com 
fi
