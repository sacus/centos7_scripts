#!/bin/bash
date_1=`date -d "-1 day" +%d/%b/%Y`
date_2=`date +%d/%b/%Y`
a_time=${date_1}:00:00:00
b_time=${date_1}:23:59:59
alias urldecode2='python -c "import sys,urllib as u1; print u1.unquote_plus(sys.argv[1])"'
urldecode2 "`/usr/bin/grep "GET /log" /application/nginx/logs/access_wshop.xingou.net.cn.log|awk -F '[ []+' '{if ($4 >="'${a_time}'" && $4 <="'${b_time}'") print $0}'|awk -F '"'  '{print $2}'`"  >>/application/nginx/logs/urldecode_access_wshop1.log
