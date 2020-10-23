$users = Import-Csv -Path "C:\test1\username.csv" | Select-Object -ExpandProperty SamAccountName
$result = foreach ( $user in $users)
{
$account = Get-ADUser -Filter {SamAccountName -eq $user}

if ($account){ $account | Select-Object -Property SamAccountName, enabled}

else {
[pscustomobject]@{

SamAccountName = $user
Enabled = 'Disabled'

}
}

}

$result | Export-Csv -Path "C:\test1\status.csv"

