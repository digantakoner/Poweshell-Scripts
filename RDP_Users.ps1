$Output = "C:\rdg\test1.txt"
$Servers= Get-Content "C:\rdg\servers.txt"
$ScriptBlock = {
    Get-WmiObject Win32_GroupUser -ComputerName $Using:ServerName |
    Where GroupComponent –like '*"Remote Desktop Users"'|
    ForEach-Object {  
        If($_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$"){  
            $matches[1].trim('"') + "\" + $matches[2].trim('"')
        }
    }
}
ForEach ($ServerName in $Servers) {
    "Local Admin group members in $ServerName" | Out-File $Output -Append
    Invoke-command -ScriptBlock $ScriptBlock -ComputerName $ServerName | Out-File $Output -Append
}