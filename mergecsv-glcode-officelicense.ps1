$users = Get-AzureADUser -All $true | Select-Object UserPrincipalName, DisplayName, PhysicalDeliveryOfficeName, Department, JobTitle, @{Name='GLCode'; Expression={$_.ExtensionProperty.extension_6e6d88340df342599b92c3585bdb29bb_gLCode}} | Export-Csv -Path "C:\test1.csv" -NoTypeInformation
$licenses = Get-MsolUser -All | Select-Object UserPrincipalName, @{n="Licenses";e={$_.Licenses.AccountSkuId}}, @{n="Price";e={$_.Licenses[0].SkuPartNumber}}, @{n="LicenseCost";e={[math]::Round($_.Licenses[0].TotalLicenses * $_.Licenses[0].EnabledPlans[0].CapabilityStatus["Active"] / 30 * $_.Licenses[0].EnabledPlans[0].ServicePlans[0].ServicePlanCost.PricingModel[0].Value, 2)}} | Export-Csv -Path "C:\test2.csv" -NoTypeInformation
$arr = @()
$csv1 = Import-Csv -Path "C:\test1.csv"
$csv2 = Import-Csv -Path "C:\test2.csv"

for($i=0; $i -lt $csv1.Count; $i++){
$temp = New-Object psobject
$temp |  Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $csv1[$i].UserPrincipalName
$temp |  Add-Member -MemberType NoteProperty -Name DisplayName -Value $csv1[$i].DisplayName
$temp |  Add-Member -MemberType NoteProperty -Name Office -Value $csv1[$i].PhysicalDeliveryOfficeName
$temp |  Add-Member -MemberType NoteProperty -Name Department -Value $csv1[$i].Department
$temp |  Add-Member -MemberType NoteProperty -Name JobTitle -Value $csv1[$i].JobTitle
$temp |  Add-Member -MemberType NoteProperty -Name GLCode -Value $csv1[$i].GLCode
$temp | Add-Member -MemberType NoteProperty -Name License -Value $csv2[$i].Licenses
$arr+=$temp
}

$arr | Export-Csv -Path "C:\final12.csv" -NoTypeInformation