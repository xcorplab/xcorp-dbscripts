--https://docs.microsoft.com/pt-br/sql/relational-databases/security/auditing/sql-server-audit-database-engine

select * from sys.database_audit_specifications
select * from sys.database_audit_specification_details

select * from sys.server_audits
select * from sys.server_audit_specifications
select * from sys.server_audit_specifications_details
select * from sys.server_file_audits


--CREATE SERVER AUDIT SPECIFICATION HIPPA_Audit_Specification  
--FOR SERVER AUDIT HIPPA_Audit  
--    ADD (FAILED_LOGIN_GROUP);  
--GO


