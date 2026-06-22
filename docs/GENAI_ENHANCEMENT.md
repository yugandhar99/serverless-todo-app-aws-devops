# Optional GenAI Enhancement

This project includes an optional AI-ready release summary script:

```bash
node scripts/genai_release_summary.mjs
```

The current implementation runs in offline mode and generates a release-risk summary from Git metadata. This is safe for a public GitHub portfolio because it does not require API keys.

## How this can be upgraded in a real company

A production version can send sanitized CI/CD context to Amazon Bedrock or another approved internal GenAI service to generate:

- Release notes
- Infrastructure change summaries
- Security scan summaries
- Deployment risk summaries
- Incident postmortem first drafts

## Safe GenAI practices

- Do not send secrets, Terraform state, `.env` files, or customer data to a GenAI service.
- Redact API URLs, tokens, account IDs, and personally identifiable information.
- Keep human approval before production deployment.
- Store GenAI provider tokens in GitHub Actions secrets or use cloud-native identity.
