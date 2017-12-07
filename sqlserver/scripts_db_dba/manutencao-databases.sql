USE master SELECT name, physical_name FROM sys.master_files WHERE database_id = DB_ID('Armazenamento');

ALTER DATABASE Armazenamento SET offline
ALTER DATABASE Armazenamento MODIFY FILE ( NAME = Armazenamento_log, FILENAME = 'F:\LOG\Armazenamento_log.ldf')
ALTER DATABASE Armazenamento SET online

exec sp_who2 active

ALTER DATABASE DIGITAL
SET MULTI_USER;
GO