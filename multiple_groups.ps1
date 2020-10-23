$servers = Get-Content "C:\test1\Computers.txt"
$users = Get-Content "C:\test1\users.txt"
$GroupName = "Administrators"
$domainname = "apac.corpdir.net"
foreach($server in $servers)
{
foreach($user in $users)
{
$Group =[ADSI]"WinNT://$server/$GroupName,group"
$User = [ADSI]"WinNT://$domainname/$User,user"
$Group.Add($User.Path)
}
}


