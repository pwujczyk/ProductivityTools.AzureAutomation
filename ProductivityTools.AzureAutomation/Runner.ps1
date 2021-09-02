clear

cd $PSScriptRoot
Import-Module .\ProductivityTools.AzureAutomation.psm1 -Force

#CreateResourceGroup -Profile "AzureProductivityTools2"  -Verbose
#RemoveResourceGroup -Profile "AzureProductivityTools2"  -Verbose

#Push-FileToAzureBlobStorage -Profile "AzureProductivityTools2" -Path ".\blob\usflag.png" -Prefix "test" -Verbose
Get-ContainerItems -Profile "AzureProductivityTools2" -Verbose

function RemoveAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from RemoveAll"
    
    $profile= "AzureProductivityTools2" 
    
	Remove-StorageContainer -Profile $profile -Verbose
	Remove-StorageAccount -Profile $profile -Verbose
	Remove-ResourceGroup -Profile $profile -Verbose
}

function CreateAll{
	[cmdletbinding()]
	param()
	Write-Verbose "Hello from CreateAll"
    
    $profile= "AzureProductivityTools2" 
    
	Create-ResourceGroup -Profile $profile -Verbose
	Create-StorageAccount -Profile $profile  -Verbose
	Create-StorageContainer -Profile $profile  -Verbose
	Set-StorageAccountCustomDomain -Profile $profile  -Verbose
}
#CreateAll -Verbose
#RemoveAll -Verbose
