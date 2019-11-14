create procedure [dbo].[sp_killIdleConections]
as

DECLARE @kill_id smallint
begin

    DECLARE spid_cursor CURSOR FOR

    select
        spid
        --loginame
    from master.dbo.sysprocesses 
    where 
        dbid > 4 
        and last_batch < dateadd(minute, -50, getdate())
        and dbid > 5
        and loginame <> 'abcd' -- caso seja necessário não derrubar o usuário abcd
        --and last_batch < dateadd(hour, -1, getdate()) 

    OPEN spid_cursor
    FETCH NEXT FROM spid_cursor INTO @kill_id
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        EXECUTE ('KILL ' + @kill_id) 
        FETCH NEXT FROM spid_cursor INTO @kill_id
    END
    CLOSE spid_cursor
    DEALLOCATE spid_cursor 
    
    return 1 
END
GO