$source = "\\fileshare"
$destination = "\\fileshare"
Move-Item $source\*.* $destination
Get-ChildItem C:\test1\test1 -Recurse| Rename-Item -NewName  {[string]($_.name).substring(0,26) + [string]($_.name).substring(34,9) +'.txt'}
$source1 = "\\fileshare"
$destination1 = "\\fileshare"
Copy-Item $source1\*.* $destination1

Copy-Item "C:\test1\test2" -Filter "3855*" "C:\test1\test3"