
. "$PSScriptRoot\PT.Configuration.ps1"

function AddFile([string]$filePath){
	$config=GetConfiguration
	$context=GetContext
	$blob=Set-AzStorageBlobContent -File $filePath -Container $config.ImagesContainerName -Blob "Diagram.png"  -Context $context 
	return $blob
}

Addfile "c:\Diagram.png"