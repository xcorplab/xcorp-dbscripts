select counter_name ,cntr_value,cast((cntr_value/1024.0)/1024.0 as numeric(8,2)) as Gb
from sys.dm_os_performance_counters
where counter_name like '%server_memory%';


SELECT (COUNT(*) * 8 / 1024 / 1024) AS 'Cached Size (GB)', (((COUNT(*) * 8 / 1024 / 1024) / 4) * 300) as 'PLE'
FROM [sys].[dm_os_buffer_descriptors];

-- Exibe o PLE
SELECT cntr_value AS 'Page Life Expectancy'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Page life expectancy'

SELECT GETDATE() AS [dth_Contador],
       [object_name] AS [des_Objeto],
       [counter_name] AS [des_Contador],
       [cntr_value] AS [val_Contador],
	   (([cntr_value] / 4) * 300) AS 'PLE'
  FROM [sys].[dm_os_performance_counters]
 WHERE [object_name] LIKE '%Manager%'
       AND [counter_name] = 'Page life expectancy';


--Utilização por tipo de cache
SELECT TOP(5) 
	[type] AS [ClerkType],
	SUM(pages_kb) / 1024 AS [SizeMb]
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
GROUP BY [type]
HAVING  SUM(pages_kb) > 40000 --Só os maiores consumidores de memória
ORDER BY SUM(pages_kb) DESC

--exibe todos os pool_names
select 'DBCC freesystemcache ('+''''+name+''''+')'  from   sys.dm_os_memory_clerks group by name

--Total utilizado
SELECT  SUM(pages_kb)/1024 AS [SPA Mem, KB] FROM sys.dm_os_memory_clerks



--Custo de memória por processo
SELECT 
	session_id, 
	plan_handle,
	requested_memory_kb / 1024 as RequestedMemMb, 
	granted_memory_kb / 1024 as GrantedMemMb,
	text
FROM 
	sys.dm_exec_query_memory_grants qmg
	CROSS APPLY sys.dm_exec_sql_text(sql_handle)

--DBCC FREEPROCCACHE (0x05000C0042DC1B2E503F21BC3F02000001000000000000000000000000000000000000000000000000000000)

--SELECT plan_handle, st.text  
--FROM sys.dm_exec_cached_plans   
--CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st 


--DECLARE @BlobEater VARBINARY(8000) 
--SELECT @BlobEater = CheckIndex (ROWSET_COLUMN_FACT_BLOB) 
--FROM { IRowset 0xF022EAB907000000 } 
--GROUP BY ROWSET_COLUMN_FACT_KEY 
-->> WITH ORDER BY 
--              ROWSET_COLUMN_FACT_KEY, 
--              ROWSET_COLUMN_SLOT_ID, 
--              ROWSET_COLUMN_COMBINED_ID, 
--              ROWSET_COLUMN_FACT_BLOB 
--OPTION (ORDER GROUP)

--exibe o consumo do cache em MB por database
--jeito 1
SELECT TOP 5 DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

--jeito 2
SELECT 
	DB_NAME(database_id) AS [Database Name],
	COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors
WHERE
	database_id > 4 -- exclude system databases
	AND database_id <> 32767 -- exclude ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC;

--jeito 3
WITH Consumo_Pool_Buffer
AS
(
	SELECT
		Database_id,
		BuffersPorPagina = COUNT_BIG(*)
	FROM sys.dm_os_buffer_descriptors
	GROUP BY database_id
)
SELECT
	Database_id as DatabaseID,
	(CASE Database_id WHEN 32767
		THEN 'Recurso interno do SQL SERVER'
		ELSE DB_NAME(Database_id) END 
	)AS DatabaseName,
	BuffersPorPagina,
	(CONVERT(NUMERIC(10,2),BuffersPorPagina*8)/1024) AS BuffersPorMB
FROM Consumo_Pool_Buffer
ORDER BY BuffersPorPagina DESC, BuffersPorMB DESC

--jeito 4 - separado por objeto do banco de dados
SELECT
	DB_NAME(db_id()) DatabaseName,
	Result.ObjectName,
	COUNT(*) AS cached_pages_count,
	(COUNT(*) * 8/1024.0) AS 'Cached Size (MB)',
	index_id
FROM 
	sys.dm_os_buffer_descriptors A
	INNER JOIN
	(
		SELECT
			OBJECT_NAME(object_id) as ObjectName,
			A.allocation_unit_id,
			type_desc,
			index_id,
			rows
        FROM sys.allocation_units A, sys.partitions B
		WHERE 
			A.container_id = B.hobt_id
			AND (A.type = 1 or A.type = 3)
		UNION ALL
		SELECT
			OBJECT_NAME(object_id) as ObjectName,
			allocation_unit_id,
			type_desc,
			index_id,
			rows
		FROM 
			sys.allocation_units AS au
			INNER JOIN sys.partitions AS p ON au.container_id = p.partition_id AND au.type = 2
	
	) as Result On A.allocation_unit_id = Result.allocation_unit_id
WHERE database_id = db_id()
GROUP BY
	Result.ObjectName,
	index_id
ORDER BY cached_pages_count DESC



-- Get Resource Pool information
SELECT name AS [Resource Pool Name], cache_memory_kb/1024.0 AS [cache_memory (MB)], 
        used_memory_kb/1024.0 AS [used_memory (MB)]
FROM sys.dm_resource_governor_resource_pools;

--Limpar os buffer
DBCC FREESYSTEMCACHE('SQL Plans')
DBCC FREESYSTEMCACHE('TokenAndPermUserStore')

DBCC FREESYSTEMCACHE ('ALL') WITH MARK_IN_USE_FOR_REMOVAL;
DBCC FREEPROCCACHE WITH NO_INFOMSGS; 
DBCC FREEPROCCACHE('default');

DBCC SHOW_STATISTICS ("dbo.Movimento",Customer_LastName) WITH HISTOGRAM;
DBCC SHOW_STATISTICS ("dbo.Movimento", AK_Address_rowguid);
