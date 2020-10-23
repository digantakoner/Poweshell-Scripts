$computers = Get-Content "C:\dism.txt"
foreach ($computer in $computers)
{
Invoke-Command -ComputerName $computer -ScriptBlock {get-package}
}