/*
	:: PURPOSE
	Show the latest executed packages
	
	:: NOTES
	For the *first* package in the list, also show
	. Performance of last 15 successful executions
	. Error messages
	. Duplicate lookup messages
	. Memory allocation warnings
	. Low virtual memory warnings
	
	:: INFO
	Author:		Davide Mauri
	Version:	1.0
*/
USE SSISDB
GO

/*
	Configuration
*/

-- Filter data by project name (use % for no filter)
DECLARE @projectNamePattern NVARCHAR(100) = '%'

-- Filter data by package name (use % for no filter)
DECLARE @packageNamePattern NVARCHAR(100) = '%'

-- Filter data by execution id (use NULL for no filter)
DECLARE @executionIdFilter BIGINT = null


/*
	Implementation
*/

-- Show last 15 executions
SELECT TOP 15
	e.execution_id, 
	e.project_name,
	e.package_name,
	e.project_lsn,
	e.status, 
	status_desc = CASE e.status 
						WHEN 1 THEN 'Created'
						WHEN 2 THEN 'Running'
						WHEN 3 THEN 'Cancelled'
						WHEN 4 THEN 'Failed'
						WHEN 5 THEN 'Pending'
						WHEN 6 THEN 'Ended Unexpectedly'
						WHEN 7 THEN 'Succeeded'
						WHEN 8 THEN 'Stopping'
						WHEN 9 THEN 'Completed'
					END,
	e.start_time,
	e.end_time,
	elapsed_time_min = datediff(mi, e.start_time, e.end_time)
FROM 
	catalog.executions e 
WHERE 
	e.project_name LIKE @projectNamePattern
AND
	e.package_name LIKE @packageNamePattern
AND
	e.execution_id = ISNULL(@executionIdFilter, e.execution_id)
ORDER BY 
	e.end_time DESC
OPTION
	(RECOMPILE)
;


-- Show error messages
IF ISNULL(@executionIdFilter, 0) <> 0 
Begin
SELECT TOP 3
	* 
FROM 
	catalog.event_messages em 
WHERE 
	em.operation_id = ISNULL(@executionIdFilter, em.operation_id)
AND 
	em.event_name = 'OnError'
ORDER BY 
	em.event_message_id DESC
;
End