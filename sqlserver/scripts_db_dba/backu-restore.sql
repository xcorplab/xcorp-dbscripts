exec msdb.dbo.rds_backup_database 
        @source_db_name='DIGITAL',
        @s3_arn_to_backup_to='arn:aws:s3:::rds-backup-pl/DIGITAL.bak',
        @overwrite_S3_backup_file=1;

exec msdb.dbo.rds_restore_database 
        @restore_db_name='DIGITAL', 
        @s3_arn_to_restore_from='arn:aws:s3:::rds-backup-pl/PL_Portal21062017.bak';


exec msdb.dbo.rds_task_status @db_name='DIGITAL'

exec sp_who2 active


--EXEC rdsadmin.dbo.rds_set_database_online DIGITAL




