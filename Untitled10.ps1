$vdis = Get-Content "C:\dism.txt"

###########Source file for the update file
#$source = "C:\Personal Data\bluekeep\update\update.cab"

##############Destination for the update file


#$destination = "c$\"
foreach ($vdi in $vdis)
{
#Copy-Item  $source -Destination \\$vdi\$destination -Recurse -Force
#Invoke-Command -ComputerName $vdi -ScriptBlock {
##Stop-Service -Name wuauserv
#Stop-Service -Name BITS
dism.exe /online /get-package | Export-Csv -Path C:\dism.csv #/PackagePath:c:\update.cab /norestart
#Get-HotFix -Id KB4499175 | Export-Csv -Path 'C:\Personal Data\' -NoTypeInformation -Append 
}
#}
