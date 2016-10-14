@echo on
@echo 正在进行备份，请勿中断本程序......
echo 在%date%%time% 开始 >>D:\backup_local\rsync_backup_log.txt

rsync -avz  --port=18730 /cygdrive/d/backup_local rsync_backup@183.251.100.207::backup --password-file=/cygdrive/d/backup_local/rsync.password

@echo 耗时%utime%秒，数据操作完毕，正在退出......

echo 在%date%%time% 结束>>D:\backup_local\rsync_backup_log.txt

exit
