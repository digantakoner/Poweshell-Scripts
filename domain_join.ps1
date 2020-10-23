$domain = "apac.corpdir.net"
$password = "infosys@2014cerner@2016" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\agsc_rdi_A_dikoner" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$computers = get-content "C:\computers.txt"
foreach($computer in $computers)
{
Add-Computer -ComputerName $computer -DomainName $domain -Credential $credential
Restart-Computer -ComputerName $computer
}



