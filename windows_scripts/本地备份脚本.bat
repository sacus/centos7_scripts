@echo on
@echo ���ڽ��б��ݣ������жϱ�����......
echo ��%date%%time% ��ʼ >>D:\backup_local\log.txt

xcopy  D:\redis  D:\backup_local\redis\  /E /H /R /Y /I /D
xcopy  /exclude:D:\backup_local\uncopy.txt D:\sheshi  D:\backup_local\sheshi\  /E /H /R /Y /I /D
xcopy  D:\shenlun  D:\backup_local\shenlun\  /E /H /R /Y /I /D
xcopy  D:\nginx-1.9.12  D:\backup_local\nginx-1.9.12  /E /H /R /Y /I /D
xcopy  D:\apache-tomcat-7.0.39  D:\backup_local\apache-tomcat-7.0.39\ /E /H /R /Y /I /D
xcopy  D:\BAK  D:\backup_local\BAK\ /E /H /R /Y /I /D



@echo ��ʱ%utime%�룬���ݲ�����ϣ������˳�......

echo ��%date%%time% ����>>D:\backup_local\log.txt

exit