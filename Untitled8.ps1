$computerList = Get-Content "C:\logon.txt"
foreach ($computer in $computer){

function Get-LastLoggedOnUser($computerName)
{
    Get-WmiObject Win32_NetworkLoginProfile -Computer $computerName |
    Sort -Descending LastLogon |
    Select * -First 1 |
    ? {$_.LastLogon -match "(\d{14})"} |
        % {
            New-Object PSObject -Property @{
                Name=$_.Name ;
                LastLogon=[datetime]::ParseExact($matches[0], "yyyyMMddHHmmss", $null)
            }
      }
}

foreach($computer in $computerList)
{
    $userList += Get-LastLoggedOnUser -computerName $computer  
}

}
$userList | Export-Csv -Path "C:\test.csv" -NoTypeInformation -Append