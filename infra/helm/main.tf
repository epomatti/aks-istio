terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  aks_name               = "aks-myapp"
  resource_group_name    = "rg-istiodemo"
  istio_charts           = "https://istio-release.storage.googleapis.com/charts"
  istio_system_namespace = "istio-system"
}

data "azurerm_kubernetes_cluster" "default" {
  name                = local.aks_name
  resource_group_name = local.resource_group_name
}

provider "helm" {
  kubernetes {
    host = data.azurerm_kubernetes_cluster.default.kube_config[0].host

    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  repository = local.istio_charts

  namespace        = local.istio_system_namespace
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "istiod"
  repository = local.istio_charts

  namespace        = local.istio_system_namespace
  create_namespace = false

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  chart      = "gateway"
  repository = local.istio_charts

  namespace        = "istio-ingress"
  create_namespace = true

  set {
    name  = "istio-injection"
    value = "enabled"
  }

  # provisioner "local-exec" {
  #   command = "helm status istiod -n istio-system"
  # }

  depends_on = [
    helm_release.istiod
  ]
}
