$computers = Get-Content "C:\logon.txt"
$data = "C:\details.csv"
$v3 = @()
foreach ($computer in $computers)
{
$properties = @{
$v1 = Get-CimInstance –ComputerName $computer –ClassName Win32_ComputerSystem | Select-Object 
$v2 = Get-ADComputer -Identity $computer -Properties lastlogontimestamp | ft Name, LastLogonDate -AutoSize
}
$v3 += New-Object psobject -Property $properties
}
$v3 | Select-Object Name, LastLogonDate, UserName | Export-Csv -Path $data -NoTypeInformation -Append