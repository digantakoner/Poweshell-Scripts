$servers = Get-Content "C:\Data\servers.txt"
$KBs = Get-Content "C:\Data\KB.txt"         
$data = foreach ($server in $servers)
{
$test = Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue
if($test) 
{
        $uptime = Get-Uptime $_.$server
}
else
{
    Write-Host "Server $_.$server is down"
}
 foreach ($KB in $KBs)
 {
 Get-HotFix -ComputerName $server -id $KB -OutVariable result -ErrorAction SilentlyContinue
 if ($result -ne $null)
 {
    $message = "KB is installed"
 #$result | Export-Csv -Path "C:\Data\installed.csv" -NoTypeInformation -Append
  }
 else
 {
       $message = "KB is not installed" 
 #Add-Content "$KB is not present in the $server" -Path "C:\Data\notinstalled.csv"
 }
 $result = [PSCustomObject]@{
    Servername = $server
    KB = $KB
    Status = $message
    uptime = $uptime
     }
 $result | Export-Csv -Path "C:\Data\report.csv" -NoTypeInformation -Append
 }
 }
 
 
  

