USE DIGITAL
CREATE ROLE devs
GO

USE DIGITAL
select 'GRANT ALTER,execute,view definition ON ['+b.name+'].['+a.name+'] TO devs'  
from
	sys.objects as a
	inner join sys.schemas b on a.schema_id = b.schema_id
where 
	a.type ='P' 
	and a.is_ms_shipped = 0
