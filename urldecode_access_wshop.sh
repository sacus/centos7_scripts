#!/bin/bash
date_1=`date -d "-1 day" +%d/%b/%Y`
date_2=`date +%d/%b/%Y`
a_time=${date_1}:00:00:00
b_time=${date_1}:23:59:59
/usr/bin/grep "GET /log" /application/nginx/logs/access_wshop.xingou.net.cn.log|awk -F '[ []+' '{if ($4 >="'${a_time}'" && $4 <="'${b_time}'") print $0}'>/application/nginx/logs/grep_access_wshop.log
avarg=$?
alias urldecode2='python -c "import sys,urllib as u1; print u1.unquote_plus(sys.argv[1])"'
#urldecode2 "`cat /application/nginx/logs/grep_access_wshop.log|awk -F '[[]+' '{print $2}'|awk -F '[]"]' '{print "["$1"] "$3}'`"  >>/application/nginx/logs/urldecode_access_wshop.log

if [ $avarg -eq 0 ]
    then
	c=`wc -l /application/nginx/logs/grep_access_wshop.log|awk '{print $1}'`
	a=1
	b=200
	((d=c/b+1))
	echo "the file row is $c,the start time is $(date)"
	for n in `seq 1 $d`
	 do
		urldecode2 "`sed -n ''$a','$b'p' /application/nginx/logs/grep_access_wshop.log|awk -F '[[]+' '{print $2}'|awk -F '[]"]' '{print "["$1"] "$3}'`" >>/application/nginx/logs/urldecode_access_wshop.log
		((a=b+1))
		((b=b+200))
	done
fi
echo "the end time is $(date)"
