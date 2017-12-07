USE [msdb]
GO

-- Bloquear criação
DENY EXECUTE ON dbo.sp_add_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_add_jobschedule TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_add_jobserver TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_add_jobstep TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_agent_add_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_agent_add_jobstep TO [Usuario_Teste2]

-- Bloquear alteração
DENY EXECUTE ON dbo.sp_update_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_update_jobschedule TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_update_category TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_update_jobstep TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_update_schedule TO [Usuario_Teste2]

-- Bloquear exclusão
DENY EXECUTE ON dbo.sp_agent_delete_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_delete_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_delete_jobschedule TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_delete_jobserver TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_delete_jobstep TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_delete_jobsteplog TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_purge_jobhistory TO [Usuario_Teste2]

-- Bloquear execução
DENY EXECUTE ON dbo.sp_agent_start_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_stop_job TO [Usuario_Teste2]
DENY EXECUTE ON dbo.sp_start_job TO [Usuario_Teste2]