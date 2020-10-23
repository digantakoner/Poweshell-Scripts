$users = Get-ADUser -Filter * -SearchBase "OU=AGSC,OU=RDI,DC=APAC,DC=CORPDIR,DC=NET" -properties samaccountname, givenname, surname, memberof
foreach($user in $users)
{
$groups = Get-ADUser -Identity $user -Properties memberof
$groups | select samaccountname,givenname,surname,@{N='Group';E={$_.MemberOf -replace 'CN=([,]+),OU=.+$','$1'}} | Export-Csv -Path "C:\test3\ad_users.csv" -NoTypeInformation -Append
}

