<#
    .AUTHOR
    Skip Cherniss

    .SYNOPSIS
    Create Shared Access Signature valid for one day    
#>

# *****************************************************************************
# * INITIALIZE VARIABLES
# *****************************************************************************

$resourceGroupName = 'rg-vstudio-hsld-sas-token-demo' 
$storageAccountName = 'stvstudiohsldsasdemo'

# Create Time Range using Zulu
# Time range will last for one day
$date = [System.DateTime]::Now
$StartTime = $date.ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'");
$ExpiryTime = $date.AddDays(1).ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'") 

# *****************************************************************************
# * GET THE STORAGE ACCOUNT CONTEXT
# *****************************************************************************

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

$ctx = $storageAccount.Context

# *****************************************************************************
# * New-AzStorageAccountSASToken
# *****************************************************************************
# *****************************************************************************
# * The New-AzStorageAccountSASToken can be leveraged to generate token for 
# * a single service or multiple services. This example generates for the
# * table service
# *****************************************************************************

#https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstorageaccountsastoken?view=azps-6.4.0

$sasTokenService = `
New-AzStorageAccountSASToken `
    -Service Table -ResourceType Service,Container,Object `
    -Permission "rwdlacu" `
    -StartTime $StartTime `
    -ExpiryTime $ExpiryTime `
    -Context $ctx 

# SAS Token Explanation
# https://docs.microsoft.com/en-us/rest/api/storageservices/create-account-sas?redirectedfrom=MSDN

<#
?sv=2020-04-08
&ss=t
&srt=sco
&st=2021-09-26T01%3A41%3A01Z
&se=2021-09-27T01%3A41%3A01Z
&sp=rwdlacu
&sig=53sj6qOnEZHUoHf0GDR5dChhVNq52MWeS9cCpaZbOnc%3D
#>
    
# Use the TableEndPoint property to construct the Table SAS Uri
# $ctx.TableEndPoint
# Value will be this with these settings
# "https://stvstudiohsldsasdemo.table.core.windows.net/

$tableName = 'fighterjets'
$baseUri = $ctx.TableEndPoint + $tableName
$tableSASUri = $baseUri + $sasTokenService

<#
https://stvstudiohsldsasdemo.table.core.windows.net/fighterjets?sv=2020-04-08&ss=t&srt=sco&st=2021-09-26T01%3A41%3A01Z&se=2021-09-27T01%3A41%3A01Z&sp=rwdlacu&sig=53sj6qOnEZHUoHf0GDR5dChhVNq52MWeS9cCpaZbOnc%3D
#>

<#
    # Example of IPAddressOrRange 
    -IPAddressOrRange "122.45.16.0-122.45.16.255" 
#>        


<# 
Additional cmdlets

New-AzStorageBlobSASToken
https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstorageblobsastoken?view=azps-6.4.0

New-AzStorageContainerSASToken
https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstoragecontainersastoken?view=azps-6.4.0

New-AzStorageFileSASToken
https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstoragefilesastoken?view=azps-6.4.0

New-AzStorageQueueSASToken
https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstoragequeuesastoken?view=azps-6.4.0

New-AzStorageTableSASToken
https://docs.microsoft.com/en-us/powershell/module/az.storage/new-azstoragetablesastoken?view=azps-6.4.0

#>