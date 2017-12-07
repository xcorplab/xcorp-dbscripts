SELECT  
(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
process_physical_memory_low,  
process_virtual_memory_low  
FROM sys.dm_os_process_memory;


--sp_configure 'show advanced options', 1

--RECONFIGURE

--sp_configure 'min server memory', 1

--sp_configure 'max server memory', 46080

--EXEC sp_configure 'max degree of parallelism', 4;
--GO  
--RECONFIGURE WITH OVERRIDE;