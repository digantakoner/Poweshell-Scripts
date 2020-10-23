$source = "\\fileshare"
$files = Get-ChildItem –Path $source -Recurse -Exclude "filter" | Where-Object {($_.LastWriteTime -ge (Get-Date).Date)} 
$sender = "mail-id"
$to = "mail-id"
$smtp = "ip address"
$body = "Hello Everyone, `n `n Please find attached the files for today `n `n Thanks and Regards `n  Team"
$subject = "Files Arrival -  Successful"
if($files.LastWriteTime -ge (get-date).Date)
{
Send-MailMessage -Attachments $files -From $sender -To $to -Body $body -SmtpServer $smtp -Subject $subject
}
else
{
Send-MailMessage -Subject "Files Arrival - Failure" -From $sender -to $to -Body "Hello Everyone, `n `n No files have arrived for today `n `n Thanks and Regards `n MBRDI Wintel Team"  -SmtpServer $smtp
}
Remove-Item -Path $source -Force -Recurse


