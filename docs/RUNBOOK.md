# Runbook

## Common Checks

### Frontend is not loading

1. Confirm CloudFront distribution status is Deployed.
2. Confirm S3 bucket contains the latest frontend build.
3. Run a CloudFront invalidation if cached files are stale.
4. Check browser console for the API URL used by `REACT_APP_API_URL`.

### API returns 500

1. Open the Lambda function logs in CloudWatch.
2. Search for structured log events such as `todo_create_failed` or `todo_update_failed`.
3. Confirm `DYNAMODB_TABLE` environment variable is set.
4. Confirm the Lambda role has DynamoDB permissions for the Todo table.

### API returns CORS error

1. Check `cors_allow_origin` in the Terraform tfvars file.
2. For production, use the CloudFront URL or custom domain instead of `*`.
3. Re-run Terraform apply and redeploy frontend.

### Terraform drift detected

1. Open the drift issue created by GitHub Actions.
2. Review the Terraform plan details.
3. If drift was intentional, import or update Terraform configuration.
4. If drift was accidental, run Terraform apply to reconcile the environment.

## Rollback

- Frontend: redeploy the previous build artifact or revert the frontend commit and rerun deployment.
- Backend: revert the Lambda code change and rerun the backend deployment.
- Infrastructure: revert the Terraform change and apply after reviewing the plan.
