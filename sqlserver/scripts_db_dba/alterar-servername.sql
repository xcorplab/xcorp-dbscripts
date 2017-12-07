SELECT * FROM master.dbo.sysservers
SELECT SERVERPROPERTY('ServerName')

DECLARE @ServerName NVARCHAR(128) = CONVERT(sysname, SERVERPROPERTY('servername'));
--select @ServerName
--EXEC sp_addserver @ServerName, 'local';
EXEC sp_dropserver 'PLSP0180';  
EXEC sp_addserver @ServerName, 'local';

SELECT @@SERVERNAME AS 'Server Name';
