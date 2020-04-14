

clear
. "$PSScriptRoot\PT.Configuration.ps1"


function CreateResourceGroup(){
	$config=GetConfiguration
	New-AzResourceGroup -Name $config.ResourceGroup -Location $config.Location
}

function RemoveResourceGroup(){
	$config=GetConfiguration
	Remove-AzResourceGroup -Name $config.ResourceGroup
}

function CreateStorageAccount(){
	$config=GetConfiguration
	$storageAccount = New-AzStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName  -SkuName $config.SkuName -Location $config.Location
	$ctx = $storageAccount.Context
}

function RemoveStorageAccount(){
	$config=GetConfiguration
	Remove-AzStorageAccount -Name $config.StorageName -ResourceGroupName $config.ResourceGroup
}

function CreateStorageContainer(){
	$config=GetConfiguration
	$context=GetContext
	New-AzStorageContainer -Name $config.ImagesContainerName -Context $context -Permission blob
}

function RemoveStorageContainer(){
	$config=GetConfiguration
	$context=GetContext
	Remove-AzStorageContainer -Name $config.ImagesContainerName -Context $context
}

#function AddFile(){
#	$config=GetConfiguration
#	Set-AzStorageBlobContent -File "c:\Diagram.png" -Container $imagesContainerName -Blob "Diagram.png"  -Context $ctx 
#}

function RemoveAll(){
	RemoveStorageContainer
	RemoveStorageAccount
	RemoveResourceGroup
}

function CreateAll(){
	CreateResourceGroup
	CreateStorageAccount
	CreateStorageContainer
	#AddFile
}
#CreateAll



