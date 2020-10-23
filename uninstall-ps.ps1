$clients = Get-Content "C:\clients.txt"
$source = "C:\CSUninstall\*"
$destination = "C$\CSUninstall"
foreach($client in $clients)
{
New-Item -Path "$client\$destination" -ItemType Directory
Copy-Item $source -Destination \\$client\$destination -Recurse -Force
Invoke-Command -ComputerName $client -ScriptBlock { Start-Process "C:\CSUninstall\Uninstall.cmd"}
}