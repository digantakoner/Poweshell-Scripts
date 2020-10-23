$computer = $env:COMPUTERNAME
$out = Invoke-Command -ComputerName $computer -ScriptBlock {quser}
foreach($line in $out)
{
if($line -match "logon time")
{
$idleStringValue = $line.SubString(54, 9).Trim().Replace('+', '.')
If ($idleStringValue -eq "none") {$idle = $null}
		#Else {$idle = [timespan]$idleStringValue}

[PSCustomObject]@{Username = $line.SubString(1, 20).Trim()
							SessionName = $line.SubString(23, 17).Trim()
							ID = $line.SubString(42, 2).Trim()
							State = $line.SubString(46, 6).Trim()
							idletime = $idle
							LogonTime = [datetime]$line.SubString(65)
}

}

}

