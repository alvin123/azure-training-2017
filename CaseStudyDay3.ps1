# CaseStudyDay3 - Creating and configuring a web application

# Task 0 - Login to Azure

$cred = Login-AzureRmAccount
$subscription = Get-AzureRmSubscription
$setsubsc = Select-AzureRmSubscription -SubscriptionName "Pay-As-You-Go"  | Set-AzureRmContext

# Task 0 - Define Resource Group and Location name
$ResourceGroupName = "CentralUsGroup1"
$Location = "Central US"    

# Task 1 - Create a web application
$WebAppName = "shipsmartweb7654"     # must be a unique name
$AppServicePlan = "WebAppStandardPlan" 
$AppServicePlanType = "S1_Standard"  # Not used directly, use Tier and WorkerSize
$AppServiceTier = "Standard"
$AppServiceWorkerSize = "Small"
$DeploymentSlotName = "Staging"

New-AzureRmAppServicePlan -Name $AppServicePlan `
        -Tier $AppServiceTier -WorkerSize $AppServiceWorkerSize `
        -ResourceGroupName $ResourceGroupName -Location $Location 

New-AzureRmWebApp -Name $WebAppName -AppServicePlan $AppServicePlan `
        -Location $Location -ResourceGroupName $ResourceGroupName 

# We could get a reference to the WebApp (not just the name) by saving the 
# return value of New-AzureRmWebApp, however we use Get-AzureRmWebApp here
# so that this snippet of the script could be used *long after* the web
# app itself had been created, just to add a new slot as a later time.
$WebApp = Get-AzureRmWebApp -Name $WebAppName -ResourceGroupName $ResourceGroupName

# Do just *one* of the two following slot creation techniques - one with cloning, one without
# this version with cloning requires a Premium SKU? 
New-AzureRmWebAppSlot -Name $WebAppName -Slot $DeploymentSlotName `
        -ResourceGroupName $ResourceGroupName -AppServicePlan $AppServicePlan `
        -SourceWebApp $WebApp 

# this version does not do cloning
New-AzureRmWebAppSlot -Name $WebAppName -Slot $DeploymentSlotName `
        -ResourceGroupName $ResourceGroupName -AppServicePlan $AppServicePlan 



# Confirmation (login first if not done earlier)
Get-AzureRmWebApp

Get-AzureRmWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName




