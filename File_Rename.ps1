#$filenameFormat = "filename" + + ".txt"
#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName $filenameFormat



#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName  {$_.name -replace '*','0281_MBENZRND.REPORT.SWIFT.20200219.txt'}

#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName  {$_.name.Split(' ')[9] + '.txt'}

Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName  {[string]($_.name).substring(0,26) + [string]($_.name).substring(34,9) +'.txt'}

#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName {$_.name.Substring($_.Name.LastIndexOf("T")+2) + '.txt'}


#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName {$_.name.Substring(15) + '.txt'}

#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName { [string]($_.name).substring(0,$_.name.length -9) +  '.txt'}

#Get-ChildItem C:\test1\jpm -Recurse| Rename-Item -NewName {[string]($_.name).substring(0,$_.name.length -9) +  + '.txt'}

