# GitHub Upload Steps

## Recommended Repo Name

```text
serverless-todo-app-aws-devops
```

## Create Repository

When creating the repo on GitHub, keep these unchecked because the project already has them:

```text
Add README file      unchecked
Add .gitignore       unchecked
Choose license       unchecked
```

## Upload Using GitHub Website

If you upload from the browser, GitHub may block more than 100 files at once. Upload in batches:

### Batch 1

```text
README.md
SECURITY.md
PORTFOLIO_NOTES.md
GITHUB_UPLOAD_STEPS.md
blog.md
LICENSE
.gitignore
.pre-commit-config.yaml
docs
static
.github
```

### Batch 2

```text
infra
```

### Batch 3

```text
src/backend
```

### Batch 4

```text
src/frontend
```

## Upload Using Git Commands

```bash
git init
git add .
git commit -m "Initial commit - serverless todo app devops edition"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/serverless-todo-app-aws-devops.git
git push -u origin main
```

## After Upload

Add these repository secrets only if you want to run deployment workflows:

```text
AWS_ROLE_TO_ASSUME
AWS_REGION
AWS_S3_BUCKET
CLOUDFRONT_DISTRIBUTION_ID
REACT_APP_API_URL
```

Validation and security workflows can run without deploying to AWS.
