variable "aws_auth_roles" {

  description = "additional aws auth roles"

  default = {
    "EKSAdmin" = {
      "groups"   = "system:masters"
      "rolearn"  = "arn:aws:iam::481121494044:role/EKSAdmin"
      "username" = "system:node:{{EKSAdmin}}"
    }
    "EKSClusterAdmin" = {
      "groups"   = "system:masters"
      "rolearn"  = "arn:aws:iam::481121494044:role/EKSClusterAdmin"
      "username" = "system:node:{{EKSClusterAdmin}}"
    }
    "EKSEdit" = {
      "groups"   = "system:masters"
      "rolearn"  = "arn:aws:iam::481121494044:role/EKSEdit"
      "username" = "system:node:{{EKSEdit}}"
    }
    "EKSReader" = {
      "groups"   = "system:masters"
      "rolearn"  = "arn:aws:iam::481121494044:role/EKSReader"
      "username" = "system:node:{{EKSReader}}"
    }
  }
}
