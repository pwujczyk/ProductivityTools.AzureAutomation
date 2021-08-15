<!--Category:PowerShell--> 
 <p align="right">
    <a href="https://www.powershellgallery.com/packages/ProductivityTools.AzureAutomation/"><img src="Images/Header/Powershell_border_40px.png" /></a>
    <a href="http://productivitytools.tech/get-onedrivedirectory/"><img src="Images/Header/ProductivityTools_green_40px_2.png" /><a> 
    <a href="https://github.com/pwujczyk/ProductivityTools.AzureAutomation"><img src="Images/Header/Github_border_40px.png" /></a>
</p>
<p align="center">
    <a href="http://http://productivitytools.tech/">
        <img src="Images/Header/LogoTitle_green_500px.png" />
    </a>
</p>


# Azure Automation

Module simplifies creating azure resources. 
<!--more-->

To achieve a particular goal in azure you need to create a couple of the resources in the proper order. For example, I am hosting images for my blog on Azure Blob Storage. To be able to store an image on azure on the clean account I need to
- Create resource Group
- Create a storage account
- Create a storage container

And then I can finally push the image. 

All those actions can be done manually, in PowerShell, or in other ways. 

In PowerShell creation is not so nice as to create a storage account you need to provide the name of the Resource Group. So very fast scripts written start to pass a lot of references and code become difficult to manage. 

My idea here is to store the main names in the configuration and call only actions without the parameters. But of course, it needs to be flexible so I additionally introduced profiles. 

## MasterConfiguration

All information needed for creating resources should be stored in MasterConfiguration.

Below we see two profiles AzureProductivityTools and AzureProductivityTools2. Each of the profiles contains the needed configuration. 

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

The module exposes following base actions

- Create-ResourceGroup
- Remove-ResourceGroup
- Create-StorageAccount
- Remove-StorageAccount
- Create-StorageContainer
- Remove-StorageContainer
- Set-StorageAccountCustomDomain

And one additional one
- Push-FileToAzureBlobStorage

To use base actions them we need to provide only the profile which we would like to use. Following command will create a resource group with the name taken from the MasterConfiguration from the profile **AzureProductivityTools** so *ptblog*.

```powershell
CreateResourceGroup -Profile AzureProductivityTools -Verbose
```

## Module actions - additional

Module exposes the following additional actions:

- Push-FileToAzureBlobStorage

This command has one parameter - path to the file:

```powershell
Push-FileToAzureBlobStorage -Profile AzureProductivityTools -Path D:\jpg\documentation.png
```

## Set of actions

I am combining actions to make the final solution in Azure. For example, for the purpose of storing images for a blog, I am using 

```powershell
$profile= "AzureProductivityTools" 
    
Create-ResourceGroup -Profile $profile -Verbose
Create-StorageAccount -Profile $profile  -Verbose
Create-StorageContainer -Profile $profile  -Verbose
``` 

And to remove resources

```powershell
$profile= "AzureProductivityTools" 
    
Remove-StorageContainer -Profile $profile -Verbose
Remove-StorageAccount -Profile $profile -Verbose
Remove-ResourceGroup -Profile $profile -Verbose

``` 