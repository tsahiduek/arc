provider "aws" {
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "vpc_name_prefix" {
  description = "Prefix for the name of the VPC"
  type        = string
  default     = "vpc-name"
}

locals {
  vpc_name = "${var.vpc_name_prefix}-applications"
  tags = {
    Name        = local.vpc_name
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name_prefix

  cidr = var.cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = [for i in range(length(data.aws_availability_zones.available.names)) : "10.0.${i + 1}.0/24"]
  public_subnets  = [for i in range(length(data.aws_availability_zones.available.names)) : "10.0.${length(data.aws_availability_zones.available.names) + i + 1}.0/24"]

  enable_nat_gateway = true

  tags = local.tags
}

locals {
  vpc_endpoint_services_interface = {
    aps               = "aps",
    aps_workspaces    = "aps-workspaces",
    grafana_workspace = "grafana-workspace",
    grafana           = "grafana",
    eks_auth          = "eks-auth",
    eks               = "eks",
    ecr_api           = "ecr.api",
    ecr_dkr           = "ecr.dkr",
    ec2               = "ec2",
    ec2_autoscaling   = "autoscaling",
    ebs               = "ebs",
  }
}

# Create VPC endpoints for specified AWS services using a loop
resource "aws_vpc_endpoint" "vpc_endpoints" {
  for_each = local.vpc_endpoint_services_interface

  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type = "Interface"

}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
