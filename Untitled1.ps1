$servers = Get-Content "C:\os\servers.txt"
foreach ($server in $servers) 
{
Get-WMIObject win32_operatingsystem -ComputerName $server | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName| Export-Csv -Path 'C:\os\details.csv' -NoTypeInformation  -Append
}