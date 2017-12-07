
exec sp_who2 active
select * from sys.dm_exec_connections
select * from master.dbo.sysprocesses where dbid = DB_ID('DIGITAL') and hostname = 'SERVER26'
select * from sys.configurations