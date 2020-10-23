#$source = "\\fileshare"
$destination = "C:\test2"
$files = Get-ChildItem -Path $destination\*.* 
#robocopy $source $destination /e /z /maxage:3 /log+:"C:\robocopy_test\sap_log.txt"
if ((Get-ChildItem $files).CreationTime -le (Get-Date).Date) 
{
Send-MailMessage -To "mailid" -From mailid -SmtpServer "ip address" -Subject "file transfer" -Body "Files copied. Attached the logs" #-Attachments "C:\robocopy_test\sap_log.txt"
}
else
{
Send-MailMessage -To "mailid" -From mailid -SmtpServer "ip address" -Subject "file transfer" -Body "Files failed to copy." #-Attachments "C:\robocopy_test\sap_log.txt"
}
$files1 = Get-ChildItem -Path "C:\test2\*.*"
$x = Get-ChildItem –Path $files -Recurse | Where-Object {($_.LastWriteTime -le (Get-Date).AddDays(-6))} | Remove-Item -Recurse -Force