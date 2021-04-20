$servers = Get-Content "C:\servers.txt"
$source = "C:\scep\scepinstall.exe"
$destination = "C$\"
foreach ($server in $servers)
{
Copy-Item $source -Destination \\$server\$destination -Recurse -Force
}


