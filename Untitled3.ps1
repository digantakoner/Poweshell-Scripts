$computers = Get-Content "C:\clients.txt"
foreach ($computer in $computers)
{
Get-ADComputer -Identity $computer -Properties * | Select-Object Name, LastLogonDate | Export-Csv -Path "C:\logon.csv" -NoTypeInformation -Append
}

#get-aduser -filter * -properties LastLogonDate,MemberOf,DisplayName | Select-Object SamAccountName,DisplayName,@{Name="memberOf";Expression{$_.memberof}} | Export-Csv 


#Get-CimInstance –ComputerName CLIENT1 –ClassName Win32_ComputerSystem | Select-Object UserName


$computers = Get-Content "C:\logon.txt"
$data = "C:\details.csv"
$v3 = @()
foreach ($computer in $computers)
{
$properties = @{
$v1 = Get-CimInstance –ComputerName $computer –ClassName Win32_ComputerSystem | ft UserName -AutoSize
$v2 = Get-ADComputer -Identity $computer -Properties * | ft Name, LastLogonDate -AutoSize
}
$v3 += New-Object psobject -Property $properties
}
$v3 | Select-Object Name, LastLogonDate, UserName | Export-Csv -Path $data -NoTypeInformation -Append