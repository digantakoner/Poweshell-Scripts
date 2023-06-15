# Connect to Microsoft 365
Connect-MsolService

# Get all user accounts
$users = Get-AzureADUser -Filter "UserPrincipalName eq 'hussains@whitsons.com'"  | select -expandproperty extensionproperty

# Loop through each user and set the Department attribute based on their license type
foreach ($user in $users) {
    if ($user.Licenses.AccountSkuId -like "*ENTERPRISEPACK*") {
        Set-MsolUser -UserPrincipalName $user.UserPrincipalName -Department "Enterprise Pack GL Code"
    }
    elseif ($user.Licenses.AccountSkuId -like "*BUSINESSPREMIUM*") {
        Set-MsolUser -UserPrincipalName $user.UserPrincipalName -Department "Business Premium GL Code"
    }
    else {
        Set-MsolUser -UserPrincipalName $user.UserPrincipalName -Department "Default GL Code"
    }
}

# Save the changes to Microsoft 365
Write-Host "Saving changes to Microsoft 365..."
Start-Sleep -Seconds 5 # Wait for changes to propagate
