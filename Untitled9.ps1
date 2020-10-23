Get-ADComputer -Filter * -Properties * -SearchBase "OU=AGSC, DC=apac, DC=corpdir, DC=net" | Select-Object Name, OperatingSystem | Export-Csv -Path C:\wsus.csv -NoTypeInformation -Append
