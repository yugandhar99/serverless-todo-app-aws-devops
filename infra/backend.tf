# Optional remote backend configuration.
# Uncomment and customize this block when you are ready to store Terraform state remotely.
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "serverless-todo/terraform.tfstate"
#     region         = "us-west-2"
#     dynamodb_table = "your-terraform-lock-table"
#     encrypt        = true
#   }
# }
