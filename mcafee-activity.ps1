$servers = Get-Content "C:\servers-nrd.txt"
$source = "C:\Mcafee\McAfee.exe"
$destination = "C$\"
foreach ($server in $servers)
{
Copy-Item $source -Destination \\$server\$destination -Recurse -Force
}

