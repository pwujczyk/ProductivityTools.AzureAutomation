
. "$PSScriptRoot\PT.Configuration.ps1"
clear
function CreateCdnProfile(){
	$config=GetConfiguration
	New-AzCdnProfile -ProfileName $config.CdnProfileName -ResourceGroupName $config.ResourceGroup -Sku $config.CdnSku -Location $config.Location
}

function RemoveCdnProfile{
	$config=GetConfiguration
	Remove-AzCdnProfile -ProfileName $config.CdnProfileName -ResourceGroupName $config.ResourceGroup


}

function CreateCdnEndpoint(){
	$config=GetConfiguration
	$availability = Get-AzCdnEndpointNameAvailability -EndpointName $config.CdnEndpointName

	if($availability.NameAvailable) { 
		Write-Host "Yes, that endpoint name is available."
		New-AzCdnEndpoint -ProfileName $config.CdnProfileName -ResourceGroupName $config.ResourceGroup  -Location $config.Location -EndpointName $config.CdnEndpointName -OriginName "producvititytools" -OriginHostName "www.producvititytools.tech"

	}
	else 
	{ 
		Write-Host "No, that endpoint name is not available." 
	}
}

function RemoveCdnEndpoint(){
	$config=GetConfiguration
	Remove-AzCdnEndpoint -ProfileName $config.CdnProfileName -ResourceGroupName $config.ResourceGroup  -EndpointName $config.CdnEndpointName
}

function CreateCustomDomain(){
	$config=GetConfiguration
	
	$endpoint = Get-AzCdnEndpoint -ProfileName $config.CdnProfileName -ResourceGroupName $config.ResourceGroup -EndpointName $config.CdnEndpointName
	#$result = Test-AzCdnCustomDomain -CdnEndpoint $endpoint -CustomDomainHostName $config.CdnCustomDomain
	#if($result.CustomDomainValidated)
	
	New-AzCdnCustomDomain -CustomDomainName $config.CustomDomainName -HostName $config.CdnHostname -CdnEndpoint $endpoint 
	
}

CreateCdnProfile
CreateCdnEndpoint

#CreateCustomDomain
