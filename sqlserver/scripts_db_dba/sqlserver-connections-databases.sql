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