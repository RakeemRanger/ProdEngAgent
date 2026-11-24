targetScope = 'subscription'

// This Bicep template defines a custom policy for Azure Cognitive Services.

@description('The name of the policy definition.')
param policyName string = 'Disallow foundry local auth'

@description('The display name of the policy definition.')
param displayName string = 'Block foundry local auth'

@description('The description of the policy definition.')
param policyDescription string = 'Ranger AI Compliance - Local auth methods prohibited'

var policyRule = {
  if: {
    allOf: [
      {
        field: 'type'
        equals: 'Microsoft.CognitiveServices/accounts'
      }
      {
        field: 'Microsoft.CognitiveServices/accounts/disableLocalAuth'
        notEquals: true
      }
    ]
  }
  then: {
    effect: 'deny'
  }
}

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: policyName
  properties: {
    displayName: displayName
    policyType: 'Custom'
    mode: 'Indexed'
    description: policyDescription
    policyRule: policyRule
  }
}

output policyId string = policyDefinition.id

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2026-07-01' = {
  name: policyName
  properties: {
    policyDefinitionId: policyDefinition.id
  }
}
