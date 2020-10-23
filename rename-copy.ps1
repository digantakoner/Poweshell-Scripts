$source = "\\fileshare"

Copy-Item $source -Filter "filter" $destination
Get-ChildItem $destination -Recurse| Rename-Item -NewName  {[string]($_.name).substring(0,26) + [string]($_.name).substring(34,9) +'.txt'}


$source = "\\fileshare"
$destination = "\\fileshare"
$files = Get-ChildItem -Path $destination\*.* 
$logname = "$(get-date -UFormat '%d-%m-%y-%H-%M-%S-%p')"
robocopy $source $destination /e /z /maxage:1 /log+:"C:\robocopy_test\$logname.txt"
if ((Get-ChildItem $files).CreationTime -gt (Get-Date).Date) 
{
Send-MailMessage -To "mailid" -From mailid -SmtpServer "ipaddress" -Subject "file transfer" -Body "Files copied. Attached the logs" -Attachments "C:\robocopy_test\$logname.txt"
}
else
{
Send-MailMessage -To "mailid" -From mailid -SmtpServer "ip address" -Subject "file transfer" -Body "Files failed to copy." -Attachments "C:\robocopy_test\$logname.txt"
}