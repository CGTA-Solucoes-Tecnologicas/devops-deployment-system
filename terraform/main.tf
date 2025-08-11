terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.29.0" }
    helm       = { source = "hashicorp/helm",       version = ">= 2.13.0" }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes { config_path = "~/.kube/config" }
}
