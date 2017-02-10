$cred = Login-AzureRmAccount
$Subscription = Get-AzureRmSubscription
$setsubsc = Get-AzureRmSubscription | Set-AzureRmContext

$ResourceGroupName = "CentralUsGroup1"
$Location = "Central US"

$storageName = "vmdallasstorage01"
$storageType = "Standard_LRS"

$InterfaceName = "VM2TxNICCard01"
$Subnet1Name = "FrontEndSubnet1"
$VNetName = "CentralUsVNet01"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"
$PublicIPAddressName = "shipsmartvip002"
$DNSNameLabel = "shipsmart002"

$VMName = "VM2Tx"
$ComputerName = "Server01"
$VMSize = "Standard_A1"
$blobPath = "vhds/WindowsOSDisk.vhd"

New-AzureRMResourceGroup -Name $ResourceGroupName -Location $Location

$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

$PIP = New-AzureRmPublicIpAddress -Name $PublicIPAddressName -DomainNameLabel $DNSNameLabel -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic

$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix

$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIP.Id

$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
$OSDiskName = "WindowsOSDisk"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage

New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine
