import { execSync } from 'node:child_process';
import { writeFileSync, mkdirSync } from 'node:fs';

const run = (command) => {
  try {
    return execSync(command, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch {
    return '';
  }
};

const changedFiles = run('git diff --name-only HEAD~1 HEAD') || run('git status --short');
const recentCommits = run('git log --oneline -5');

const classifyRisk = (files) => {
  if (/infra\/|\.github\/workflows\//.test(files)) return 'Medium';
  if (/src\/backend\//.test(files)) return 'Medium';
  if (/src\/frontend\//.test(files)) return 'Low';
  return 'Low';
};

const risk = classifyRisk(changedFiles);
const summary = `# AI-Ready Release Summary\n\nThis offline summary is designed to be used as a safe fallback when a GenAI provider is not configured. It summarizes the release context using repository metadata only.\n\n## Recent Commits\n\n\`\`\`text\n${recentCommits || 'No commit history available in this environment.'}\n\`\`\`\n\n## Changed Files\n\n\`\`\`text\n${changedFiles || 'No changed files detected.'}\n\`\`\`\n\n## Release Risk\n\n**${risk}**\n\n## Suggested Review Checklist\n\n- Review Terraform plan for infrastructure changes.\n- Confirm Lambda function changes pass unit tests.\n- Validate API Gateway URL in frontend environment settings.\n- Check Trivy, CodeQL, and dependency review results before production deployment.\n- Confirm CloudWatch alarms and drift detection workflow are enabled for production.\n`;

mkdirSync('reports', { recursive: true });
writeFileSync('reports/release-summary.md', summary);
console.log(summary);
