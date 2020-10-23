$source = "\\fileshare"
$destination = "\\fileshare"
Copy-Item $source -Filter "filter" $destination
Get-ChildItem $destination -Recurse| Rename-Item -NewName  {[string]($_.name).substring(0,26) + [string]($_.name).substring(34,9) +'.txt'}