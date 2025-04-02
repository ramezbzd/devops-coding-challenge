data "aws_availability_zones" "available" {
  count = var.target_env == "aws" ? 1 : 0
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  count = var.target_env == "aws" ? 1 : 0
  source = "./modules/vpc"

  name     = local.cluster_name
  vpc_cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  tags            = local.tags
}

module "eks" {
  count = var.target_env == "aws" ? 1 : 0
  source = "./modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id     = module.vpc[0].vpc_id
  subnet_ids = module.vpc[0].private_subnets

  tags = local.tags
}

module "helm_aws" {
  count = var.target_env == "aws" ? 1 : 0
  source = "./modules/helm_releases"

  argocd_version = var.argocd_version
  github_token = var.github_token
  github_repository = var.github_repository

  depends_on = [ module.eks[0] ]
  providers = {
    helm = helm.aws
  }
}

module "helm" {
  count = var.target_env == "local" ? 1 : 0
  source = "./modules/helm_releases"

  argocd_version = var.argocd_version
  github_token = var.github_token
  github_repository = var.github_repository

  providers = {
    helm = helm
  }
}