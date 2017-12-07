
USE CMP  
GO

--Para habilitar o cdc no database
EXEC sys.sp_cdc_enable_db  

--Para desabilitar o cdc no database
EXEC sys.sp_cdc_disable_db 
GO

--Para habilitar o cdc na tabela
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'SituacaoDigital',  
@role_name     = NULL,  
@supports_net_changes = 1  
GO 

--Para desabilitar o cdc no database
EXECUTE sys.sp_cdc_disable_table 
    @source_schema = N'HumanResources', 
    @source_name = N'Shift',
    @capture_instance = N'HumanResources_Shift';
GO

---para selecionar os dados do cdc
DECLARE @from_lsn binary (10), @to_lsn binary (10)

SET @from_lsn = sys.fn_cdc_get_min_lsn('SituacaoDigital')
SET @to_lsn = sys.fn_cdc_get_max_lsn()

SELECT *
FROM cdc.fn_cdc_get_all_changes_SituacaoDigital(@from_lsn, @to_lsn, 'all')
ORDER BY __$seqval

SELECT * FROM cdc.dbo_SituacaoDigital_CT 

--Para saber quais tabelas estao usando cdc
USE CMP; 
GO 
EXEC sys.sp_cdc_help_change_data_capture 
GO