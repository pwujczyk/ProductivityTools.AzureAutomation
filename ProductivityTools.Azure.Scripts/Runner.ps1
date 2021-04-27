clear

cd $PSScriptRoot
Import-Module .\ProductivityTools.Azure.Scripts.psm1 -Force
Push-FileToAzureBlobStorage -Profile "AzureProductivityTools" -Path ".\blob\usflag.png" -Prefix "test" -Verbose
