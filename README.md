![MIKES DATA WORK GIT REPO](https://raw.githubusercontent.com/mikesdatawork/images/master/git_mikes_data_work_banner_01.png "Mikes Data Work")        

# Use SQL To Mass Update Agent Job Schedules 
**Post Date: September 14, 2015**





## Contents    
- [About Process](##About-Process)  
- [SQL Logic](#SQL-Logic)  
- [Build Info](#Build-Info)  
- [Author](#Author)  
- [License](#License)       

## About-Process

<p>Here's some logic I wrote up which allows you to update a particular Job schedule across multiple servers. It's designed to find the Job, Pull the Job ID and Schedule ID for that particular Job (provided is has only one schedule attached to it), then it updates it to run nightly excluding Saturday Night, Sunday Night. The Jobs runs at 12:00am (midnight). it does run on Saturday, but remember 12:00am on Saturday is the first hour of the day so what happens is the Job is checking the backups from the night before (Friday Night). You don't need to check backups for the weekends because that's the maintenance window where backups are typically not taken.
</p>    


## SQL-Logic
```SQL
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

```

[![WorksEveryTime](https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](https://shitday.de/)

## Build-Info

| Build Quality | Build History |
|--|--|
|<table><tr><td>[![Build-Status](https://ci.appveyor.com/api/projects/status/pjxh5g91jpbh7t84?svg?style=flat-square)](#)</td></tr><tr><td>[![Coverage](https://coveralls.io/repos/github/tygerbytes/ResourceFitness/badge.svg?style=flat-square)](#)</td></tr><tr><td>[![Nuget](https://img.shields.io/nuget/v/TW.Resfit.Core.svg?style=flat-square)](#)</td></tr></table>|<table><tr><td>[![Build history](https://buildstats.info/appveyor/chart/tygerbytes/resourcefitness)](#)</td></tr></table>|

## Author

[![Gist](https://img.shields.io/badge/Gist-MikesDataWork-<COLOR>.svg)](https://gist.github.com/mikesdatawork)
[![Twitter](https://img.shields.io/badge/Twitter-MikesDataWork-<COLOR>.svg)](https://twitter.com/mikesdatawork)
[![Wordpress](https://img.shields.io/badge/Wordpress-MikesDataWork-<COLOR>.svg)](https://mikesdatawork.wordpress.com/)


    
## License
[![LicenseCCSA](https://img.shields.io/badge/License-CreativeCommonsSA-<COLOR>.svg)](https://creativecommons.org/share-your-work/licensing-types-examples/)

![Mikes Data Work](https://raw.githubusercontent.com/mikesdatawork/images/master/git_mikes_data_work_banner_02.png "Mikes Data Work")

