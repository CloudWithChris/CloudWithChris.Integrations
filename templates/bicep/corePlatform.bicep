param Identifier string = 'cwcservicebus' 

resource servicebus 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  name: Identifier
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource topic 'Microsoft.ServiceBus/namespaces/topics@2021-01-01-preview' = {
  name: '${servicebus.name}/actions'
  properties: { }
}

resource immediateSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-01-01-preview' = {
  name: '${topic.name}/Immediate'
  properties: { }
}

resource immediateSubscriptionFilter 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2021-01-01-preview' = {
  name: '${immediateSubscription.name}/immediateFilter'
  properties: {
    filterType: 'CorrelationFilter'
    correlationFilter: {
      properties: {
        actionType: 'immediate'
      }
    }
  }
}

resource scheduledSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-01-01-preview' = {
  name: '${topic.name}/Schedule'
  properties: { }
}

resource scheduleSubscriptionFilter 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2021-01-01-preview' = {
  name: '${scheduledSubscription.name}/scheduleFilter'
  properties: {
    filterType: 'CorrelationFilter'
    correlationFilter: {
      properties: {
        actionType: 'schedule'
      }
    }
  }
}

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'cwcintegrationstg2'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource tableServices 'Microsoft.Storage/storageAccounts/tableServices@2021-02-01' = {
  name: '${stg.name}/default'
  properties: {}
}

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-02-01' = {
  name: '${tableServices.name}/content'
}

resource cwcBlog 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'cwc-blog-watcher'
  location: resourceGroup().location
  properties: {
    //definition: Try and pull in an external workflow definition here.
  }
}
