--use DIGITAL
--DBCC OPENTRAN
--select log_reuse_wait_desc,* from sys.databases

declare @SPID smallint = null

SELECT
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 86400 AS VARCHAR), 2) + ' ' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) % 24 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2) + '.' + 
    RIGHT('000' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) AS VARCHAR), 3) 
    AS Duration,
    A.session_id AS session_id,
	NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    B.command,
	A.[status],
    A.login_name,
	B.row_count,
	A.[host_name],
    COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
	FORMAT(COALESCE(B.cpu_time, 0), '###,###,###,###,###,###,###,##0') AS CPU,
    FORMAT(COALESCE(B.granted_query_memory, 0), '###,###,###,###,###,###,###,##0') AS used_memory,
	(CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
	TRY_CAST('<?query --' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
	COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
	COALESCE(A.open_transaction_count, 0) AS open_tran_count,
    TRY_CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
	W.query_plan,
	'KILL ' + CAST(A.session_id AS VARCHAR(10)) AS kill_command,
	(CASE WHEN D.name IS NOT NULL THEN 'SQLAgent - TSQL Job (' + D.[name] + ' - ' + SUBSTRING(A.[program_name], 67, LEN(A.[program_name]) - 67) +  ')' ELSE A.[program_name] END) AS [program_name],
	COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
	FORMAT(COALESCE(F.tempdb_allocations, 0), '###,###,###,###,###,###,###,##0') AS tempdb_allocations,
    FORMAT(COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0), '###,###,###,###,###,###,###,##0') AS tempdb_current,
    FORMAT(COALESCE(B.logical_reads, 0), '###,###,###,###,###,###,###,##0') AS reads,
    FORMAT(COALESCE(B.writes, 0), '###,###,###,###,###,###,###,##0') AS writes,
    FORMAT(COALESCE(B.reads, 0), '###,###,###,###,###,###,###,##0') AS physical_reads,
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN 'Low'
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
        WHEN B.[deadlock_priority] >= 5 THEN 'High'
    END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
    NULLIF(B.percent_complete, 0) AS percent_complete,
    H.[name] AS resource_governor_group,
    COALESCE(B.request_id, 0) AS request_id,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGE%LATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN msdb.dbo.sysjobs AS D ON RIGHT(D.job_id, 10) = RIGHT(SUBSTRING(A.[program_name], 30, 34), 10)
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGE%LATCH%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks with(nolock)
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage with(nolock)
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests with(nolock)
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.plan_handle) AS W 
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id 
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
	AND ((A.session_id = @SPID AND @SPID is not null) OR @SPID is null)
    AND (A.[status] != 'sleeping' OR (A.[status] = 'sleeping' AND A.open_transaction_count > 0))
	--AND DB_NAME(CAST(B.database_id AS VARCHAR)) in('DataPL')
	--AND DB_NAME(CAST(B.database_id AS VARCHAR)) in('CMP')
	--AND X.text like '%update dbo.ViewAndamentoProducao%'
ORDER BY
	Duration desc,
	database_name

/*
KILL 178
exec sp_who2 active
Application Name=Application Name=Aplica��o: PrintLaser - M: STP_S_CMP_RetornarDocumentoDigitalPorTarefaLote_Sup...

SELECT  DB_NAME(dbid) as DBName, 
       COUNT(dbid) as NumberOfConnections, 
       loginame as LoginName 
FROM sys.sysprocesses 
WHERE dbid > 0 
GROUP BY dbid, loginame
ORDER BY NumberOfConnections desc

SELECT 
	COUNT(dbid) as NumberOfConnections
FROM sys.sysprocesses 
WHERE dbid > 0

SELECT  DB_NAME(dbid) as DBName, *
FROM sys.sysprocesses 
WHERE DB_NAME(dbid) = 'Armazenamento'

execute spGetEntregabilidadeCMP '2018-06-11 08:49:20'

---------------------------------------------
use master
go

declare @dbname sysname

set @dbname = 'Armazenamento'

declare @spid int
select @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname)
while @spid is not null
begin
	--execute ('KILL ' + @spid)
	print ('KILL ' + cast(@spid as varchar))
	select @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname) and spid <> @spid
end
---------------------------------------------

*/

--exec sp_who2 active
--91119d6bdf53     

--ip-10-129-143-64
--ip-10-128-253-85
--ip-10-129-217-31
--ip-10-128-177-201
--ip-10-128-244-191
--ip-10-129-134-242
--ip-10-128-80-203
--ip-10-129-223-11
--ip-10-129-28-239
--ip-10-129-112-112
--ip-10-129-198-255
--ip-10-129-9-224