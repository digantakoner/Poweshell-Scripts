#$source = "\\fileshare\*.*"
$destination = "C:\test1"
$destination1 = "C:\test2"
#Copy-Item $source -Filter "3855*" $destination
#Get-ChildItem $destination -Recurse| Rename-Item -NewName  {[string]($_.name).substring(0,26) + [string]($_.name).substring(34,9) +'.txt'}
#$files = Get-ChildItem -Path $destination\*.* 
#if ((Get-ChildItem $files).CreationTime -gt (Get-Date).Date) 
#{
#robocopy "C:\test1" "C:\test2" /e /z /maxage:1 /log+:"C:\robocopy_test\logs.txt"
#}
#else
#{
#Send-MailMessage -To "mail.com" -From mail.com -SmtpServer "ip" -Subject "QA MT940 files-failure" -Body "Files failed"
#}

$logname = "$(get-date -UFormat '%d-%m-%y-%H-%M-%S-%p')"
robocopy $destination $destination1 /e /z /maxage:1 /log+:"C:\robocopy_test\$logname.txt"
Send-MailMessage -to mail -From mail -Subject "test" -SmtpServer "ipaddress" -Attachments "C:\robocopy_test\$logname.txt"