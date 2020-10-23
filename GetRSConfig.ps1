Function Get-RSInstances
    {
        Param (
            [string]$InstanceName
        
        )
        $ReportingWMIInstances = @()
        $ReportingWMIInstances += Get-WmiObject -Namespace "Root\Microsoft\SqlServer\ReportServer" -Class "__Namespace" -ErrorAction 0

        if ($ReportingWMIInstances.count -lt 1)
            {
                Write-Error "Couldn't find any SQL Server Reporting Instances on this computer"
                Write-Host  "========================================================`n Press Any Key To close..."
                [void][System.Console]::ReadKey($true);
                break; 
            }

        $ReportingInstances = @()

        Foreach ($ReportingWMIInstance in $ReportingWMIInstances)
            {
                #Find the SRS Version and admin instance
                $WMIInstanceName = $ReportingWMIInstance.Name
                #WMIInstanceName will be in the format "RS_InstanceName", split away the rs part
                $InstanceDisplayName = $WMIInstanceName.Replace("RS_","")


                $InstanceNameSpace = "Root\Microsoft\SqlServer\ReportServer\$WMIInstanceName"
                $VersionInstance = Get-WmiObject -Namespace $InstanceNameSpace -Class "__Namespace" -ErrorAction 0
                $VersionInstanceName = $VersionInstance.Name
                $AdminNameSpace = "Root\Microsoft\SqlServer\ReportServer\$WMIInstanceName\$VersionInstanceName\Admin"
                $ConfigSetting = Get-WmiObject -Namespace $AdminNameSpace -Class "MSReportServer_ConfigurationSetting" | where {$_.InstanceName -eq $InstanceDisplayName}
                $ConfigSetting | add-member -MemberType NoteProperty -Name "InstanceAdminNameSpace" -Value $AdminNameSpace
                [xml]$ReportServerInstanceConfig = Get-content $ConfigSetting.PathName
                $ConfigSetting | add-member -MemberType NoteProperty -Name "ConfigFileSettings" -Value $ReportServerInstanceConfig
                $ReportingInstances += $ConfigSetting
                
            }

            if ($InstanceName)
               {
                    $ReportingInstances = $ReportingInstances | where {$_.InstanceName -like $InstanceName}
               }
        $ReportingInstances
    }


Function Get-ServerInfo {
$local:computer = $env:computername
# Declare main data hash to be populated later
$data = @{}
$data.'Computer Name' = $local:computer

# Do a DNS lookup with a .NET class method. Suppress error messages.
$ErrorActionPreference = 'SilentlyContinue'
if ( $local:proxy = [System.Net.WebProxy]::GetDefaultProxy()| foreach { $_.address } ) {
    
    $data.'Proxy ' = ($local:proxy -join ', ')
    
}

else {
    $data.'Proxy ' = 'N/A'
}
# Make errors visible again
$ErrorActionPreference = 'Continue'
    # Get various info from the ComputerSystem WMI class
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_ComputerSystem -ErrorAction SilentlyContinue) {
        
        $data.'Domain'                         = $local:computer.Domain
        $data.'Computer Hardware Manufacturer' = $local:wmi.Manufacturer
        $data.'Computer Hardware Model'        = $local:wmi.Model
        $data.'Physical Memory in MB'          = ($local:wmi.TotalPhysicalMemory/1MB).ToString('N')
        $data.'Logged On User'                 = $local:wmi.Username
        $data.'Logged On User DNS'             = $local:wmi.DNSHostName
        
    }
    
    $local:wmi = $null
    
    # Get the free/total disk space from local disks (DriveType 3)
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue) {
        
        $local:wmi | Select 'DeviceID', 'Size', 'FreeSpace' | Foreach {
            
            $data."Local disk $($_.DeviceID)" = ('Free MB: ' + ($_.FreeSpace/1MB).ToString('N') + [char]9 + '|| Total Space: ' + ($_.Size/1MB).ToString('N'))
        }
        
    }
    
    $local:wmi = $null
    
    # Get IP addresses from all local network adapters through WMI
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue) {
        
        $local:Ips = @{}
        
        $local:wmi | Where { $_.IPAddress -match '\S+' } | Foreach { $local:Ips.$($_.IPAddress -join ', ') = $_.MACAddress }
        
        $local:counter = 0
        $local:Ips.GetEnumerator() | Foreach {
            
            $local:counter++; $data."IP Address $local:counter" = '' + $_.Name + ' (MAC: ' + $_.Value + ')'
            
        }
        
    }
    
    $local:wmi = $null
    
    # Get CPU information with WMI
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_Processor -ErrorAction SilentlyContinue) {
        
        $local:wmi | Foreach {
            
            $local:maxClockSpeed     =  $_.MaxClockSpeed
            $local:numberOfCores     += $_.NumberOfCores
            $local:description       =  $_.Description
            $local:numberOfLogProc   += $_.NumberOfLogicalProcessors
            $local:socketDesignation =  $_.SocketDesignation
            $local:status            =  $_.Status
            $local:name              =  $_.Name
            
        }
        
        $data.'CPU Clock Speed'        = $local:maxClockSpeed
        $data.'CPU Cores'              = $local:numberOfCores
        $data.'CPU Description'        = $local:description
        $data.'CPU Logical Processors' = $local:numberOfLogProc
        $data.'CPU Socket'             = $local:socketDesignation
        $data.'CPU Status'             = $local:status
        $data.'CPU Name'               = $local:name -replace '\s+', ' '
        
    }
    
    $local:wmi = $null
    
    # Get operating system info from WMI
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_OperatingSystem -ErrorAction SilentlyContinue) {
        
        $data.'Time Local'    = $local:wmi.ConvertToDateTime($local:wmi.LocalDateTime)
        $data.'Time Zone'     = $local:wmi.CurrentTimezone
        $data.'Time Last Boot'     = $local:wmi.ConvertToDateTime($local:wmi.LastBootUpTime)
        $data.'OS System Drive'  = $local:wmi.SystemDrive
        $data.'OS Version'       = $local:wmi.Version
        $data.'OS Windows dir'   = $local:wmi.WindowsDirectory
        $data.'OS Name'          = $local:wmi.Caption
        $data.'OS Service Pack'  = [string]$local:wmi.ServicePackMajorVersion + '.' + $local:wmi.ServicePackMinorVersion
        $data.'OS Organization'  = $local:wmi.Organization
        $data.'Physical Memory Free MB' = ($local:wmi.FreePhysicalMemory/1KB).ToString('N')
        
    }

     # Get MSFT Services
    if ($local:wmi = Get-WmiObject -Computer $local:computer -Class Win32_Service -ErrorAction SilentlyContinue) {
        $local:Service = @{}
        
       $local:wmi | where { $_.name | Select-String -Pattern "SQL" ,"report"} |Foreach { $local:Service.$($_.Name -join ', ') = $_.State}
        
        $local:counter = 0
        $local:Service.GetEnumerator() | Foreach {
            
            $local:counter++; $data."Process $local:counter" += '' + $_.Name +' (State: ' + $_.Value +')'
        
    }
    }
    
# Output data
$data.GetEnumerator() | Sort-Object 'Name' | Format-Table -AutoSize | Out-String -Stream | where {$_} | foreach { $_.TrimEnd()}
}


# VARIABLES
$Date = Get-Date
$DateString = $Date.ToString("yyyyMMdd-HH")
$RuningDir = $PSScriptRoot
$SavingDir = "$RuningDir\_GetRSConfig"
$File = "$SavingDir\RS_WMI_$DateString.txt"
$ServerInfo = "$SavingDir\ServerInfo_$DateString.txt"
$ZipFile = "$RuningDir\ReportServer_$DateString.zip"

# CREATE NEW FOLDER
if(!(Test-Path $SavingDir)) {New-Item -ItemType Directory -Force -Path $SavingDir | Out-Null}
try
{
Get-ServerInfo | Out-File -FilePath $ServerInfo -Width 512
}
finally
{
Get-RSInstances | Format-List -Property PSComputerName,InstanceName,Version,PathName,Database*,IsInitialized,IsReportManagerEnabled,IsSharePointIntegrated,*Service*,*Directory*,Secure*,Send*,SMTP*,FileShareAccount,UnattendedExecutionAccount,InstallationID,MachineAccountIdentity | Out-File -FilePath $File

# GET CONFIGURATION FILES
Get-RSInstances | ForEach-Object {
$ConfigSource = (Get-Item $_.PathName).DirectoryName
$ConfigDestination = "$SavingDir\"+$_.InstanceName

if(!(Test-Path $ConfigDestination))
{
New-Item -ItemType Directory -Force -Path $ConfigDestination | Out-Null
}
Copy-Item -Path "$ConfigSource\*" -Include "*.config" -Destination $ConfigDestination -Force
}

if ($error.Count -eq 0)
{
if (Test-Path $ZipFile) {Remove-item $ZipFile}
Add-Type -assembly "system.io.compression.filesystem" 
[io.compression.zipfile]::CreateFromDirectory($SavingDir,$ZipFile)

write-host "=========================================================`n Successful. Please share the generated file: `n" $ZipFile 
[void][System.Console]::ReadKey($true)
}
}
#	@ v-ficaet