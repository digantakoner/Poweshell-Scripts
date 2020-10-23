$servers = Get-Content "C:\ipaddress\servers.txt"
foreach($server in $servers) 
{
$test = Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue
if($test) { 
        $status = 'Ok'
        $address = $test.IPV4Address
    } else { 
        $status = 'Failed'
        $address = ''
    }
$results = [PSCustomObject]@{
        ServerName = $server
        IPAddress = $address
        'Ping Status' = $status
    }
$results | Export-Csv -Path "C:\ipaddress\output.csv" -NoTypeInformation -Append
}