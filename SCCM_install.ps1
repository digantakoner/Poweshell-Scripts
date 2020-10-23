$VerbosePreference =   "Continue"
$Computers         =   Get-Content "C:\Data\SCCM\servers.txt"
foreach ($ComputerName in $Computers){
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            if (Test-Path 'C:\windows\CCM'){
                Write-Output  "$env:ComputerName  : Script is Running"
                get-service ccmexec  -ea SilentlyContinue | 
                Stop-Service -Force -Verbose
                Remove-Item -Path "$($Env:WinDir)\CCM" -Force  -Confirm:$false -Verbose 
                Remove-Item -Path "$($Env:WinDir)\CCMSetup" -Force -Confirm:$false  -Verbose 
                Remove-Item -Path "$($Env:WinDir)\CCMCache" -Force -Confirm:$false  -Verbose 
                Remove-Item -Path "$($Env:WinDir)\smscfg.ini" -Force -Confirm:$false  -Verbose 
                Remove-Item -Path 'HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\*' -Force -Confirm:$false  -Verbose 
                Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\CCM' -Force -Recurse -Verbose
                Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\CCM' -Force -Recurse -Confirm:$false  -Verbose
                Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\SMS' -Force -Recurse -Confirm:$false  -Verbose
                Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\SMS' -Force -Recurse -Confirm:$false   -Verbose
                Remove-Item -Path 'HKLM:\Software\Microsoft\CCMSetup' -Force -Recurse -Confirm:$false  -Verbose
                Remove-Item -Path 'HKLM:\Software\Wow6432Node\Microsoft\CCMSetup' -Force -Confirm:$false  -Recurse  -Verbose
                Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\CcmExec' -Force -Recurse -Confirm:$false  -Verbose
                Get-CimInstance -query "Select * From __Namespace Where Name='CCM'" -Namespace "root" | 
                Remove-CimInstance -Verbose -Confirm:$false 
                Get-CimInstance -query "Select * From __Namespace Where Name='CCMVDI'" -Namespace "root" | 
                Remove-CimInstance -Verbose -Confirm:$false 
                Get-CimInstance -query "Select * From __Namespace Where Name='SmsDm'" -Namespace "root" | 
                Remove-CimInstance  -Verbose -Confirm:$false 
                Get-CimInstance -query "Select * From __Namespace Where Name='sms'" -Namespace "root\cimv2" | 
                Remove-CimInstance -Verbose -Confirm:$false 
                Write-Output  "$env:ComputerName  : Script Ended"
            }
            else {
                Write-Warning " $env:ComputerName : Setup files not found, Verify the client installation"
            }
        }
}