$servers = Get-Content 'C:\Computers.txt'
ForEach ($server in $servers)
{   
    Invoke-Command -ComputerName $server -ScriptBlock {"rescan" | diskpart}   
    $MaxSize = (invoke-command -ComputerName $server -ScriptBlock { Get-PartitionSupportedSize -DriveLetter c }).sizeMax
    invoke-command -ComputerName $server -ScriptBlock {Resize-Partition -DriveLetter c -Size $using:MaxSize}
}