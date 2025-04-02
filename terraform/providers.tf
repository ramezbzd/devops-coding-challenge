data "aws_eks_cluster_auth" "auth" {
  count = var.target_env == "aws" ? 1 : 0
  name = module.eks[0].cluster_name
}
provider "aws" {
  region     = "eu-central-1"
}

# Local Kubernetes provider (using your local kubeconfig)
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

# AWS provider
provider "helm" {
  alias = "aws"
  kubernetes = {
    host                   = var.target_env == "aws" ?  module.eks[0].cluster_endpoint : null
    cluster_ca_certificate = var.target_env == "aws" ? base64decode(module.eks[0].cluster_certificate_authority_data) : null
    token                  = var.target_env == "aws" ? data.aws_eks_cluster_auth.auth[0].token : null
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
  alias = "aws"
  host                   = var.target_env == "aws" ?  module.eks[0].cluster_endpoint : null
  cluster_ca_certificate = var.target_env == "aws" ? base64decode(module.eks[0].cluster_certificate_authority_data) : null
  token                  = var.target_env == "aws" ? data.aws_eks_cluster_auth.auth[0].token : null
}

