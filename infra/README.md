# Infrastructure - Serverless Todo App

This folder contains Terraform code for the AWS serverless infrastructure.

## Resources Created

- DynamoDB Todo table with pay-per-request billing and point-in-time recovery
- Lambda CRUD functions for Todo operations
- API Gateway HTTP API routes
- IAM execution roles and least-privilege DynamoDB policy
- CloudWatch log retention and Lambda error alarms
- S3 private frontend bucket
- CloudFront distribution with Origin Access Control and security headers

## Folder Structure

```text
infra/
├── envs/
│   ├── dev.tfvars
│   └── prod.tfvars
├── modules/
│   ├── backend/
│   └── frontend/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

## Local Commands

```bash
terraform fmt -recursive
terraform init
terraform workspace new dev || terraform workspace select dev
terraform validate
terraform plan -var-file=envs/dev.tfvars
```

## Apply

```bash
terraform apply -var-file=envs/dev.tfvars
```

For production, use the `prod` workspace and review the plan before applying.

## Security Notes

Do not commit Terraform state files, plan files, local `.env` files, or AWS credentials. The root `.gitignore` and `infra/.gitignore` are configured to block those files.
