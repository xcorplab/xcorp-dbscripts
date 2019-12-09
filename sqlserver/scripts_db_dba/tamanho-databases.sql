SELECT * FROM sysdatabases;
GO

SELECT DB.name, SUM(size) * 8 AS Tamanho
FROM
	sys.databases DB
	INNER JOIN sys.master_files ON DB.database_id = sys.master_files.database_id
GROUP BY DB.name
order by Tamanho desc
