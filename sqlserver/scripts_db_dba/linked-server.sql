execute sp_dropserver 'yoda', 'droplogins';
GO

EXEC sp_addlinkedserver
   @server=N'yoda', 
   @srvproduct=N'',
   @provider=N'SQLNCLI', 
   @datasrc=N'yoda.din.printlaser.com';
GO

EXEC sp_addlinkedsrvlogin 'yoda', 'false', 'usrRelCliente', 'usrlinkyoda', 'Gj3lryvMG8eO'

execute sp_linkedservers;
--execute sp_dropserver 'yoda', 'droplogins';


