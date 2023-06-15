$tls12Protocol = [System.Net.SecurityProtocolType] 'ssl3, tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $tls12Protocol
Connect-AzureAD
Connect-MsolService

$users = Get-AzureADUser -All $true | Select-Object UserPrincipalName, DisplayName, PhysicalDeliveryOfficeName, Department, JobTitle, @{Name='GLCode'; Expression={$_.ExtensionProperty.extension_6e6d88340df342599b92c3585bdb29bb_gLCode}} | Export-Csv -Path "C:\test1.csv" -NoTypeInformation

#$licenses = Get-MsolUser -All | Select-Object UserPrincipalName, @{n="Licenses";e={$_.Licenses.AccountSkuId}}, @{n="Price";e={$_.Licenses[0].SkuPartNumber}}, @{n="LicenseCost";e={[math]::Round($_.Licenses[0].TotalLicenses * $_.Licenses[0].EnabledPlans[0].CapabilityStatus["Active"] / 30 * $_.Licenses[0].EnabledPlans[0].ServicePlans[0].ServicePlanCost.PricingModel[0].Value, 2)}} | Export-Csv -Path "C:\test2.csv" -NoTypeInformation
#Get-MsolUser -All | Select-Object UserPrincipalName, @{n="Licenses";e={$_.Licenses.AccountSkuId}} | Export-Csv -Path "C:\test2.csv" -NoTypeInformation


$arr = @()
$file1 = Import-Csv -Path "C:\test1.csv" -Header 'UserPrincipalname', 'DisplayName', 'PhysicalDeliveryOfficeName', 'Department', 'JobTitle', 'GLCode'
$file2 = Import-Csv -Path "C:\Microsoft365Users.CSV" -Header 'UserName','UserPrincipalName','UserId','IsLicensed','Licenses','LicensedServices'

$userslist = $file1.UserPrincipalName + $file2.UserPrincipalName | Sort-Object -Unique

$combinedObject = foreach ($user in $userslist)
{
    $file1values = $file1 | Where-Object {$_.UserPrincipalName -eq $user} | Select-Object DisplayName, PhysicalDeliveryOfficeName, Department, JobTitle, GLCode
    $file2values = $file2 | Where-Object {$_.UserPrincipalName -eq $user} | Select-Object Licenses

    [PSCustomObject]@{
        UserPrincipalName = $user
        DisplayName = $file1values.DisplayName
        Office = $file1values.PhysicalDeliveryOfficeName
        Department = $file1values.Department
        JobTitle = $file1values.JobTitle
        GLCode = $file1values.GLCode
        Licenses = $file2values.Licenses
    }
}

$combinedObject | Export-Csv -Path "C:\userdetails-license.csv" -NoTypeInformation
