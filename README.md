<!--Category:PowerShell--> 
 <p align="right">
    <a href="https://www.powershellgallery.com/packages/ProductivityTools.PSGetOneDriveDirectory/"><img src="Images/Header/Powershell_border_40px.png" /></a>
    <a href="http://productivitytools.tech/get-onedrivedirectory/"><img src="Images/Header/ProductivityTools_green_40px_2.png" /><a> 
    <a href="https://github.com/pwujczyk/ProductivityTools.PSGetOneDriveDirectory"><img src="Images/Header/Github_border_40px.png" /></a>
</p>
<p align="center">
    <a href="http://http://productivitytools.tech/">
        <img src="Images/Header/LogoTitle_green_500px.png" />
    </a>
</p>


# Azure Automation

Module simplifies creating azure resources. 
<!--more-->

To achieve particular goal in azure you need to create couple of the resources in the proper order. For example I am hosting images to my blog on the Azure Blob Storage. To be able to store image on azure on the clean account I need to
- Create resource Group
- Create storage account
- Create storage container

And then I can finally push image. 

All those actions can be done manually, in PowerShell or other ways. 

In PowerShell creation is not so nice as to create storage account you need to provide name of the Resource Group. So very fast scripts written starts to passing a lot of references and code become difficult to manage. 

My idea here is to store the main names in the configuration and call only actions without the parameters. But of course it need to be flexible so I additionally introduced profiles. 

## MasterConfiguration

All information needed for creating resources should be stored in MasterConfiguration.

Below we see two profiles AzureProductivityTools and AzureProductivityTools2. Each of the profile contains needed configuration. 

```
  "AzureProductivityTools":{
	  "Location":"westeurope",
	  "ResourceGroup":"ptblog",
	  "StorageName":"ptblogstorage",
	  "SkuName":"Standard_RAGRS",
	  "StorageContainerName":"images",
	  "CdnHostname":"cdn2.productivitytools.tech"
  },
  
   "AzureProductivityTools2":{
	  "Location":"westeurope",
	  "ResourceGroup":"ptblog2",
	  "StorageName":"ptblogstorage2",
	  "SkuName":"Standard_RAGRS",
	  "StorageContainerName":"images",
	  "CdnHostname":"cdn2.productivitytools.tech"
  }
```

## Module actions - base

Module exposes following base actions

- Create-ResourceGroup
- Remove-ResourceGroup
- Create-StorageAccount
- Remove-StorageAccount
- Create-StorageContainer
- Remove-StorageContainer
- Set-StorageAccountCustomDomain

And one additional one
- Push-FileToAzureBlobStorage

To use base actions them we need to provide only the profile which we would like to use. Following command will create resource group with the name taken from the MasterConfiguration from the profile **AzureProductivityTools** so *ptblog*.

```powershell
CreateResourceGroup -Profile AzureProductivityTools -Verbose
```

## Module actions - additional

Module exposes following additional actions:

- Push-FileToAzureBlobStorage

This command has one parameter - path to the file:

```powershell
Push-FileToAzureBlobStorage -Profile AzureProductivityTools -Path D:\jpg\documentation.png
```

## Set of actions

I am combining actions to make final solution in Azure. For example for the purpose of storing images for a blog I am using 

```powershell
$profile= "AzureProductivityTools" 
    
CreateResourceGroup -Profile $profile -Verbose
CreateStorageAccount -Profile $profile  -Verbose
CreateStorageContainer -Profile $profile  -Verbose
``` 

And to remove resources

```powershell
$profile= "AzureProductivityTools2" 
    
RemoveStorageContainer -Profile $profile -Verbose
RemoveStorageAccount -Profile $profile -Verbose
RemoveResourceGroup -Profile $profile -Verbose

``` 