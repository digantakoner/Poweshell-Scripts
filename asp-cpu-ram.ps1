function infra-alets([string]$resourceGroup, [string]$appname, [string]$actionGroupName)
{
$resourceGroup = "adi-eus2-analogcom-poc-rg"
$appname = "/subscriptions/fa8c5977-00e7-405f-a2be-7b64a977d0bb/resourceGroups/adi-eus2-analogcom-poc-rg/providers/Microsoft.Web/serverfarms/adi-eus2-tools-poc-shared-asp"
$actionGroupName = "cloud-ops-admin"


<# https://docs.microsoft.com/en-us/cli/azure/monitor/action-group?view=azure-cli-latest#az-monitor-action-group-create
az monitor action-group create --name $actionGroupName --resource-group $resourceGroup#>

 # https://docs.microsoft.com/en-us/powershell/module/az.monitor/get-azactiongroup?view=azps-2.2.0
$actionGroup = Get-AzActionGroup -ResourceGroupName $resourceGroup -Name $actionGroupName

# https://docs.microsoft.com/en-us/powershell/module/az.monitor/new-azactiongroup?view=azps-2.2.0
$actionGroupId = New-AzActionGroup -ActionGroupId $actionGroup.Id

# https://docs.microsoft.com/en-us/powershell/module/az.monitor/new-azmetricalertrulev2criteria?view=azps-2.2.0
$cond = New-AzMetricAlertRuleV2Criteria `
   -MetricName "CpuPercentage" `
   -MetricNamespace "Microsoft.Web/serverFarms" `
   -TimeAggregation "Average" `
   -Operator "GreaterThan" `
   -Threshold "80.0"
   $ram = New-AzMetricAlertRuleV2Criteria `
   -MetricName "MemoryPercentage" `
   -MetricNamespace "Microsoft.Web/serverFarms" `
   -TimeAggregation "Average" `
   -Operator "GreaterThan" `
   -Threshold "80.0"


# https://docs.microsoft.com/en-us/powershell/module/az.monitor/add-azmetricalertrulev2?view=azps-2.2.0
Add-AzMetricAlertRuleV2 `
-Name "automatedCPUAlert" -ResourceGroupName $resourceGroup -TargetResourceId $appname `
-Description "Alert Created from Script" -Severity 4 -Condition $cond -ActionGroup $actionGroupId `
-WindowSize 0:5 -Frequency 0:5

Add-AzMetricAlertRuleV2 `
-Name "automatedRAMAlert" -ResourceGroupName $resourceGroup -TargetResourceId $appname `
-Description "Alert Created from Script" -Severity 4 -Condition $ram -ActionGroup $actionGroupId `
-WindowSize 0:5 -Frequency 0:5

}



#adi-eus2-analogcom-poc-sync-adf
#http errors
#webapp restart
#webapp stop
#failed buildpipelines
#PipelineSucceededRuns



#Microsoft.Azure.Management.Monitor.Management.Models.RuleAction

#Microsoft.DataFactory/factories
#PipelineFailedRuns
#PipelineSucceededRuns
#FailedHttpRequestCount


#Microsoft.Web/sites 
#Http401	Http 401	Count	Total	Http 401	Instance
#Http403	Http 403	Count	Total	Http 403	Instance
#Http404


"statusCodes": [
            {
              "status": "integer",
              "subStatus": "integer",
              "win32Status": "integer",
              "count": "integer",
              "timeInterval": "string"
            }