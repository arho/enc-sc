terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "fastapi_challenge" {
  name      = var.release_name
  chart     = var.chart_path
  namespace = var.namespace

  create_namespace = true
  wait             = true
  timeout          = 300

  values = [
    file("${path.module}/${var.values_file}")
  ]
}