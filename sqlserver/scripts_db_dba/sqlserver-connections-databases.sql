SELECT DB_NAME(eS.database_id) AS the_database
	, eS.is_user_process
	, COUNT(eS.session_id) AS total_database_connections
FROM sys.dm_exec_sessions eS 
GROUP BY DB_NAME(eS.database_id)
	, eS.is_user_process
ORDER BY 1, 2;

SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame;

SELECT DB_NAME(sP.dbid) AS the_database
	, COUNT(sP.spid) AS total_database_connections
FROM sys.sysprocesses sP
GROUP BY DB_NAME(sP.dbid)
ORDER BY 1;

--=====================================================
--Database Connections Using dm_os_performance_counters
--=====================================================
SELECT oPC.cntr_value AS connection_count
FROM sys.dm_os_performance_counters oPC
WHERE 
	(
		oPC.[object_name] = 'SQLServer:General Statistics'
			AND oPC.counter_name = 'User Connections'
	)
ORDER BY 1;

SELECT * FROM sys.sysprocesses
WHERE 
    dbid > 0
	and loginame = 'usrportal'
	and DB_NAME(dbid) = 'DIGITAL'
	and program_name = 'DigitalAPI'
