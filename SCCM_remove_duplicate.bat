taskkill /f /im ccmexec.exe
Reg Delete HKLM\software\Microsoft\Systemcertificates\SMS\Certificates /f
DEL c:\Windows\SMSCFG.ini
net start ccmexec