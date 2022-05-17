terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.6.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

### Variables

variable "location" {
  type    = string
  default = "westus"
}

variable "aks_vm_size" {
  description = "Kubernetes VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "aks_node_count" {
  type    = number
  default = 1
}

### Local Variables

locals {
  app = "myapp"
}


### Resource Group

resource "azurerm_resource_group" "default" {
  name     = "rg-istodemo"
  location = var.location
}


### Kubernetes Cluster

resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks-${local.app}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  dns_prefix          = "aks-${local.app}"
  node_resource_group = "rg-k8s-istiodemo"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

}
