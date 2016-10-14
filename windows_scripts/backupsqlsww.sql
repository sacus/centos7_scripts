GO
DECLARE   @backupTime VARCHAR(20)  
DECLARE   
@fileName VARCHAR(1000)  

SELECT @backupTime=(CONVERT(VARCHAR(8), GETDATE(), 112) +REPLACE(CONVERT(VARCHAR(5), GETDATE(), 114), ':', ''))  
SELECT  
@fileName='D:\backup_local\sql-server-backup\DB_'+@backupTime+'.bak' 
USE ssw;
BACKUP DATABASE [ssw] TO  DISK = @fileName  WITH NOFORMAT, NOINIT,  NAME = N'ssw-���� ���ݿ� ����', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO