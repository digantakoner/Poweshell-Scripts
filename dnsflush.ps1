$Computerlist = get-content "C:\scomlist.txt"
foreach ($servers in $Computerlist) {

Invoke-WmiMethod -class Win32_process -Name Create  -ArgumentList ("cmd.exe /c ipconfig /flushdns") -ComputerName $servers
}