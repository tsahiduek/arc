variable "workspace" {
  default     = "dev"
  description = "workspce value"
  type        = string
}

data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = var.workspace
  config = {
    bucket = "tfstate-${data.aws_caller_identity.current.account_id}"
    key    = "networking/vpc/terraform.tfstate"
    region = data.aws_region.current.name
  }
}

data "terraform_remote_state" "iam" {
  backend   = "s3"
  workspace = var.workspace
  config = {
    bucket = "tfstate-${data.aws_caller_identity.current.account_id}"
    key    = "iam/roles/terraform.tfstate"
    region = data.aws_region.current.name
  }
}

