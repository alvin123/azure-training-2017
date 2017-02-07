# CaseStudyDay1 - Configure a Virtual Machine

# Task 1 - Get connected to your Azure subsription

$cred = Login-AzureRmAccount
$subscription = Get-AzureRmSubscription
$setsubsc = Get-AzureRmSubscription | Set-AzureRmContext

# Task 2 - Create Resource Group and Location name
$ResourceGroupName = "CentralUsGroup1"
$Location = "Central US"    
# for Scenario in Dallas, Texas, US
# feel free to change $Location to meet your needs

# Task 3 - Create storage account and storage type name
$storageName = "vmdallasstorage01"   # Dallas, but must be lowercase
$storageType = "Standard_LRS"        # Locally redudant - 3 replicas

# Task 3 step 3 - VNet and Subnet information
$InterfaceName = "VM2TxNICCard01"    # From Case Study specifications
$Subnet1Name = "FrontEndSubnet1"
$VNetName = "CentralUsVNet01"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"
$PublicIPAddressName = "shipsmartvip002"
$DNSNameLabel = "shipsmart02"

# Task 3 step 5 - VM information
$VMName = "VM2Tx"                    # Azure hosting name
$ComptuerName = "Server01"           # Windows name inside VM
$VMSize = "Standard_A2"              # pricing tier
$blobPath = "vhds/WindowsOSDisk.vhd" # for operating system disk

# Task 3 step 7 - now actually make the resource group
#               - and (step 9) a place to store the disks
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $storageName -Type $storageType -Location $Location

# Task 3 step 11 - now set up the public IP, subnet, VNet, and NIC
$PIP = New-AzureRmPublicIpAddress -Name $PublicIPAddressName -DomainNameLabel $DNSNameLabel -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIP.Id

# Task 3 step 13 - now set up the VM
$Credential = Get-Credential         # for the Windows username/password, not Azure subscription account
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisioningVMAgent -EnableAutoUpdate
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-DataCenter -Version "Latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
$OSDiskName = "WindowsOSDisk"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -vhdUri $OSDiskUri -CreateOption FromImage
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine

# Note that it will take 15-20 minutes for the virtual machine and its resources to be created.


