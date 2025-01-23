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

function Create-ResourceGroup{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from CreateResourceGroup"
	
	$config=GetConfiguration $Profile

	Write-Verbose "INVOKE COMMAND: Get-AzResourceGroup -Name $($config.ResourceGroup) -Location $($config.Location)"
	$rg=Get-AzResourceGroup -Name $config.ResourceGroup -Location $config.Location -ErrorAction SilentlyContinue

	if($rg -eq $null)
	{
		Write-Verbose "INVOKE COMMAND: New-AzResourceGroup -Name $($config.ResourceGroup) -Location $($config.Location)"
		New-AzResourceGroup -Name $config.ResourceGroup -Location $config.Location
	}
	else
	{
		Write-Verbose "Resource group exists - ommiting"
	}
}

function Remove-ResourceGroup{
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

function Create-StorageAccount{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)
	Write-Verbose "Hello from CreateStorageAccount"
	
	$config=GetConfiguration $Profile

	Write-Verbose "INVOKE COMMAND: $gs=Get-AZStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName -ErrorAction SilentlyContinue"
	$gs=Get-AZStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName -ErrorAction SilentlyContinue
	if ($gs -eq $null)
	{
		Write-Verbose "INVOKE COMMAND: New-AzStorageAccount -ResourceGroupName $($config.ResourceGroup) -Name $($config.StorageName)  -SkuName $($config.SkuName) -Location $($config.Location) -EnableHttpsTrafficOnly $($False)"
		Write-Verbose "Name of the storage account name needs to be unique across azure as it will translate to the address: https://accountname.blob.core.windows.net"
		$storageAccount = New-AzStorageAccount -ResourceGroupName $config.ResourceGroup -Name $config.StorageName  -SkuName $config.SkuName -Location $config.Location -EnableHttpsTrafficOnly $False
	}
	else
	{
		Write-Verbose "Storage account exists - ommiting"
	}
	#$ctx = $storageAccount.Context
}

function Remove-StorageAccount{
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

function Create-StorageContainer{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$Profile
	)

	Write-Verbose "Hello from CreateStorageContainer"
	
	$config=GetConfiguration -Profile $Profile
	$context=GetContext -Profile $Profile
	
			
	Write-Verbose "INVOKE COMMAND: =Get-AzStorageContainer -Name $config.StorageContainerName -Context $context -ErrorAction SilentlyContinue"

	$sc=Get-AzStorageContainer -Name $config.StorageContainerName -Context $context -ErrorAction SilentlyContinue
	if($sc -eq $null)
	{
		Write-Verbose "INVOKE COMMAND: New-AzStorageContainer -Name $($config.StorageContainerName) -Context $($context) -Permission blob"
		New-AzStorageContainer -Name $config.StorageContainerName -Context $context -Permission blob
	}
	else
	{
		Write-Verbose "Storage account exists - ommiting"
	}
}

function Remove-StorageContainer{
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

function Set-StorageAccountCustomDomain{
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

	if($Prefix -ne "" -and $Prefix -ne $null)
	{
		$DestinationFileName="$Prefix\$fileName"
	}
	else
	{
		$DestinationFileName=$fileName
	}
	
	Write-Verbose "Destination file name which will be placed on azure blob: $DestinationFileName"
	
	
	$config=GetConfiguration $Profile
	$context=GetContext $Profile
	$blob=Set-AzStorageBlobContent -File $Path -Container $config.StorageContainerName -Blob $DestinationFileName -Context $context -Force 
	return $blob
}

function Get-AzureBlobStorageFiles(){
		[cmdletbinding()]
	param(
		[string]$Profile
	)

	$context=GetContext $Profile
	$config=GetConfiguration $Profile
	Write-Verbose "Storage container name: $($config.StorageContainerName)"
	$blobs=Get-AzStorageBlob -Context $context -Container $config.StorageContainerName 
	foreach($blob in $blobs){
		Write-Output $blob.BlobClient.Uri.AbsoluteUri
	}
}

function Get-AzureBlobStorageFilesNames(){
		[cmdletbinding()]
	param(
		[string]$Profile
	)

	$context=GetContext $Profile
	$config=GetConfiguration $Profile
	Write-Verbose "Storage container name: $($config.StorageContainerName)"
	$blobs=Get-AzStorageBlob -Context $context -Container $config.StorageContainerName 
	foreach($blob in $blobs){
		Write-Output $blob.Name
	}
}


function RemoveBlob(){
	
	[cmdletbinding()]
	param(
		[string]$Profile,
		[Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageBlob]$Blob
	)

	$context=GetContext $Profile
	Remove-AzStorageBlob -Container "ContainerName" -Blob "BlobName"

}

function Remove-AzureBlobStorageFile(){
	
	[cmdletbinding()]
	param(
		[string]$Profile,
		[string]$Name,
		[switch]$Force
	)

	$context=GetContext $Profile
	$config=GetConfiguration $Profile
	Write-Verbose "Storage container name: $($config.StorageContainerName)"
	$blobs=Get-AzStorageBlob -Context $context -Container $config.StorageContainerName 
	
	foreach($blob in $blobs){
		Write-Verbose "$($blob.Name) compared to $Name"
		if($blob.Name -eq $Name){
			if($Force.IsPresent)
			{
				Remove-AzStorageBlob -Container $config.StorageContainerName -Blob "$Name" -Context $context
			}
			else
			{
				Write-Output "Are you sure you would like to remove $($blob.BlobClient.Uri.AbsoluteUri)? (y/n)"
				$answer=Read-Host
				if($answer -eq "y")
				{
					Remove-AzStorageBlob -Container $config.StorageContainerName -Blob "$Name" -Context $context
				}
			}
		}
	}
}

Export-ModuleMember Create-ResourceGroup
Export-ModuleMember Remove-ResourceGroup
Export-ModuleMember Create-StorageAccount
Export-ModuleMember Remove-StorageAccount
Export-ModuleMember Create-StorageContainer
Export-ModuleMember Remove-StorageContainer
Export-ModuleMember Set-StorageAccountCustomDomain
Export-ModuleMember Push-FileToAzureBlobStorage
Export-ModuleMember Get-AzureBlobStorageFiles
Export-ModuleMember Remove-AzureBlobStorageFile
Export-ModuleMember Get-AzureBlobStorageFilesNames
