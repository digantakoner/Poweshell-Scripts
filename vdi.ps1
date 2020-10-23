##############Bluekeep Patch Update############
##############Created by Wintel-Team##########
##############Author: Diganta Koner ###########
##############Version:1.0#####################

########Source file for the hostname 
$vdis = Get-Content "C:\Personal Data\bluekeep\vdi.txt"

###########Source file for the update file
$source = "C:\Personal Data\bluekeep\update\update.cab"

##############Destination for the update file


$destination = "c$\"
foreach ($vdi in $vdis)
{
Copy-Item  $source -Destination \\$vdi\$destination -Recurse -Force
Invoke-Command -ComputerName $vdi -ScriptBlock {
Stop-Service -Name wuauserv
Stop-Service -Name BITS
dism.exe /online /add-package /PackagePath:c:\update.cab /norestart
#Get-HotFix -Id KB4499175 | Export-Csv -Path 'C:\Personal Data\' -NoTypeInformation -Append 
}
}
