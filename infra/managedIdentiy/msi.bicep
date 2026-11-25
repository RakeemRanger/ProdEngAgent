targetScope = 'resourceGroup'

param msi_name string
param region string


resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-05-31-preview' = {
  name: msi_name
  location: region
}

output uami_resource_id string = uami.id
