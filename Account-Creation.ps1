$users = Import-Csv -Path "C:\test1\AGSC.csv"
foreach ($user in $users)
{
$DisplayName = $user.FirstName + " " + $user.LastName
$UserFirstname = $user.Firstname
$UserLastname = $user.Lastname
$OU = $user.OU
$SAM = $user.SAM
$Maildomain = $user.Maildomain
$UPN = $SAM + "@" + $Maildomain
$Password = $user.Password
$mail= $user.MailID
New-ADUser -Name "$SAM" -DisplayName "$SAM" -SamAccountName "$SAM" -UserPrincipalName "$UPN" -GivenName $UserFirstname -Surname $UserLastname -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path $OU -ChangePasswordAtLogon $true -AccountExpirationDate "02/24/2021" -EmailAddress $mail
}