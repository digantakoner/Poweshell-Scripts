$vdis = Get-Content "C:\Personal Data\Scripts\SCCM\client.txt"
$source = "C:\Personal Data\Scripts\SCCM\*"
$destination = "c$\SCCM"
foreach ($vdi in $vdis)
{
New-Item -Path "\\$vdi\$destination" -ItemType Directory
Copy-Item  $source -Destination \\$vdi\$destination -Recurse -Force
Invoke-Command -ComputerName $vdi -ScriptBlock { Start-Process "C:\SCCM\Install.CMD"}
}

