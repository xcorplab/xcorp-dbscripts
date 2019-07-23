USE [master]
GO
ALTER DATABASE [DIGITAL] SET RECOVERY SIMPLE WITH NO_WAIT
GO
SELECT  DATABASEPROPERTYEX ( db_name() , 'IsPublished' )
GO
EXEC sp_repldone null, null, 0,0,1
GO
EXEC sp_removedbreplication 'DIGITAL_DEV';
GO
SELECT log_reuse_wait_desc,* from sys.databases
GO
USE [master]
GO
ALTER DATABASE [DIGITAL] SET RECOVERY FULL WITH NO_WAIT
GO
