--Determine os nomes de arquivo l�gicos do banco de dados tempdb e o seu local atual no disco.
SELECT name, physical_name AS CurrentLocation
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO

--Altere o local de cada arquivo usando ALTER DATABASE.
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, FILENAME = 'T:\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, FILENAME = 'T:\templog.ldf');
GO

--Pare e reinicie a inst�ncia do SQL Server.

--Verifique a altera��o do arquivo.
SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');

--Exclua os arquivos tempdb.mdf e templog.ldf do local original.