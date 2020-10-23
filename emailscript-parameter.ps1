$source = "\\fileshare"
$files = Get-ChildItem –Path $source -Recurse 
$files1 = Get-ChildItem -Path "\\fileshare" -Recurse
$sender = "mail-id"
$to = "mail-id"
$smtp = "ip address"
$body = "Hello Everyone, `n `n Please find attached the files for today `n `n Thanks and Regards, `n  Team"
$subject = "Files Arrival -  Successful"
if($files.LastWriteTime -ge (get-date).Date)
{
Send-MailMessage -Attachments $files -From $sender -To $to -Body $body -SmtpServer $smtp -Subject $subject
}
Remove-Item -Path $source -Force -Recurse


