/*
If you have SCOM deployed in your environment it must be already capturing free space of local & cluster disk. 
This is a T-SQL script which fetch the data from System Center Operation Manager database. It list Server Name , Drive Letter, Free Space, DateTime (MAX TimeSampled value), Rule Name.

This script will run on OperationManager Database.

It is divided into three parts to check free disk space for Client Desktop, Local drive & Cluster drive.

To list free space less than specific threshold value or for any specific Server\Client Desktop uncomment below rows

--AND SampleValue < 20 /* To list drive having less than 20 percentage */
--and bme.Path ='Server Name' /* add FQDN for specific Client Desktop */

You can also configure SSRS reports using this script. Add drop down to get detail for specifc server or for OS C Drive only, etc depending upon your requirement.

Author  : Abhijit Singh
Requires : SCOM to be deployed in your environment

Last updated 4 December,2015

*/

/* Server Local Disk */
SELECT bme.Path as ServerName, ps.PerfmonInstanceName as DriveLetter, ROUND(pdav.SampleValue,0) as FreeSpace, pdav.TimeSampled as DateTime, r.RuleName into #SCOM1
FROM PerformanceDataAllView (NOLOCK) AS pdav  
INNER JOIN PerformanceSource (NOLOCK) ps ON pdav.PerformanceSourceInternalId = ps.PerformanceSourceInternalId 
INNER JOIN Rules (NOLOCK) r ON ps.RuleId = r.RuleId 
INNER JOIN BaseManagedEntity (NOLOCK) bme ON ps.BaseManagedEntityID = bme.BaseManagedEntityID 
WHERE r.RuleName like 'Microsoft.Windows.Server.%%.LogicalDisk.FreeSpace.Collection'
AND pdav.TimeSampled = (SELECT MAX(TimeSampled) FROM PerformanceDataAllView WHERE PerformanceSourceInternalId = pdav.PerformanceSourceInternalId )
--AND SampleValue < 20 /* To list drive having less than 20 percentage */
--and bme.Path ='Server Name' /* add FQDN for specific server */
ORDER BY path,PerfmonInstanceName

/* Server Cluster Disk */
SELECT bme.Path as ServerName, ps.PerfmonInstanceName as DriveLetter, ROUND(pdav.SampleValue,0) as FreeSpace, pdav.TimeSampled as DateTime, r.RuleName into #SCOM2
FROM PerformanceDataAllView (NOLOCK) AS pdav  
INNER JOIN PerformanceSource (NOLOCK) ps ON pdav.PerformanceSourceInternalId = ps.PerformanceSourceInternalId 
INNER JOIN Rules (NOLOCK) r ON ps.RuleId = r.RuleId 
INNER JOIN BaseManagedEntity (NOLOCK) bme ON ps.BaseManagedEntityID = bme.BaseManagedEntityID 
WHERe r.RuleName ='Microsoft.Windows.Server.ClusterDisksMonitoring.ClusterDisk.Monitoring.CollectPerfDataSource.FreeSpacePercent'
AND pdav.TimeSampled = (SELECT MAX(TimeSampled) FROM PerformanceDataAllView WHERE PerformanceSourceInternalId = pdav.PerformanceSourceInternalId )
--AND SampleValue < 20 /* To list drive having less than 20 percentage */
--and bme.Path ='Server Name' /* add FQDN for specific server */
ORDER BY path,PerfmonInstanceName

/* Client Desktop */
SELECT bme.Path as ServerName, ps.PerfmonInstanceName as DriveLetter, ROUND(pdav.SampleValue,0) as FreeSpace, pdav.TimeSampled as DateTime, r.RuleName into #SCOM3
FROM PerformanceDataAllView (NOLOCK) AS pdav  
INNER JOIN PerformanceSource (NOLOCK) ps ON pdav.PerformanceSourceInternalId = ps.PerformanceSourceInternalId 
INNER JOIN Rules (NOLOCK) r ON ps.RuleId = r.RuleId 
INNER JOIN BaseManagedEntity (NOLOCK) bme ON ps.BaseManagedEntityID = bme.BaseManagedEntityID 
WHERE r.rulename like 'Microsoft.Windows.Client.%%.LogicalDisk.FreeSpace.Collection'
AND pdav.TimeSampled = (SELECT MAX(TimeSampled) FROM PerformanceDataAllView WHERE PerformanceSourceInternalId = pdav.PerformanceSourceInternalId )
--AND SampleValue < 20 /* To list drive having less than 20 percentage */
--and bme.Path ='Server Name' /* add FQDN for specific Client Desktop */
ORDER BY path,PerfmonInstanceName

select * from #SCOM1
union all
select * from #SCOM2
union all
select * from  #SCOM3 

drop table #SCOM1
drop table #SCOM2
drop table #SCOM3