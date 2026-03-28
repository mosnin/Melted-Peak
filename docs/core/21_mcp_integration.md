# MCP Server Integration

Defines how external tools via MCP (Model Context Protocol) integrate with Melted Peak workflows.

## Configuration

MCP servers are configured in `.mcp.json` at the project root. Each server gives Claude access to external tools.

## Common MCP Servers for Melted Peak Projects

### GitHub
Enables: PR reviews, issue tracking, code search, repository management.
Integrates with: code-review skill, git-workflow skill, deployment-workflow skill.

### Database
Enables: Direct database queries, schema inspection.
Integrates with: data-modeling skill, database-migrations skill.

### Sentry/Error Tracking
Enables: Error monitoring, stack trace analysis.
Integrates with: incident-response skill, debugging skill.

### Slack/Communication
Enables: Team notifications, status updates.
Integrates with: deployment-workflow skill (deploy notifications), incident-response skill (alert channels).

## How MCP Tools Work with Skills

When a skill references an external tool (e.g., "check GitHub PR status"), the context compiler should verify:
1. Is the relevant MCP server configured in .mcp.json?
2. Is it currently connected?
3. If not, suggest setting it up or use alternative approaches

## Security

- MCP server credentials use environment variable references: `${GITHUB_TOKEN}`
- Never hardcode tokens in .mcp.json
- Use user-scoped servers (in ~/.claude.json) for personal credentials
- Use project-scoped servers (in .mcp.json) for team-shared tools
