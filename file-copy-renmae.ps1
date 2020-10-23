
$source = "\\fileshare"
$destination = "\\fileshare"
$files = Get-ChildItem -Path $destination\*.* 
$logname = "$(get-date -UFormat '%d-%m-%y-%H-%M-%S-%p')"
robocopy $source $destination /e /z /maxage:1 /log+:"C:\robocopy_test\$logname.txt"
if ((Get-ChildItem $files).CreationTime -gt (Get-Date).Date) 
{
Send-MailMessage -To "mail" -From mail -SmtpServer "ipaddress" -Subject "file transfer" -Body "Files copied. Attached the logs" -Attachments "C:\robocopy_test\$logname.txt"
}
else
{
Send-MailMessage -To "mail" -From mail -SmtpServer "ipaddress" -Subject "file transfer" -Body "Files failed to copy." -Attachments "C:\robocopy_test\$logname.txt"
}
$files1 = Get-ChildItem -Path "\\fileshare"
Get-ChildItem –Path $files -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-6))} | Remove-Item -ErrorAction SilentlyContinue