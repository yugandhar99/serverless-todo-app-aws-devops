# Security Policy

## Security Scope

This is a portfolio project that demonstrates secure serverless DevOps practices for AWS.

## Implemented Security Practices

- GitHub Actions deployment uses AWS OIDC role assumption instead of long-lived AWS access keys.
- Terraform state files and local `.env` files are ignored and removed from the repository.
- Lambda functions use least-privilege DynamoDB IAM permissions.
- DynamoDB point-in-time recovery is enabled by default.
- S3 frontend bucket blocks public access and is served through CloudFront Origin Access Control.
- CloudFront security headers are configured.
- Lambda X-Ray tracing and CloudWatch log retention are configured.
- Trivy, CodeQL, Checkov, and Dependabot workflows are included.
- CycloneDX SBOM generation is included as a CI artifact.

## Do Not Commit

Never commit:

- AWS access keys
- Terraform state files
- Terraform plan files
- `.env` files
- API tokens
- Cloud account IDs if your organization considers them sensitive
- Customer or production data

## Reporting Issues

For portfolio use, open a GitHub issue with the security concern. For production use, follow your organization’s responsible disclosure process.
