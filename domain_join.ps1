$domain = "domain-name"
$password = "password" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\username" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$computers = get-content "C:\computers.txt"
foreach($computer in $computers)
{
Add-Computer -ComputerName $computer -DomainName $domain -Credential $credential
Restart-Computer -ComputerName $computer
}



