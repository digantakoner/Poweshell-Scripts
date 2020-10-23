$users = Get-Content "C:\users.txt"
foreach($user in $users)
{
#Get-ADUser -SearchBase "OU=_GlobalResources,OU=AGSC,DC=apac,DC=corpdir,DC=net"   | FT Name,SamAccountName -AutoSize
#Get-ADUser -Identity $user -Properties “LastLogonDate” | Export-Csv "C:\user.csv" -Append -NoTypeInformation
Set-ADUser -Identity $user -Enabled $false
} 