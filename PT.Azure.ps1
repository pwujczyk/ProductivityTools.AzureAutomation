

clear
$location = "eastus"
$resourceGroup = "mainrg"
New-AzResourceGroup -Name $resourceGroup -Location $location

$storageName="mainsg"
$skuName="Standard_RAGRS"
$kind="StorageV2"
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageName  -SkuName $skuName -Location $location

$ctx = $storageAccount.Context

$keys=Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -Name $storageName
$ctx=New-AzStorageContext -StorageAccountName $storageName -StorageAccountKey $keys[0].value

$imagesContainerName="images"
New-AzStorageContainer -Name $imagesContainerName -Context $ctx -Permission blob
Set-AzStorageBlobContent -File "c:\Diagram.png" -Container $imagesContainerName -Blob "Diagram.png"  -Context $ctx 













#
##clear
##Install-Module az
#
##Connect-AzAccount #opens live login
#
#$location="westeurope"  
#$resourceGroupName="MainRG"
#
#New-AzResourceGroup -Name $resourceGroupName -Location $location
##
#
#
#$storageName="mainsg"
#$skuName="Standard_RAGRS"
#$kind="StorageV2"
##RAGRS https://docs.microsoft.com/pl-pl/azure/storage/common/storage-account-create?tabs=azure-powershell
#New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -SkuName $skuName -Kind $kind -Location $location
##Get-AzStorageAccount
#
#$imagesContainerName="images"
#$keys=Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageName
#$context=New-AzStorageContext -StorageAccountName $storageName -StorageAccountKey $keys[0].value
#New-AzStorageContainer -Name $imagesContainerName -Permission Container -Context $context
#
#
#
#$storageName="mainsg"
#$skuName="Standard_RAGRS"
#$kind="StorageV2"
#$imagesContainerName="images"
#Remove-AzStorageContainer -Name $imagesContainerName -Context $context
#Remove-AzStorageAccount -Name $storageName -ResourceGroupName $resourceGroupName
#Remove-AzResourceGroup -Name MainRG
#
##$context=New-AzureStorageContext -StorageAccountName $storageName -StorageAccountKey $keys[0].value
##New-AzureStorageContainer -Name "images" -Permission Container -Context $context
##$storageAccount=Get-AzStorageAccount -StorageAccountName mainsg -ResourceGroupName MainRG
#