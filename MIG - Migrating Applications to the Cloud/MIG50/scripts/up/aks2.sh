#!/bin/bash
set -eou pipefail
source ./scripts/variables.sh


echo "Creating AKS cluster $(clustername2) in resource group $(rg2)"
az aks create \
--resource-group $(rg2) \
--name $(clustername2) \
--node-count $(nodecount) \
--enable-addons monitoring,http_application_routing \
--generate-ssh-keys

# az aks enable-addons --resource-group $(rg) --name $AKS_CLUSTER_NAME --addons http_application_routing

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $(rg2) --name $(clustername2) --query "servicePrincipalProfile.clientId" --output tsv)
# Get the ACR registry resource id
ACR_ID=$(az acr show --name $(acrname) --resource-group $(rg) --query "id" --output tsv)
# Create role assignment
az role assignment create --assignee $CLIENT_ID --role Reader --scope $ACR_ID

# todo: moved to aks-applicationrouting. delete?
az aks show --resource-group $(rg2) --name $(clustername2) --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o tsv
