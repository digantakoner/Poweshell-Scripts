Login-AzureRmAccount  
Select-AzureRmSubscription -SubscriptionName "your_subscription_name" 
$mailTo = New-Object "System.Collections.Generic.List[String]"  
$mailTo.Add(“test_user1@domain.com”)  
$mailTo.Add(“test_user2@domian.com”) 
$action = New-AzureRmAlertRuleEmail -CustomEmails $mailTo  
$action.SendToServiceOwners = $true 
Add-AzureRmMetricAlertRule -Location “west us” -MetricName “TotalRequests” -Name “TotalRequestsRule” -Operator GreaterThan -ResourceGroup “test-app” -TargetResourceId “/subscriptions/xxxxx-xxxx-475f-xxx-xxxxxxxx/resourceGroups/bhushan-test-rg/providers/Microsoft.Storage/storageAccounts/bhushantest/services/blob” -Threshold “5” -TimeAggregationOperator Average -WindowSize “02:00:00” -Actions $action -Description “This rule sends out alert if total requests are exceeded beyond 5”

=====================================================================================================================================

$location = 'Global'
$alertName = 'myAlert'
$resourceGroupName = 'theResourceGroupName'
$condition1 = New-AzureRmActivityLogAlertCondition -Field 'field1' -Equals 'equals1'
$condition2 = New-AzureRmActivityLogAlertCondition -Field 'field2' -Equals 'equals2'
$dict = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]"
$dict.Add('key1', 'value1')
$actionGrp1 = New-AzureRmActionGroup -ActionGroupId 'actiongr1' -WebhookProperties $dict
Set-AzureRmActivityLogAlert -Location $location -Name $alertName -ResourceGroupName $resourceGroupName -Scope 'scope1','scope2' -Action $actionGrp1 -Condition $condition1, $condition2



====================================================================================================================================


Get-AzureRmActivityLogAlert -Name $alertName -ResourceGroupName $resourceGroupName | Set-AzureRmActivityLogAlert
$alert = Get-AzureRmActivityLogAlert -Name $alertName -ResourceGroupName $resourceGroupName
$alert.Description = 'Changing the description'
$alert.Enabled = $true
Set-AzureRmActivityLogAlert -InputObject $alert

===============================================================================

https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/getting-started
https://azure.microsoft.com/en-us/pricing/calculator/