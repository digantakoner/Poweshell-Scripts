$servers = Get-Content "C:\servers.txt"
foreach ($server in $servers)
{
Install-WindowsFeature -Name Windows-Defender -ComputerName $server
Restart-Computer -ComputerName $server -Force
}