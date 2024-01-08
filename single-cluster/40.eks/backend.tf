# Configure remote state to use S3 and DynamoDB
terraform {
  backend "s3" {
    bucket         = "tfstate-${data.aws_caller_identity.current.account_id}"
    key            = "eks/terraform.tfstate"
    region         = var.region
    dynamodb_table = "tfstate-lock"
    # encrypt        = true
  }
}
