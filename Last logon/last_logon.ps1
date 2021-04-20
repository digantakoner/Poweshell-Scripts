$computers = Get-Content "C:\computers.txt"
foreach($computer in $computers)
{
Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 3
}
