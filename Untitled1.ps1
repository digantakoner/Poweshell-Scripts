$servers = Get-Content "C:\servers123.txt"
$source = "C:\KB4056890.cab"
$destination = "C$\"
foreach ($server in $servers)
{
Copy-Item $source -Destination \\$server\$destination
}

Invoke-Command -ScriptBlock {dism /online /add-package /packagepath:"C:\KB4056890.cab"} -ComputerName (Get-Content "C:\servers123.txt") 