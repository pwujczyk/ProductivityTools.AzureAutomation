function GetConfiguration{
	param(
		[string]$Profile
	)

	if ($Profile -eq "")
	{
		throw "Get-Configuration Missing profile name!"
	}

	$location = Get-MasterConfiguration $("$Profile"+":Location")
	$resourceGroup = Get-MasterConfiguration $("$Profile"+":ResourceGroup")
	$storageName = Get-MasterConfiguration $("$Profile"+":StorageName")
	$skuName= Get-MasterConfiguration $("$Profile"+":SkuName")
	$storageContainerName = Get-MasterConfiguration $("$Profile"+":StorageContainerName")
	$cdnHostname = Get-MasterConfiguration $("$Profile"+":CdnHostname")

	$config = New-Object -TypeName psobject 
	$config | Add-Member -MemberType NoteProperty -Name Location -Value $location
	$config | Add-Member -MemberType NoteProperty -Name ResourceGroup -Value $resourceGroup
	$config | Add-Member -MemberType NoteProperty -Name StorageName -Value $storageName
	$config | Add-Member -MemberType NoteProperty -Name SkuName -Value $skuName
	$config | Add-Member -MemberType NoteProperty -Name StorageContainerName -Value $storageContainerName
	$config | Add-Member -MemberType NoteProperty -Name CdnHostname -Value $cdnHostname

	# $config | Add-Member -MemberType NoteProperty -Name CdnProfileName -Value "productivitycdnprofile" 
	# $config | Add-Member -MemberType NoteProperty -Name CdnSku -Value "Standard_Akamai" 
	# $config | Add-Member -MemberType NoteProperty -Name CdnEndpointName -Value "ptblog" 
	
	# $config | Add-Member -MemberType NoteProperty -Name CustomDomainName  -Value "cdn3" 
	return $config
}


function GetContext{

	[cmdletbinding()]
	param(
		[string]$Profile
	)

	if ($Profile -eq "")
	{
		throw "Get-Configuration Missing profile name!"
	}
	

	$config=GetConfiguration $Profile
	$keys=Get-AzStorageAccountKey -ResourceGroupName $config.ResourceGroup -Name $config.StorageName
	$ctx=New-AzStorageContext -StorageAccountName $config.StorageName -StorageAccountKey $keys[0].value
	return $ctx
}

function CreateResourceGroup{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from CreateResourceGroup"
	
	$config=GetConfiguration $Profile
	Write-Verbose "INVOKE COMMAND: New-AzResourceGroup -Name $($config.ResourceGroup) -Location $($config.Location)"
	New-AzResourceGroup -Name $config.ResourceGroup -Location $config.Location
}

function RemoveResourceGroup{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from RemoveResourceGroup"
	
	$config=GetConfiguration $Profile

	Write-Verbose "INVOKE COMMAND: Remove-AzResourceGroup -Name $($config.ResourceGroup) -Force"
	Remove-AzResourceGroup -Name $config.ResourceGroup -Force
}

function CreateStorageAccount{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)
	Write-Verbose "Hello from CreateStorageAccount"
	
	$config=GetConfiguration $Profile
	Write-Verbose "INVOKE COMMAND: New-AzStorageAccount -ResourceGroupName $($config.ResourceGroup) -Name $($config.StorageName)  -SkuName $($config.SkuName) -Location $($config.Location) -EnableHttpsTrafficOnly $($False)"

	$storageAccount = New-AzStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName  -SkuName $config.SkuName -Location $config.Location -EnableHttpsTrafficOnly $False
	#$ctx = $storageAccount.Context
}

function RemoveStorageAccount{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)
	Write-Verbose "Hello from RemoveStorageAccount"
	
	$config=GetConfiguration $Profile
	Write-Verbose "INVOKE COMMAND: Remove-AzStorageAccount -Name $($config.StorageName) -ResourceGroupName $($config.ResourceGroup) -Force"
	Remove-AzStorageAccount -Name $config.StorageName -ResourceGroupName $config.ResourceGroup -Force
}

function CreateStorageContainer{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from CreateStorageContainer"
	
	$config=GetConfiguration -Profile $Profile
	$context=GetContext -Profile $Profile
	Write-Verbose "INVOKE COMMAND: New-AzStorageContainer -Name $($config.StorageContainerName) -Context $($context) -Permission blob"
	New-AzStorageContainer -Name $config.StorageContainerName -Context $context -Permission blob
}

function RemoveStorageContainer{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from RemoveStorageContainer"
	
	$config=GetConfiguration -Profile $Profile
	$context=GetContext -Profile $Profile
	Write-Verbose "INVOKE COMMAND: Remove-AzStorageContainer -Name $($config.StorageContainerName) -Context $($context) -Force"
	Remove-AzStorageContainer -Name $config.StorageContainerName -Context $context -Force
}

function SetStorageAccountCustomDomain{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from SetStorageAccountCustomDomain"
	
	$config=GetConfiguration -Profile $Profile
	Write-Verbose "INVOKE COMMAND: Set-AzStorageAccount -ResourceGroupName $($config.ResourceGroup)  -AccountName $($config.StorageName)  -CustomDomainName $($config.CdnHostname)"

	Set-AzStorageAccount -ResourceGroupName $config.ResourceGroup  -AccountName $config.StorageName  -CustomDomainName $config.CdnHostname
	
}

function Push-FileToAzureBlobStorage{
	
	[cmdletbinding()]
	param(
		[string]$Profile,
		[string]$Prefix,
		[string]$Path
	)
	
	Write-Verbose "Hello from AddFile"
    Write-Verbose "Prefix: $Prefix"
	Write-Verbose "Path to file: $Path"
	
	$file=Get-Item $Path
	$fileName=$file.Name
	$DestinationFileName="$Prefix\$fileName"
	Write-Verbose "Destination file name which will be placed on azure blob: $DestinationFileName"
	
	
	$config=GetConfiguration $Profile
	$context=GetContext $Profile
	$blob=Set-AzStorageBlobContent -File $Path -Container $config.ImagesContainerName -Blob $DestinationFileName -Context $context -Force 
	return $blob
}