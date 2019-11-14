
CREATE USER bigdata
	FOR LOGIN bigdata
	WITH DEFAULT_SCHEMA = dbo
GO

-- Add user to the database owner role
EXEC sp_addrolemember N'db_datareader', N'bigdata'
GO
--https://docs.microsoft.com/pt-br/sql/relational-databases/system-stored-procedures/sp-addsrvrolemember-transact-sql?view=sql-server-2017

SELECT dp.name , us.name  
FROM sys.sysusers us right 
JOIN  sys.database_role_members rm ON us.uid = rm.member_principal_id
JOIN sys.database_principals dp ON rm.role_principal_id =  dp.principal_id

select * from sys.sysusers us