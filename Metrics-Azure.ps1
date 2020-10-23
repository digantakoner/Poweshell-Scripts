# Login and define the resource group #
function infra-alets([string]$resourceGroup, [string]$appname, [string]$actionGroupName)
{
$resourceGroup = "adi-eus2-analogcom-poc-rg"
$appname = "/subscriptions/fa8c5977-00e7-405f-a2be-7b64a977d0bb/resourceGroups/adi-eus2-analogcom-poc-rg/providers/Microsoft.Web/serverfarms/adi-eus2-tools-poc-shared-asp"
$actionGroupName = "cloud-ops-admin"
$actionGroup = Get-AzActionGroup -ResourceGroupName $resourceGroup -Name $actionGroupName
$actionGroupId = New-AzActionGroup -ActionGroupId $actionGroup.Id

# Define the metrics #

# System Parameters #

$CPU = New-AzMetricAlertRuleV2Criteria -MetricName "CpuPercentage" -MetricNamespace "Microsoft.Web/serverFarms" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold "80.0"

$Memory = New-AzMetricAlertRuleV2Criteria -MetricName "MemoryPercentage" -MetricNamespace "Microsoft.Web/serverFarms" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold "80.0"

# Application Builds #

$failure = New-AzMetricAlertRuleV2Criteria -MetricName "PipelineFailedRuns" -MetricNamespace "Microsoft.DataFactory/factories" -Aggregation "Total" -Operator "GreaterThan" -Threshold "3"

$success = New-AzMetricAlertRuleV2Criteria -MetricName "PipelineSucceededRuns" -MetricNamespace "Microsoft.DataFactory/factories" -Aggregation "Total" -Operator "GreaterThan" -Threshold "1"

#HTTP Errors #

$http401 = New-AzMetricAlertRuleV2Criteria -MetricName "Http401" -MetricNamespace "Microsoft.Web/sites" -Aggregation "Total" -Instace "URL"

$http403 = New-AzMetricAlertRuleV2Criteria -MetricName "Http403" -MetricNamespace "Microsoft.Web/sites" -Aggregation "Total" -Instace "URL"

$http404 = New-AzMetricAlertRuleV2Criteria -MetricName "Http404" -MetricNamespace "Microsoft.Web/sites" -Aggregation "Total" -Instace "URL"

}

Add-AzMetricAlertRuleV2 -Name "HTTP 403 errors" -ResourceGroupName $resourceGroup -TargetResourceId $appname -Description "Alert Created from Script" -Severity 4 -Condition $htt403 -ActionGroup $actionGroupId -WindowSize 0:5 -Frequency 0:5
