@echo on
@echo ���ڽ��б��ݣ������жϱ�����......
echo ��%date%%time% ��ʼ >>D:\backup_local\rsync_backup_log.txt

rsync -avz  --port=18730 /cygdrive/d/backup_local rsync_backup@183.251.100.207::backup --password-file=/cygdrive/d/backup_local/rsync.password

@echo ��ʱ%utime%�룬���ݲ�����ϣ������˳�......

echo ��%date%%time% ����>>D:\backup_local\rsync_backup_log.txt

exit
