USE [master]
GO


CREATE LOGIN [oswaldo.jorge] WITH PASSWORD=N'1gpiB7eN' MUST_CHANGE, DEFAULT_DATABASE=[CMP], DEFAULT_LANGUAGE=[Português (Brasil)], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [CMP]
GO
CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
GO
USE [CMP]
GO
ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
GO
USE [Armazenamento]
GO
CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
GO
USE [Armazenamento]
GO
ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
GO
--USE [DataPL]
--GO
--CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
--GO
--USE [DataPL]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
--GO
--USE [DataStageArea]
--GO
--CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
--GO
--USE [DataStageArea]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
--GO
--USE [DIGITAL]
--GO
--CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
--GO
--USE [DIGITAL]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
--GO
--USE [TPIGeral]
--GO
--CREATE USER [oswaldo.jorge] FOR LOGIN [oswaldo.jorge]
--GO
--USE [TPIGeral]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [oswaldo.jorge]
--GO



