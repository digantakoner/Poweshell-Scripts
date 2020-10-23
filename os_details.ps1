$servers = Get-Content "C:\Personal Data\OS Details\servers.txt"
foreach ($server in $servers) 
{
Get-WMIObject win32_operatingsystem -ComputerName $server | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName| Export-Csv -Path 'C:\Personal Data\OS Details\details.csv' -NoTypeInformation  -Append
}