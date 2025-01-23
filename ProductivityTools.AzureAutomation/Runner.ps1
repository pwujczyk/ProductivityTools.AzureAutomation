clear

cd $PSScriptRoot
Import-Module .\ProductivityTools.AzureAutomation.psm1 -Force

Get-AzureBlobStorageFiles -Profile "Gosia"
Get-AzureBlobStorageFilesNames -Profile "Gosia"

#Remove-AzureBlobStorageFile -Profile "Gosia" -Name  "2021%20do%20kalendarza.zip" -Force -Verbose

#CreateResourceGroup -Profile "AzureProductivityTools2"  -Verbose
#RemoveResourceGroup -Profile "AzureProductivityTools2"  -Verbose

#Push-FileToAzureBlobStorage -Profile "AzureProductivityTools2" -Path ".\blob\usflag.png" -Prefix "test" -Verbose
#Get-AzureBlobStorageFiles -Profile "AzureProductivityTools2" 
#Remove-AzureBlobStorageFile -Profile "AzureProductivityTools2" -BlobName "test/usflag.png" -Force
#Get-AzureBlobStorageFiles -Profile "AzureProductivityTools2" 
#Remove-AzureBlobStorageFile -Profile "AzureProductivityTools2"-Name "PowershellApps.rar"
# function RemoveAll{
# 	[cmdletbinding()]
# 	param()
# 	Write-Verbose "Hello from RemoveAll"
    
#     $profile= "AzureProductivityTools2" 
    
# 	Remove-StorageContainer -Profile $profile -Verbose
# 	Remove-StorageAccount -Profile $profile -Verbose
# 	Remove-ResourceGroup -Profile $profile -Verbose
# }

# function CreateAll{
# 	[cmdletbinding()]
# 	param()
# 	Write-Verbose "Hello from CreateAll"
    
#     $profile= "AzureProductivityTools2" 
    
# 	Create-ResourceGroup -Profile $profile -Verbose
# 	Create-StorageAccount -Profile $profile  -Verbose
# 	Create-StorageContainer -Profile $profile  -Verbose
# 	#Set-StorageAccountCustomDomain -Profile $profile  -Verbose
# }
#CreateAll -Verbose
#RemoveAll -Verbose
