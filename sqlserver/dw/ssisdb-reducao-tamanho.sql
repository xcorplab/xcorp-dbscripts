use SSISDB
go

--Step-1: Update the retention values from 365 to 3 days or whatever old history you want to keep.
select * from [SSISDB].[catalog].[catalog_properties]
--update [SSISDB].[catalog].[catalog_properties]
--set property_value = 5
--where property_name = 'RETENTION_WINDOW'

--Step-2 Alter procedure SSISDB.[internal].[cleanup_server_retention_window]
--SET @delete_batch_size = 1000
--instead of 10, in case if your DB size grown more than 10 GB.

--Step-3: Run the below query to Compress the tables data.
alter table [internal].[event_messages] rebuild partition = all with (data_compression = page)
alter table [internal].[operation_messages] rebuild partition = all with (data_compression = page)
alter table [internal].[execution_component_phases] rebuild partition = all with (data_compression = page)
alter table [internal].[execution_data_statistics] rebuild partition = all with (data_compression = page)

--Step-4: Then using below queries Shrink the database if size is more than 10 GB.
dbcc shrinkdatabase(N'ssisdb' )
GO