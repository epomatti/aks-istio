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
  default     = "Standard_B2ms"
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
  name     = "rg-istiodemo"
  location = var.location
}


### Log Analytics

# resource "azurerm_log_analytics_workspace" "default" {
#   name                = "log-myapp"
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }


### Kubernetes Cluster

resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks-${local.app}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  dns_prefix          = "aks-${local.app}"
  node_resource_group = "rg-k8s-istiodemo"

  # sku_tier 

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }

  # oms_agent {
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  # }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

}


# resource "azurerm_monitor_diagnostic_setting" "application_gateway" {
#   name                       = "Application Gateway Logs"
#   target_resource_id         = azurerm_kubernetes_cluster.default.ingress_application_gateway[0].effective_gateway_id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   log {
#     category = "ApplicationGatewayAccessLog"
#     enabled  = true

#     retention_policy {
#       days    = 7
#       enabled = true
#     }
#   }

#   log {
#     category = "ApplicationGatewayPerformanceLog"
#     enabled  = true

#     retention_policy {
#       days    = 7
#       enabled = true
#     }
#   }

#   log {
#     category = "ApplicationGatewayFirewallLog"
#     enabled  = true

#     retention_policy {
#       days    = 7
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true

#     retention_policy {
#       days    = 7
#       enabled = true
#     }
#   }

# }
