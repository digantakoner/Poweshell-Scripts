$groups = Get-Content "C:\test1\groups.txt"
foreach($group in $groups)
{
Get-ADGroupMember -Identity $group -Recursive | Export-Csv -Path "C:\test1\members.csv" -NoTypeInformation -Append
}