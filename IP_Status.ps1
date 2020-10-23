$results = Get-Content "C:\ipaddress\servers.txt" | foreach {
       $test = Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue
    if($test) { 
        $status = 'Ok'
        $address = $test.IPV4Address
    } else { 
        $status = 'Failed'
        $address = ''
    }
    [PSCustomObject]@{
        ServerName = $_
        IPAddress = $address
        'Ping Status' = $status
    }
} 

$results | Export-Csv -Path "C:\ipaddress\output.csv" -NoTypeInformation -Append
 