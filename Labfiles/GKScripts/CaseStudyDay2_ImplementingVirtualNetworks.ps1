$cred = Login-AzureRmAccount
$Subscription = Get-AzureRmSubscription
$setsubsc = Get-AzureRmSubscription | Set-AzureRmContext

$nic = Get-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName
$nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
Set-AzureRmNetworkInterface -NetworkInterface $nic