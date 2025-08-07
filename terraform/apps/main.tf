terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.29.0" }
  }
  # backend "local" { path = "apps.tfstate" }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
