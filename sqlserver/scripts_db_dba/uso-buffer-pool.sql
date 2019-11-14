SELECT 
	CASE WHEN database_id = 32767 THEN 'ResourceDB' ELSE DB_NAME(database_id) END AS DatabaseName,
	COUNT(*) AS cached_pages,
	(COUNT(*) * 8.0) / 1024 AS MBsInBufferPool,
	(COUNT(*) * 8.0) / power(1024,2) AS GBsInBufferPool
FROM
	sys.dm_os_buffer_descriptors
GROUP BY
	database_id
ORDER BY
	MBsInBufferPool DESC
GO


--CBDCC DROPCLEANBUFFERS
--(OBS) Esvaziar a area de buffer executando o comando CBDCC DROPCLEANBUFFERS vai aumentar a carga sobre os discos e diminuir o desempenho até que o cache encha novamente.


execute sp_configure


SELECT 
  physical_memory_in_use_kb/1024 AS sql_physical_memory_in_use_MB, 
    large_page_allocations_kb/1024 AS sql_large_page_allocations_MB, 
    locked_page_allocations_kb/1024 AS sql_locked_page_allocations_MB,
    virtual_address_space_reserved_kb/1024 AS sql_VAS_reserved_MB, 
    virtual_address_space_committed_kb/1024 AS sql_VAS_committed_MB, 
    virtual_address_space_available_kb/1024 AS sql_VAS_available_MB,
    page_fault_count AS sql_page_fault_count,
    memory_utilization_percentage AS sql_memory_utilization_percentage, 
    process_physical_memory_low AS sql_process_physical_memory_low, 
    process_virtual_memory_low AS sql_process_virtual_memory_low
FROM sys.dm_os_process_memory; 