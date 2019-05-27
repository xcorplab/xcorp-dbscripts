USE master
GO

ALTER DATABASE SSISDB SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE SSISDB
MODIFY FILE 
( NAME = data, 
FILENAME = 'D:\DATA\SSISDB.mdf'); -- New file path
GO

ALTER DATABASE SSISDB 
MODIFY FILE 
( NAME = log, 
FILENAME = 'F:\LOG\SSISDB.ldf'); -- New file path
GO

ALTER DATABASE SSISDB SET ONLINE;
GO

SELECT name AS FileName, physical_name AS CurrentFileLocation, state_desc AS Status 
FROM sys.master_files 
WHERE database_id = DB_ID('SSISDB');