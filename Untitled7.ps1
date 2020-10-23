$computers = Get-Content "C:\logon.txt"
foreach ($computer in $computers){
Get-Process | Select-Object -Property username -Unique #| Where-Object { $_ -notmatch 'SYSTEM|admin' }
#Get-WinEvent -Computer $computer -FilterHashtable @{Logname='Security';ID=4672} -MaxEvents 1 | Select @{N='User';E={$_.Properties[1].Value}},TimeCreated | Export-Csv -Path "C:\logon.csv" -NoTypeInformation -Append
}

