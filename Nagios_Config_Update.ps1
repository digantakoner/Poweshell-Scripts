##############Nagios Config Update############
##############Created by Wintel-Team##########
##############Author: Diganta Koner ###########
##############Version:1.0#####################

####Source Input Computer Names
$servers = Get-Content "C:\Personal Data\computers.txt"

###New Config Path
$source = "C:\Personal Data\Nagios\NSC.ini"

###Destination Path on the Server

$destination = "C$\Program Files\NSClient++\"

foreach ($server in $servers)
{
Copy-Item  $source -Destination \\$server\$destination -Recurse -Force
Get-Service NSClientpp -ComputerName $server | Restart-Service 
Get-Service NSClientpp -ComputerName $server | Select-Object Name,Status,MachineName | Export-Csv -Path 'C:\Personal Data\list.csv' -NoTypeInformation -Append
}






