Invoke-Command -ComputerName SGSCVAiw0525.in623.corpintra.net -ScriptBlock {
New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL -Name Ciphers 
New-Item -Path Registry::HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers -Name 'RC4 128/128'
New-ItemProperty -LiteralPath HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 -Name Enabled -Value 00000000 
New-Item -Path 'Registry::HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128' #-Name 'RC4 128/128'
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" -Name Enabled -Value 00000000 
New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers -Name "RC4 256/256"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 256/256" -Name Enabled -Value 00000000 
New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers -Name "RC4 40/128"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Name Enabled -Value 00000000
New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers -Name "Triple DES" 
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES" -Name Enabled -Value 00000000
}

 new-item -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers -ItemType registry -Name 'RC4 128/128'