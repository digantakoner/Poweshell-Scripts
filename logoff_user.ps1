$servers = Get-Content "C:\test1\servers.txt"
$scriptblock = {
try{
$sessions = quser | Where-Object {$_ -match 'agsc_rdi_A_saganta'}
$sessionids = ($sessions -split ' +')[2]
$sessionids | ForEach-Object {logoff $_}
}
catch {
         Write-Host "The user is not logged in."       
}
}
foreach ($server in $servers)
{
Invoke-Command -ComputerName $server -ScriptBlock $scriptblock
}