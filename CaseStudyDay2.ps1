# CaseStudyDay2 - Configure a Virtual Network

# Task 1 - Get connected to your Azure subsription

$cred = Login-AzureRmAccount
$subscription = Get-AzureRmSubscription
$setsubsc = Get-AzureRmSubscription | Set-AzureRmContext

# Task 1.5 - Use variables with values from VM configuration
#          - Create Resource Group and Interface name
$ResourceGroupName = "CentralUsGroup1"
$InterfaceName = "VM2TxNICCard01"    # From Case Study specifications

# Task 2 - Create and configure the Interface Allocation Method

$nic = Get-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName
$nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
Set-AzureRmNetworkInterface -NetworkInterface $nic
