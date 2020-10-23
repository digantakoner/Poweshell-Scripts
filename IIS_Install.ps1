$servers = Get-Content "C:\Data\servers.txt"
foreach ($server in $servers)
{
Install-WindowsFeature -ConfigurationFilePath "\\srtif006\ITI_GS\ITI\02-Operations\03-Datacenter\01-Servers\01-Windows\2019\01-Scripts\Server Role Installation\BITS.xml" -ComputerName $server
}