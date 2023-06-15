# Connect to Azure AD
#Connect-AzureAD

# Retrieve all users and display extension attributes
#Get-AzureADUser -All $true | Select-Object UserPrincipalName, @{Name='ExtensionAttribute1'; Expression={$_.ExtensionProperty.ExtensionAttribute1}}, @{Name='ExtensionAttribute2'; Expression={$_.ExtensionProperty.ExtensionAttribute2}}, ...
#Get-AzureADUser -all $true | Select-Object UserPrincipalName, emailId, @{Name='GLCode'; Expression={$_.ExtensionProperty.extension_6e6d88340df342599b92c3585bdb29bb_gLCode}} | ft
Get-AzureADUser -ObjectId hussains@whitsons.com | Select-Object AssignedPlans, UserPrincipalName, DisplayName, PhysicalDeliveryOfficeName,Department,JobTitle,AssignedLicenses, @{Name='GLCode'; Expression={$_.ExtensionProperty.extension_6e6d88340df342599b92c3585bdb29bb_gLCode}} #| Export-Csv -Path "C:\userlicense.csv" -NoTypeInformation 
#Get-AzureADUser -ObjectId hussains@whitsons.com | Select-Object AssignedPlans | Format-Custom
#Get-AzureADUser -ObjectId "hussains@whitsons.com" | Select-Object AssignedPlans | Format-Custom
