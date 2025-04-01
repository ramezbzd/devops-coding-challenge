terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.5.2"
    }
  }
}