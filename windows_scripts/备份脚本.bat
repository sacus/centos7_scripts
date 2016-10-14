@echo on
@echo 正在进行备份，请勿中断本程序......
echo 在%date%%time% 开始 >>D:\backup_local\log.txt

xcopy  D:\redis  D:\backup_local\redis\  /E /H /R /Y /I /D
xcopy  /exclude:D:\backup_local\uncopy.txt D:\sheshi  D:\backup_local\sheshi\  /E /H /R /Y /I /D
xcopy  D:\shenlun  D:\backup_local\shenlun\  /E /H /R /Y /I /D
xcopy  D:\nginx-1.9.12  D:\backup_local\nginx-1.9.12  /E /H /R /Y /I /D
xcopy  D:\apache-tomcat-7.0.39  D:\backup_local\apache-tomcat-7.0.39\ /E /H /R /Y /I /D
xcopy  D:\BAK  D:\backup_local\BAK\ /E /H /R /Y /I /D



@echo 耗时%utime%秒，数据操作完毕，正在退出......

echo 在%date%%time% 结束>>D:\backup_local\log.txt

exit