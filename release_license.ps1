$ComputerName = $env:COMPUTERNAME
$stringOutput = Invoke-Command -ComputerName $ComputerName -ScriptBlock {quser}
			ForEach ($line in $stringOutput) {
		If ($line -match "logon time") {

		$idleStringValue = $line.SubString(54, 9).Trim().Replace('+', '.')
		If ($idleStringValue -eq "none") {$idle = $null}
		Else {$idle = $idleStringValue}
		
		[PSCustomObject]@{Username = $line.SubString(1, 20).Trim()
							SessionName = $line.SubString(23, 17).Trim()
							ID = $line.SubString(42, 2).Trim()
							State = $line.SubString(46, 6).Trim()
							IdleTime = $idle
							#LogonTime = [datetime]$line.SubString(65)
						}
	}
}

{
$sessionid = ($sessions -split ' +')[2]
$sessionid | ForEach-Object {logoff$_}

}
quser
