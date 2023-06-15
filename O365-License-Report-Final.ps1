<#PSScriptInfo
 
.VERSION 1.0
 
.GUID cd2bcff4-9979-452e-9cd8-017780e82200
 
.AUTHOR rubik.junk@gmail.com
 
.COMPANYNAME BUSTRAMA
 
.COPYRIGHT Ben Brandes
 
.PROJECTURI https://github.com/rubik951/PowerShell/tree/master/O365
 
.EXTERNALMODULEDEPENDENCIES MSOnline
 
#>

<#
 
.DESCRIPTION
 This script will help you manage your office 365 Licenses
 
#> 

Param()


###################################################
####### #######
####### Office 365 License Report #######
####### #######
####### License Report #######
####### User's Licenses Report #######
####### #######
###################################################

# Checks if module installed
if(Get-InstalledModule MSOnline){ 
    Write-Output "Module exist" 
}else{ 
    #if not installed, checks if running as admin, if not, Run As Admin
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")){
        Start-Process powershell.exe"-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
    }
    # Install the module
    Install-Module MSOnline
}

# Connect to office 365 Servcie
Connect-MsolService

# Licenses Report
Get-MsolAccountSku | Select-Object AccountSkuId,ActiveUnits,ConsumedUnits | Export-Csv -Path "$($env:USERPROFILE)\Desktop\Licenses.csv" -Encoding UTF8

# Licensed Users
$users = Get-MsolUser -all | Where-Object { $_.isLicensed -eq"TRUE" } | Sort-Object DisplayName
$users = $users | Select-Object -ExpandProperty Licenses DisplayName,UserPrincipalName | Select-Object DisplayName,UserPrincipalName,AccountSkuId

# Convert Array to List
[Collections.Generic.List[Object]]$users = $users

# Merge Duplicates
$i = 1
while($i -lt $users.Count) {
    if($users[$i].UserPrincipalName -eq $users[$i-1].UserPrincipalName) {
        $users[$i-1].AccountSkuId +=", " + $users[$i].AccountSkuId
        $users.Remove($users[$i])
        $i =1
    }
    $i++
}

# Change licenses for cleaner report
foreach($user in $users){ 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:O365_BUSINESS_ESSENTIALS",               "Office 365 Business Essentials"    
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:O365_BUSINESS_PREMIUM",                  "Office 365 Business Premium"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DESKLESSPACK",                           "Office 365 (Plan K1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DESKLESSWOFFPACK",                       "Office 365 (Plan K2)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:LITEPACK",                               "Office 365 (Plan P1)" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGESTANDARD",                       "Office 365 Exchange Online Only"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDPACK",                           "Enterprise Plan E1"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK",                       "Office 365 (Plan E2)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACK",                         "Enterprise Plan E3"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACKLRG",                      "Enterprise Plan E3"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEWITHSCAL",                     "Enterprise Plan E4"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDPACK_STUDENT",                   "Office 365 (Plan A1) for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACKPACK_STUDENT",           "Office 365 (Plan A2) for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACK_STUDENT",                 "Office 365 (Plan A3) for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEWITHSCAL_STUDENT",             "Office 365 (Plan A4) for Students" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDPACK_FACULTY",                   "Office 365 (Plan A1) for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACKPACK_FACULTY",           "Office 365 (Plan A2) for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACK_FACULTY",                 "Office 365 (Plan A3) for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEWITHSCAL_FACULTY",             "Office 365 (Plan A4) for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACK_B_PILOT",                 "Office 365 (Enterprise Preview)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARD_B_PILOT",                       "Office 365 (Small Business Preview)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:VISIOCLIENT",                            "Visio Pro Online"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:POWER_BI_ADDON",                         "Office 365 Power BI Addon"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:POWER_BI_INDIVIDUAL_USE",                "Power BI Individual User"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:POWER_BI_STANDALONE",                    "Power BI Stand Alone" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:POWER_BI_STANDARD",                      "Power-BI Standard"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTESSENTIALS",                      "Project Lite"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTCLIENT",                          "Project Professional"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTONLINE_PLAN_1",                   "Project Online"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTONLINE_PLAN_2",                   "Project Online and PRO"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ProjectPremium",                         "Project Online Premium"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ECAL_SERVICES",                          "ECAL"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EMS",                                    "Enterprise Mobility Suite"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:RIGHTSMANAGEMENT_ADHOC",                 "Windows Azure Rights Management"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOMEETADV",                             "PSTN conferencing" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTSTORAGE",                      "SharePoint storage"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PLANNERSTANDALONE",                      "Planner Standalone"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:CRMIUR",                                 "CMRIUR"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:BI_AZURE_P1",                            "Power BI Reporting and Analytics"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:INTUNE_A",                               "Windows Intune Plan A"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTWORKMANAGEMENT",                  "Office 365 Planner Preview"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ATP_ENTERPRISE",                         "Exchange Online Advanced Threat Protection"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EQUIVIO_ANALYTICS",                      "Office 365 Advanced eDiscovery"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:AAD_BASIC",                              "Azure Active Directory Basic"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:RMS_S_ENTERPRISE",                       "Azure Active Directory Rights Management" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:AAD_PREMIUM",                            "Azure Active Directory Premium"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MFA_PREMIUM",                            "Azure Multi-Factor Authentication"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDPACK_GOV",                       "Microsoft Office 365 (Plan G1) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK_GOV",                   "Microsoft Office 365 (Plan G2) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPACK_GOV",                     "Microsoft Office 365 (Plan G3) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEWITHSCAL_GOV",                 "Microsoft Office 365 (Plan G4) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DESKLESSPACK_GOV",                       "Microsoft Office 365 (Plan K1) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ESKLESSWOFFPACK_GOV",                    "Microsoft Office 365 (Plan K2) for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGESTANDARD_GOV",                   "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGEENTERPRISE_GOV",                 "Microsoft Office 365 Exchange Online (Plan 2) only for Government" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTDESKLESS_GOV",                 "SharePoint Online Kiosk"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGE_S_DESKLESS_GOV",                "Exchange Kiosk"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:RMS_S_ENTERPRISE_GOV",                   "Windows Azure Active Directory Rights Management"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:OFFICESUBSCRIPTION_GOV",                 "Office ProPlus"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOSTANDARD_GOV",                        "Lync Plan 2G"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTWAC_GOV",                      "Office Online for Government"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTENTERPRISE_GOV",               "SharePoint Plan 2G"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGE_S_ENTERPRISE_GOV",              "Exchange Plan 2G"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGE_S_ARCHIVE_ADDON_GOV",           "Exchange Online Archiving"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:whitsons1:EXCHANGE_S_DESKLESS",                    "Exchange Online Kiosk" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTDESKLESS",                     "SharePoint Online Kiosk"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTWAC",                          "Office Online"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:YAMMER_ENTERPRISE",                      "Yammer for the Starship Enterprise"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGE_L_STANDARD",                    "Exchange Online (Plan 1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOLITE",                                "Lync Online (Plan 1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTLITE",                         "SharePoint Online (Plan 1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ",     "Office ProPlus"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGE_S_STANDARD_MIDMARKET",          "Exchange Online (Plan 1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOSTANDARD_MIDMARKET",                  "Lync Online (Plan 1)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SHAREPOINTENTERPRISE_MIDMARKET",         "SharePoint Online (Plan 1)" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:OFFICESUBSCRIPTION",                     "Office ProPlus"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:YAMMER_MIDSIZE",                         "Yammer"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_ENTERPRISE_PLAN1",                "Dynamics 365 Customer Engagement Plan Enterprise Edition"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPREMIUM_NOPSTNCONF",           "Enterprise E5 (without Audio Conferencing)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ENTERPRISEPREMIUM",                      "Enterprise E5 (with Audio Conferencing)"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOSTANDARD",                            "Skype for Business Online Standalone Plan 2"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECT_MADEIRA_PREVIEW_IW_SKU",         "Dynamics 365 for Financials for IWs"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK_IW_STUDENT",            "Office 365 Education for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK_IW_FACULTY",            "Office 365 Education for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EOP_ENTERPRISE_FACULTY",                 "Exchange Online Protection for Faculty" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGESTANDARD_STUDENT",               "Exchange Online (Plan 1) for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:OFFICESUBSCRIPTION_STUDENT",             "Office ProPlus Student Benefit"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK_FACULTY",               "Office 365 Education E1 for Faculty"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:STANDARDWOFFPACK_STUDENT",               "Microsoft Office 365 (Plan A2) for Students"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_FINANCIALS_BUSINESS_SKU",         "Dynamics 365 for Financials Business Edition"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_FINANCIALS_TEAM_MEMBERS_SKU",     "Dynamics 365 for Team Members Business Edition"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:FLOW_FREE",                              "Microsoft Flow Free"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:POWER_BI_PRO",                           "Power BI Pro"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:O365_BUSINESS",                          "Office 365 Business"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_ENTERPRISE_SALES",                "Dynamics Office 365 Enterprise Sales" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:RIGHTSMANAGEMENT",                       "Rights Management"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:PROJECTPROFESSIONAL",                    "Project Professional"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:VISIOONLINE_PLAN1",                      "Visio Online Plan 1"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGEENTERPRISE",                     "Exchange Online Plan 2"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_ENTERPRISE_P1_IW",                "Dynamics 365 P1 Trial for Information Workers"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:DYN365_ENTERPRISE_TEAM_MEMBERS",         "Dynamics 365 For Team Members Enterprise Edition"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:CRMSTANDARD",                            "Microsoft Dynamics CRM Online Professional"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGEARCHIVE_ADDON",                  "Exchange Online Archiving For Exchange Online"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:EXCHANGEDESKLESS",                       "Exchange Online Kiosk"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SPZA_IW",                                "App Connect" 
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:WINDOWS_STORE",                          "Windows Store for Business"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOEV",                                  "Microsoft Phone System"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:VIDEO_INTEROP",                          "Polycom Skype Meeting Video Interop for Skype for Business"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SPE_E5",                                 "Microsoft 365 E5"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:SPE_E3",                                 "Microsoft 365 E3"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:ATA",                                    "Advanced Threat Analytics"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:MCOPSTN2",                               "Domestic and International Calling Plan"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:FLOW_P1",                                "Microsoft Flow Plan 1"
    $user.AccountSkuId = $user.AccountSkuId -replace "whitsons1:FLOW_P2",                                "Microsoft Flow Plan 2"
}
    
# User's Licenses Report
$users | Export-Csv -Path "$($env:USERPROFILE)\Desktop\UsersLicenses.csv" -Encoding UTF8 -NoTypeInformation

Write-Output "Reports Created on Desktop!"