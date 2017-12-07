use DIGITAL
go

--sys.dm_cdc_log_scan_sessions
--sys.sp_MScdc_capture_job
--sys.sp_MScdc_cleanup_job
DECLARE
	@Databasename varchar(50) = 'Digital',
	@SPID int = 55
exec sp_who2 @SPID
--
SELECT
	L.request_session_id AS SPID,
    DB_NAME(L.resource_database_id) AS DatabaseName,
    O.Name AS LockedObjectName,
    P.object_id AS LockedObjectId,
    L.resource_type AS LockedResource,
    L.request_mode AS LockType,
    ST.text AS SqlStatementText,
    ES.login_name AS LoginName,
    ES.host_name AS HostName,
    TST.is_user_transaction as IsUserTransaction,
    AT.name as TransactionName,
    CN.auth_scheme as AuthenticationMethod
FROM
	sys.dm_tran_locks L
	JOIN sys.partitions P ON P.hobt_id = L.resource_associated_entity_id
	JOIN sys.objects O ON O.object_id = P.object_id
	JOIN sys.dm_exec_sessions ES ON ES.session_id = L.request_session_id
	JOIN sys.dm_tran_session_transactions TST ON ES.session_id = TST.session_id
	JOIN sys.dm_tran_active_transactions AT ON TST.transaction_id = AT.transaction_id
	JOIN sys.dm_exec_connections CN ON CN.session_id = ES.session_id
	CROSS APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) AS ST
WHERE
	resource_database_id = db_id()
ORDER BY
	L.request_session_id

--Relação de IPs conectados ao SQL Server 
SELECT
	ec.client_net_address,
	es.[program_name],
	es.[host_name],
	es.login_name,
	es.database_id,
	DB_NAME(es.database_id) as database_name,
	es.authenticating_database_id,
	DB_NAME(es.authenticating_database_id) as authenticating_database_name
FROM
	sys.dm_exec_sessions AS es 
	INNER JOIN sys.dm_exec_connections AS ec ON es.session_id = ec.session_id
where
	es.[program_name] <> 'RdsAdminService'
	and ((DB_NAME(es.database_id) = @Databasename AND @Databasename IS NOT NULL) OR (@Databasename IS NULL))
ORDER BY 
	ec.client_net_address,
	es.[program_name]

--Commands Text scripts em execução
SELECT
	s.session_id, 
	r.status, 
	r.blocking_session_id as 'Blk by', 
	r.wait_type, 
	wait_resource, 
	r.wait_time / (1000.0) as 'Wait Sec', 
	r.cpu_time, 
	r.logical_reads, 
	r.reads, 
	r.writes, 
	r.total_elapsed_time / (1000.0) as 'Elaps Sec', 
	Substring(st.TEXT,(r.statement_start_offset / 2) + 1, 
			((CASE r.statement_end_offset 
				WHEN -1 
				THEN Datalength(st.TEXT) 
				ELSE r.statement_end_offset 
				END - r.statement_start_offset) / 2) + 1) AS statement_text, 
    Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid,st.dbid)) + N'.' + Quotename(Object_name(st.objectid,st.dbid)), '') AS command_text, 
    r.command, 
    s.login_name, 
    s.host_name, 
    s.program_name, 
    s.last_request_end_time, 
    s.login_time, 
    r.open_transaction_count 
FROM
	sys.dm_exec_sessions AS s 
    JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
    CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st
WHERE
	r.session_id = @SPID --@@SPID
ORDER BY
	r.cpu_time desc, r.status, 
    r.blocking_session_id, 
    s.session_id 