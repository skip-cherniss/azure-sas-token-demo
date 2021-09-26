<#
    .AUTHOR
    Skip Cherniss

    .SYNOPSIS
    Create a table and add a row 
#>

# https://docs.microsoft.com/en-us/azure/storage/tables/table-storage-how-to-use-powershell
#AzTable will require modifying execution policy to remote signed, set it for just this process
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
Import-Module AzTable


# *****************************************************************************
# * INITIALIZE VARIABLES
# *****************************************************************************

$resourceGroupName = 'rg-vstudio-hsld-sas-token-demo' 
$storageAccountName = 'stvstudiohsldsasdemo'

# *****************************************************************************
# * GET THE STORAGE ACCOUNT CONTEXT
# *****************************************************************************

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

$ctx = $storageAccount.Context

# *****************************************************************************
# * CREATE THE TABLE
# *****************************************************************************

$tableName = 'fighterjets'

New-AzStorageTable -Name $tableName -Context $ctx

# *****************************************************************************
# * INSERT A ROW
# *****************************************************************************

$cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable

$partitionKey = 'Russia'

Add-AzTableRow `
    -table $cloudTable `
    -partitionKey $partitionKey `
    -rowKey $(New-Guid).ToString() `
    -property @{"jetname"="MIG-29";"pricemil"=23.8}


# *****************************************************************************
# * RETRIEVE ALL ENTITIES
# *****************************************************************************

Get-AzTableRow -table $cloudTable | ft

# *****************************************************************************
# * RETRIEVE ALL ENTITIES FOR A SPECIFIC PARTITION
# *****************************************************************************

Get-AzTableRow -table $cloudTable -partitionKey $partitionKey  | ft
Get-AzTableRow -table $cloudTable -partitionKey "USA"  | ft

