$users = import-csv -Path "C:\Users\hussains\Desktop\glcode.csv"
foreach($user in $users)
{
$displaynName = $user.name
Get-ADUser -Filter {displayName -eq $displaynName} | Set-ADUser -Replace @{gLCode=$user.GLCode}
}