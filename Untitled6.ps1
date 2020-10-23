$computers = Get-Content "C:\logon.txt"
foreach ($computer in $computers)
{

#Get-ADComputer -Identity SGSCAI0243 | Select-Object Name,LastLogonTime | Export-Csv -Path "C:\test.csv" -NoTypeInformation -Append
}