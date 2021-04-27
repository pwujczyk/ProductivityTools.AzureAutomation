clear

cd $PSScriptRoot
Import-Module .\ProductivityTools.Azure.Scripts.psm1 -Force

#CreateResourceGroup -Profile "AzureProductivityTools2"  -Verbose
#RemoveResourceGroup -Profile "AzureProductivityTools2"  -Verbose

#Push-FileToAzureBlobStorage -Profile "AzureProductivityTools" -Path ".\blob\usflag.png" -Prefix "test" -Verbose

function RemoveAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveAll"
    
    $profile= "AzureProductivityTools2" 
    
	RemoveStorageContainer -Profile $profile -Verbose
	RemoveStorageAccount -Profile $profile -Verbose
	RemoveResourceGroup -Profile $profile -Verbose
}

function CreateAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateAll"
    
    $profile= "AzureProductivityTools2" 
    
	CreateResourceGroup -Profile $profile -Verbose
	CreateStorageAccount -Profile $profile  -Verbose
	CreateStorageContainer -Profile $profile  -Verbose
	SetStorageAccountCustomDomain -Profile $profile  -Verbose
	#AddFile
}
#CreateAll -Verbose
RemoveAll -Verbose
