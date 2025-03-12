terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}

  subscription_id = "d5e9eab9-3cc7-4080-8e91-24495bcc5427"  # Replace with your actual Subscription ID
}


resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "eastus"

}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_B2s"
    node_count = 1  # Static node count, no auto-scaling
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}
