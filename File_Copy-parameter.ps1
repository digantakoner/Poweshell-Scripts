$source = "\\fileshare"
$destination = "\\fileshare"
Get-ChildItem –Path $source -Recurse -Exclude "filter" | Where-Object {($_.CreationTime -ge (Get-Date).AddMinutes(-1))} | Copy-Item -Destination $destination
