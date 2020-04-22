
. "$PSScriptRoot\PT.Configuration.ps1"

function AddFile{
	
	[cmdletbinding()]
	param(
	[string]$Prefix,
	[string]$Path
	)
	
	Write-Verbose "Hello from AddFile"
	Write-Verbose "Path to file: $Path"
	Write-Verbose "Prefix: $Path"
	
	$file=Get-Item $Path
	$fileName=$file.Name
	$DestinationFileName="$Prefix\$fileName"
	Write-Verbose "Destination file name which will be placed on azure blob: $DestinationFileName"
	
	
	$config=GetConfiguration
	$context=GetContext
	$blob=Set-AzStorageBlobContent -File $Path -Container $config.ImagesContainerName -Blob $DestinationFileName  -Context $context -Force 
	return $blob
}
#clear
#Addfile "c:\Diagram.png"