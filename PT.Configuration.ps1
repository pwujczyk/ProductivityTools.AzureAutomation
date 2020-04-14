function GetConfiguration(){
	$config = New-Object -TypeName psobject 
	$config | Add-Member -MemberType NoteProperty -Name Location -Value "eastus"
	$config | Add-Member -MemberType NoteProperty -Name ResourceGroup -Value "res2"
	$config | Add-Member -MemberType NoteProperty -Name StorageName -Value "mainsg2"
	$config | Add-Member -MemberType NoteProperty -Name SkuName -Value "Standard_RAGRS"
	$config | Add-Member -MemberType NoteProperty -Name ImagesContainerName -Value "images2"


	$config | Add-Member -MemberType NoteProperty -Name CdnProfileName -Value "productivitycdnprofile" 
	$config | Add-Member -MemberType NoteProperty -Name CdnSku -Value "Standard_Akamai" 
	$config | Add-Member -MemberType NoteProperty -Name CdnEndpointName -Value "ptblog" 
	$config | Add-Member -MemberType NoteProperty -Name CdnHostname -Value "cdn3.producvititytools.tech" 
	$config | Add-Member -MemberType NoteProperty -Name CustomDomainName  -Value "cdn3" 
	return $config
}


function GetContext(){
	$config=GetConfiguration
	$keys=Get-AzStorageAccountKey -ResourceGroupName $config.ResourceGroup -Name $config.StorageName
	$ctx=New-AzStorageContext -StorageAccountName $config.StorageName -StorageAccountKey $keys[0].value
	return $ctx
}