function GetConfiguration{
	[cmdletbinding()]
	param(
		[string]$Profile
	)

	$location = Get-MasterConfiguration $("$Profile"+":Location")
	$resourceGroup = Get-MasterConfiguration $("$Profile"+":ResourceGroup")
	$storageName = Get-MasterConfiguration $("$Profile"+":StorageName")
	$imagesContainerName = Get-MasterConfiguration $("$Profile"+":ImagesContainerName")

	$config = New-Object -TypeName psobject 
#	$config | Add-Member -MemberType NoteProperty -Name Location -Value $location
	$config | Add-Member -MemberType NoteProperty -Name ResourceGroup -Value $resourceGroup
	$config | Add-Member -MemberType NoteProperty -Name StorageName -Value $storageName
	# $config | Add-Member -MemberType NoteProperty -Name SkuName -Value "Standard_RAGRS"
	$config | Add-Member -MemberType NoteProperty -Name ImagesContainerName -Value $imagesContainerName


	# $config | Add-Member -MemberType NoteProperty -Name CdnProfileName -Value "productivitycdnprofile" 
	# $config | Add-Member -MemberType NoteProperty -Name CdnSku -Value "Standard_Akamai" 
	# $config | Add-Member -MemberType NoteProperty -Name CdnEndpointName -Value "ptblog" 
	# $config | Add-Member -MemberType NoteProperty -Name CdnHostname -Value "cdn.productivitytools.tech" 
	# $config | Add-Member -MemberType NoteProperty -Name CustomDomainName  -Value "cdn3" 
	return $config
}


function GetContext{

	[cmdletbinding()]
	param(
		[string]$Profile
	)
	

	$config=GetConfiguration $Profile
	$keys=Get-AzStorageAccountKey -ResourceGroupName $config.ResourceGroup -Name $config.StorageName
	$ctx=New-AzStorageContext -StorageAccountName $config.StorageName -StorageAccountKey $keys[0].value
	return $ctx
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