Function New-RemoteProcessBatch {
    Param(
        [string[]]$computername=$env:computername,
        [string]$cmd=$(Throw "You must enter the full path to the command which will create the process."),
        [int]$threads
    )
    begin {
        $ErrorActionPreference="SilentlyContinue"
    }   
    process {
        foreach($computer in $computername){
            While ($(Get-Job -state Running).Count -ge $Threads) {
                Start-Sleep -Milliseconds 500
            }
            start-job -ScriptBlock {
                Param($cmd, $computer)
                $proc = Invoke-WmiMethod -computername $computer -Class Win32_Process -Name Create -ArgumentList $cmd
                while(@(get-wmiobject -class win32_process -ComputerName $computer -Filter "ProcessID='$($proc.ProcessId)'").count -gt 0){
                    start-sleep -Seconds 1
                }
                $obj = new-object psobject -Property @{
                    Computername=$computer;
                    Command = $cmd;
                    ReturnValue = $proc.ReturnValue;
                }
                write-output $obj
            } -ArgumentList $cmd, $computer
        }
    }
    end {
        get-job | wait-job | Receive-Job    
    }
} 

New-RemoteProcessBatch -computername @(get-content "C:\servers1234.txt" ) -cmd "C:\McAfee.exe --accepteula --ALL" -threads 50