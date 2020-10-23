##############################Hostname Deletion####################################
##############################Version 1.0##########################################
##############################Created by Wintel Team###############################


##Populate the hostnames from a text file########
####Change the file path according to the directory structure#####
$desktops = Get-Content "C:\Users\agsc_rdi_a_dikoner\Desktop\desktop.txt"

######Function loop#######
foreach($desktop in $desktops)
{
Remove-ADComputer -Identity $desktop -Confirm:$false
}