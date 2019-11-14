USE MENSAGEM;
GO

SELECT 
	DatabaseName = DB_NAME(DB_ID()),
     TableName = t.name,
     IndexName = ind.name,
	 a.avg_fragmentation_in_percent,
     IndexId = a.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
	 RebuildIndex = 'ALTER INDEX '+ind.name+' ON '+t.name+' REBUILD;',
	 ReorganizeIndex = 'ALTER INDEX '+ind.name+' ON '+t.name+' REORGANIZE;'
     --ind.*,
     --ic.*,
     --col.* 
FROM 
	sys.indexes ind 
	INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
	INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
	INNER JOIN sys.tables t ON ind.object_id = t.object_id

	LEFT JOIN sys.dm_db_index_physical_stats (DB_ID(), null, NULL, NULL, NULL) AS a ON a.object_id = ind.object_id AND a.index_id = ind.index_id
	--LEFT JOIN sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'CallbackMensagem'), NULL, NULL, NULL) AS a ON a.object_id = ind.object_id AND a.index_id = ind.index_id
WHERE 
     ind.is_primary_key = 0 
     AND ind.is_unique = 0 
     AND ind.is_unique_constraint = 0 
     AND t.is_ms_shipped = 0 
ORDER BY 
     avg_fragmentation_in_percent desc; --t.name, ind.name, ind.index_id, ic.index_column_id;


declare @Dt_Referencia datetime
set @Dt_Referencia = cast(floor(cast( getdate()-1 as float)) as datetime)
SELECT Created, ServerName, DatabaseName, TableName, IndexName, FragmentationPercent, PageCount, FillFactorIndex, RebuildIndex, ReorganizeIndex
FROM NOTIFICACAO.dbo.IndexScanFragmetation (nolock)
WHERE 
	FragmentationPercent > 5
	AND PageCount > 1000   -- Eliminar índices pequenos
	AND cast( convert(varchar, Created, 112) as int) = cast( convert(varchar, @Dt_Referencia, 112) as int)
	and IndexName is not null
	--and IndexName = 'NotificacaoRetornoHistorico'
order by FragmentationPercent desc

/*
USE [DIGITAL]
GO
--ALTER INDEX ixIdRemessaRetorno ON Cobranca.Retorno REBUILD;
--ALTER INDEX PK_Retorno ON Cobranca.Retorno REBUILD;
ALTER INDEX ixStatusRetorno ON Cobranca.Retorno REBUILD;

USE [MENSAGEM]
GO
ALTER INDEX ALL ON RetornoOriginalNextel
REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON); 
GO

USE [NOTIFICACAO]
GO

CREATE TABLE [dbo].[IndexScanFragmetation](
	[IdIndexFragmentation] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NULL,
	[ServerName] [varchar](255) NULL,
	[DatabaseName] [varchar](255) NULL,
	[TableName] [varchar](255) NULL,
	[IndexName] [varchar](255) NULL,
	[FragmentationPercent] [float] NULL,
	[IndexId] [int] NULL,
	[PageCount] [int] NULL,
	[FillFactorIndex] [tinyint] NULL,
	[RebuildIndex] [varchar](1000) NULL,
	[ReorganizeIndex] [varchar](1000) NULL,
 CONSTRAINT [PK_IndexScanFragmetation] PRIMARY KEY CLUSTERED 
(
	[IdIndexFragmentation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT INTO NOTIFICACAO.dbo.IndexScanFragmetation ([Created],[ServerName],[DatabaseName],[TableName],[IndexName],[FragmentationPercent],[IndexId],[PageCount],[FillFactorIndex],[RebuildIndex],[ReorganizeIndex])
SELECT getdate(), @@servername,  db_name(db_id()), object_name(B.Object_id), B.Name,  avg_fragmentation_in_percent,B.index_id,page_Count,fill_factor, RebuildIndex = 'ALTER INDEX '+B.name+' ON '+object_name(B.Object_id)+' REBUILD;', ReorganizeIndex = 'ALTER INDEX '+B.name+' ON '+object_name(B.Object_id)+' REORGANIZE;'
FROM 
	sys.dm_db_index_physical_stats(db_id(),null,null,null,null) A
	join sys.indexes B on a.object_id = B.Object_id and A.index_id = B.index_id
ORDER BY object_name(B.Object_id), B.index_id
*/