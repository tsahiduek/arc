terraform init --backend-config=../general-config.s3.tfbackend
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform apply -var-file="workspaces/dev.tfvars"