$files = Get-ChildItem "C:\test5" -Filter "filter"
#$source = Get-ChildItem -Path "C:\test5" -Filter "filter"
$destination = "C:\test7"
foreach($file in $files)
{
if ($file.LastWriteTime -gt (Get-Date).AddDays(-4))
{
Copy-Item $file.FullName $destination
}
}