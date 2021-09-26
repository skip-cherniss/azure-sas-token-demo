# Author: Skip M. Cherniss


# If you haven't already installed this
#Install-Module -Name Az -AllowClobber -Scope CurrentUser

if (Get-Module -ListAvailable -Name Az.*) {
    Write-Host "Az Module already installed"
}
else {
    Write-Host "Installing Az Module"
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}


### ///////////////////////////////////////////////////////////////////////////////////////////////
### *******  CONNECT TO AZURE
### ///////////////////////////////////////////////////////////////////////////////////////////////

$tenantId = ''
$subscriptionId = ''

Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId


$resourceGroupName = 'rg-vstudio-hsld-sas-token-demo' 
$location = 'centralus' 
$storageAccountName = 'stvstudiohsldsasdemo'


### ///////////////////////////////////////////////////////////////////////////////////////////////
### *******  CREATE RESOURCE GROUP
### ///////////////////////////////////////////////////////////////////////////////////////////////

New-AzResourceGroup -Name $resourceGroupName -Location $location

### ///////////////////////////////////////////////////////////////////////////////////////////////
### *******  CREATE STORAGE ACCOUNT
### ///////////////////////////////////////////////////////////////////////////////////////////////

# https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstorageaccount?view=azps-6.3.0
# SKUS - Tables and Queues are not supported on premium
# https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal
# https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
New-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $storageAccountName `
    -SkuName Standard_ZRS `
    -AccessTier Hot `
    -MinimumTlsVersion TLS1_2 `
    -AllowBlobPublicAccess $false `
    -EnableHttpsTrafficOnly $true 

