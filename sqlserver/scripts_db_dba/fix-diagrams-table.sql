DROP TABLE dbo.sysdiagrams;
GO
CREATE TABLE [dbo].[sysdiagrams]
(
    [name] [sysname] NOT NULL,
    [principal_id] [int] NOT NULL,
    [diagram_id] [int] IDENTITY(1,1) PRIMARY KEY,
    [version] [int] NULL,
    [definition] [varbinary](max) NULL,
    CONSTRAINT [UK_principal_name] UNIQUE ([principal_id],[name])
);

GO
EXEC sys.sp_addextendedproperty 
  @name=N'microsoft_database_tools_support', 
  @value=1 , 
  @level0type=N'SCHEMA',
  @level0name=N'dbo', 
  @level1type=N'TABLE',
  @level1name=N'sysdiagrams';
GO