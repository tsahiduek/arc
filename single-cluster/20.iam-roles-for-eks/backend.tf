# Configure remote state to use S3 and DynamoDB
terraform {
  backend "s3" {
    # bucket         = "tfstate-${data.aws_caller_identity.current.account_id}"
    key            = "iam/roles/terraform.tfstate"
    dynamodb_table = "tfstate-lock"
    # region         = data.aws_region.current.name
    # encrypt        = true
  }
}


