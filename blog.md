# Building a Serverless Todo App on AWS with Terraform and GitHub Actions

A Todo app looks simple from the outside, but it is a good way to demonstrate real DevOps thinking when the application is deployed with cloud-native practices.

![Serverless Todo App](static/images/project.jpg)

## What I Built

This project is a serverless Todo application with a React frontend, Node.js Lambda backend, API Gateway HTTP API, DynamoDB table, and S3/CloudFront frontend hosting. The full AWS infrastructure is managed using Terraform.

## Why This Project Matters

The goal was not only to build CRUD functionality. The goal was to show how a simple app can be productionized with the same patterns used in real DevOps teams:

- Infrastructure as Code with Terraform
- Separate frontend, backend, and infrastructure pipelines
- GitHub Actions CI/CD
- OIDC-based AWS access instead of long-lived access keys
- Security scanning with Trivy, CodeQL, and Checkov
- DynamoDB point-in-time recovery
- CloudFront security headers
- CloudWatch alarms and Lambda log retention
- Terraform drift detection
- AI-ready release summary generation

## Architecture

![Architecture](infra/static/images/architecture.png)

The request flow is straightforward. Users load the frontend from CloudFront, which serves files from a private S3 bucket. The frontend calls API Gateway, API Gateway invokes Lambda functions, and Lambda stores Todo data in DynamoDB.

## CI/CD

The project includes separate pipelines for frontend, backend, infrastructure, drift detection, security scanning, and release summaries.

![Terraform CI/CD](infra/static/images/cicd.png)

### Frontend Pipeline

![Frontend CI/CD](static/images/cicd/frontend.png)

### Backend Pipeline

![Backend CI/CD](static/images/cicd/backend.png)

## What I Improved

I improved the backend Lambda handlers with validation, better HTTP status codes, JSON responses, structured logs, and safer DynamoDB operations. On the infrastructure side, I added stronger security and operations defaults such as DynamoDB PITR, CloudFront security headers, Lambda X-Ray tracing, log retention, CloudWatch alarms, and secret-safe GitHub Actions.

## What I Learned

Serverless projects are not only about writing Lambda functions. Real production readiness comes from deployment safety, observability, rollback planning, least-privilege IAM, and continuous security checks.

This project is a good example of how a basic application can be turned into a practical DevOps portfolio project without overcomplicating the original application recipe.
