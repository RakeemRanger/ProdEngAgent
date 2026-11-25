targetScope = 'subscription'

param region string = 'eastus'
param groupName string = 'rai.dev.rg'
param msiName string = 'rai-dev-msi'

resource group 'Microsoft.Resources/resourceGroups@2025-04-01' = {
    location: region
    name: groupName
}

module msi 'managedIdentiy/msi.bicep' = {
    scope: group
    params: {
        msi_name: msiName
        region: region
    }
}

module foundryPolicy 'policy/foundryDisableLocalAuth.bicep' = {
}

