$source = "C:\test1"
$Destination = "C:\test4\"
robocopy $source $Destination *.*  /MOVE /e /MINAGE:2 /log+:"C:\robocopy_test\logs5.txt"
$limit = (Get-Date).AddDays(-4)
Foreach($file in (Get-ChildItem $Destination))
{
	If($file.LastWriteTime -lt $limit)
	{
		Remove-Item $Destination\$file -Recurse -Force
	}
}