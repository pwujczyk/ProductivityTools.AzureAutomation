

clear
. "$PSScriptRoot\PT.Configuration.ps1"


function CreateResourceGroup{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateResourceGroup"
	
	$config=GetConfiguration
	New-AzResourceGroup -Name $config.ResourceGroup -Location $config.Location
}

function RemoveResourceGroup{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveResourceGroup"
	
	$config=GetConfiguration
	Remove-AzResourceGroup -Name $config.ResourceGroup -Force
}

function CreateStorageAccount{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateStorageAccount"
	
	$config=GetConfiguration
	$storageAccount = New-AzStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName  -SkuName $config.SkuName -Location $config.Location -EnableHttpsTrafficOnly $False
	$ctx = $storageAccount.Context
}

function RemoveStorageAccount{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveStorageAccount"
	
	$config=GetConfiguration
	Remove-AzStorageAccount -Name $config.StorageName -ResourceGroupName $config.ResourceGroup -Force
}

function SetStorageAccountCustomDomain{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from SetStorageAccountCustomDomain"
	
	$config=GetConfiguration
	Set-AzStorageAccount -ResourceGroupName $config.ResourceGroup  -AccountName $config.StorageName  -CustomDomainName $config.CdnHostname
	
}

function CreateStorageContainer{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateStorageContainer"
	
	$config=GetConfiguration
	$context=GetContext
	New-AzStorageContainer -Name $config.ImagesContainerName -Context $context -Permission blob
}

function RemoveStorageContainer{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveStorageContainer"
	
	$config=GetConfiguration
	$context=GetContext
	Remove-AzStorageContainer -Name $config.ImagesContainerName -Context $context -Force
}

#function AddFile(){
#	$config=GetConfiguration
#	Set-AzStorageBlobContent -File "c:\Diagram.png" -Container $imagesContainerName -Blob "Diagram.png"  -Context $ctx 
#}

function RemoveAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveAll"
	
	RemoveStorageContainer -Verbose
	RemoveStorageAccount -Verbose
	RemoveResourceGroup -Verbose
}

function CreateAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateAll"
	
	CreateResourceGroup -Verbose
	CreateStorageAccount -Verbose
	CreateStorageContainer -Verbose
	SetStorageAccountCustomDomain -Verbose
	#AddFile
}
CreateAll -Verbose
#RemoveAll -Verbose





