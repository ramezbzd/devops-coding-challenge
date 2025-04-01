locals {
  cluster_name    = "crewmeister-challenge"
  cluster_version = "1.32"
  vpc_cidr        = "10.0.0.0/16"

  # Only use AWS availability zones when target_env is "aws"
  azs = var.target_env == "aws" ? slice(data.aws_availability_zones.available[0].names, 0, 3) : []
  
  # Only create subnets when target_env is "aws"
  private_subnets = var.target_env == "aws" ? [
    for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 1)
  ] : []
  
  public_subnets = var.target_env == "aws" ? [
    for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 101)
  ] : []


  tags = {
    Name = "crewmeister-challenge"
  }

}
