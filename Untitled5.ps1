$computers = Get-Content "C:\logon.txt"
foreach ($computer in $computers)
{
Get-ADComputer -Identity $computer -Properties * | Select-Object Name,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}
$pcinfo = Get-ADComputer $computer -Properties lastlogontimestamp | Select-Object Name,lastlogontimestamp #@{n="Computer";e={$_.Name}}, @{Name="Lastlogon";Expression=[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
 $lastuserlogoninfo = Get-WmiObject -Class Win32_UserProfile -ComputerName $computer | Select-Object SID
    #$SecIdentifier = New-Object System.Security.Principal.SecurityIdentifier($lastuserlogoninfo.SID)
    $username = $SecIdentifier.Translate([System.Security.Principal.NTAccount])
    $properties = @{'Computer'=$pcinfo.Computer;
                     'LastLogon'=$pcinfo.Lastlogon;
                     #'ipv4Address'=$pcinfo.ipv4Address;
                    #'OperatingSystem'=$pcinfo.OperatingSystem
                     'User'=$username.value
                    } #end $properties
     write-output (New-Object -Typename PSObject -Property $properties) | export-csv -Path "C:\logon.csv" -append -notypeinformation -encoding "unicode"   
 }
      
            