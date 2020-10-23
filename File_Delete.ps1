$files = Get-ChildItem -Path "C:\test1\*.*"
foreach($file in $files)
{
if ($file.Name.Length -gt 40) {Remove-Item $file}
}

$soyrce
