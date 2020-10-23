$servers = Get-Content "C:\vul\servers.txt"
$source = "C:\vul\vulnerability.reg"
$destination = "C$"
foreach ($server in $servers)
{
Copy-Item $source -Destination \\$server\$destination -Force
sleep 3
Invoke-Command -ScriptBlock {Start-Process -FilePath "C:\windows\regedit.exe" -ArgumentList "/s C:\vulnerability.reg"} 
}
