Login-AzureRmAccount
Get-AzureRmSubscription
Set-AzureRmContext -SubscriptionName #(YourCurrentSubscriptionGoesHere)#

Get-AzureRmWebApp
Get-AzureRmWebAppSlot -ResourceGroupName CentralUSGroup1 -Name #(YourCurrentWebAppNameGoesHere)#