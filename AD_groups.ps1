$path = Read-Host -Prompt 'Enter share/folder path' 
$reportpath ="C:\data\ACL.csv" 
dir -Recurse $path | where { $_.PsIsContainer } | % { $path1 = $_.fullname; Get-Acl $_.Fullname | % { $_.access | Add-Member -MemberType NoteProperty '.\Application Data' -Value $path1 -passthru }}  | Export-Csv $reportpath 
$acl = (Get-Acl $path).access | select @{n='Identity';e={ ($_.IdentityReference.ToString().Split("\"))[1] }}, FileSystemRights #| Export-Csv -Path C:\Data\AD_Groups\perm.csv -notypeinformation
$group = $acl | Select -ExpandProperty Identity  
$Table = @()
$Record = @{
  "Group Name" = ""
  "Name" = ""
  "Username" = ""
}
$domains = (Get-ADForest).domains
foreach($domain in $domains){
foreach($i in $group)
{
$members = Get-ADGroupMember -Identity $i -Recursive -Server $domain 
foreach($member in $members)
{
    $Record."Group Name" = $i
    $Record."Name" = $Member.Name
    $Record."UserName" = $Member.SamAccountName
    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord
}
}
}

$table | Export-Csv "C:\data\AD_Groups\test1.csv" -NoTypeInformation -Append


#input - folder path
#output - 