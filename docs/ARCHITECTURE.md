# Architecture

This project is a serverless Todo application designed to show practical DevOps and cloud engineering skills without changing the original application recipe.

## Request Flow

1. User opens the React frontend through CloudFront.
2. CloudFront serves static assets from a private S3 bucket using Origin Access Control.
3. The frontend calls API Gateway HTTP API.
4. API Gateway routes requests to dedicated Lambda functions for each CRUD operation.
5. Lambda functions read/write Todo items in DynamoDB.
6. CloudWatch collects Lambda logs, metrics, and alarms.

![Architecture](../infra/static/images/architecture.png)

## CI/CD Flow

The project separates frontend, backend, and infrastructure pipelines. This mirrors real teams where application changes and infrastructure changes may have different approval paths.

![Terraform CI/CD](../infra/static/images/cicd.png)

### Frontend Pipeline

![Frontend CI/CD](../static/images/cicd/frontend.png)

### Backend Pipeline

![Backend CI/CD](../static/images/cicd/backend.png)

## Why this architecture is useful

- No long-running servers to patch.
- Infrastructure is reproducible through Terraform.
- Frontend and backend deploy independently.
- DynamoDB uses pay-per-request capacity for variable traffic.
- GitHub Actions validates code, Terraform, security, and dependency changes before deployment.
