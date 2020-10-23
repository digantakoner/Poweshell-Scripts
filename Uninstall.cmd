CsUninstallTool.exe /quiet 
rmdir /q /s "C:\Windows\System32\drivers\CrowdStrike"
Reg Delete HKLM\System\Crowdstrike /f