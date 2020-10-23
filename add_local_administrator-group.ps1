$servers = Get-Content "C:\computers.txt"
$users = Get-Content "C:\users.txt"
$group = "Administrators"
foreach ($server in $servers)
{
$objOU = [ADSI]"WinNT://$server"
$ObjGroup = [ADSI]"WinNT://$server/$group,group"
foreach($user in $users)
{
$ObjGroup.Add("WinNt://$user,user")
}
}





