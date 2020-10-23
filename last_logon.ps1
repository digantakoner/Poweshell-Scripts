$computers = Get-Content "C:\Personal Data\Scripts\Last logon\computers.txt"
foreach($computer in $computers)
{
Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 3
}
