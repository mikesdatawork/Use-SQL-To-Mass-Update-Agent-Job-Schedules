use master;
set nocount on
 
-- update job to run every night at 12:00am excluding saturday night, sunday night, and monday night.
declare @update_job_schedule    varchar(max)
set     @update_job_schedule    = ''
select  @update_job_schedule    = @update_job_schedule +
'use msdb;' + char(10) +
'exec msdb.dbo.sp_attach_schedule @job_id=''' + cast(sj.job_id as varchar(255)) + ''',@schedule_id=' + cast(sjsched.schedule_id as varchar(255)) + char(10) + 
'exec msdb.dbo.sp_update_schedule @schedule_id=' + cast(sjsched.schedule_id as varchar(255)) + ', @freq_interval=124' + char(10)
from
    msdb..sysjobs sj join msdb..sysjobsteps sjs on sj.job_id = sjs.job_id
    join msdb..sysjobschedules sjsched on sj.job_id = sjsched.job_id
where
    sj.name = 'SEND SQL BACKUP ALERTS'  --> put your job name here.
 
exec    (@update_job_schedule)

