provider "aws" {
}



data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


# IAM roles and attached policies
locals {

  iam_roles = {
    EKSAdmin = {
      role_name         = "EKSAdmin"
      attached_policies = ["AmazonEKSClusterPolicy"]
    },
    EKSClusterAdmin = {
      role_name         = "EKSClusterAdmin"
      attached_policies = ["AmazonEKSClusterPolicy"]
    },
    EKSEdit = {
      role_name         = "EKSEdit"
      attached_policies = ["AmazonEKSClusterPolicy"]
    },
    EKSReader = {
      role_name         = "EKSReader"
      attached_policies = ["AmazonEKSClusterPolicy"]
    },
  }
}

# Create IAM roles and attach policies
resource "aws_iam_role" "iam_roles" {
  for_each = local.iam_roles

  name = each.value.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "iam_roles" {
  for_each = local.iam_roles

  role       = aws_iam_role.iam_roles[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.attached_policies[0]}"
}

# Output IAM roles map with names and ARNs
output "iam_roles_map" {
  value = {
    for role_name, role_config in aws_iam_role.iam_roles : role_name => role_config.arn
  }
}

output "iam_roles_aws_auth_list" {
  value = [
    for r in {
      for role_name, role_obj in local.iam_roles : role_name => {
        "rolearn"  = aws_iam_role.iam_roles[role_name].arn
        "username" = "system:node:{{${aws_iam_role.iam_roles[role_name].name}}}"
        "groups"   = ["system:masters"]
      }
    }
  : "${r}"]
}
