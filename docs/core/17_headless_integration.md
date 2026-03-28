# Headless Integration Protocol

Defines how Melted Peak works with Claude Code's programmatic mode (`claude -p`) for CI/CD, automated workflows, and scripted usage.

## Headless Mode Basics

Claude Code's `-p` flag runs non-interactively:
```bash
claude -p "your prompt" --allowedTools "Read,Edit,Bash"
```

## Melted Peak in CI/CD

### Automated Audit
```bash
claude -p "Run the Melted Peak self-audit protocol at docs/core/20_self_audit_protocol.md. Report findings as JSON." --output-format json --allowedTools "Read,Glob,Grep"
```

### Automated Code Review
```bash
claude -p "Run the code-review skill on the staged changes. Use the standard depth level." --allowedTools "Read,Glob,Grep,Bash(git *)"
```

### Automated Handoff Generation
```bash
claude -p "Read active/active_context.md and memory/recent_deltas.md. Generate a session handoff summary and write it to memory/session_handoff.md." --allowedTools "Read,Write"
```

### Pre-Deploy Validation
```bash
claude -p "Run the deployment-workflow skill's pre-deployment validation checklist." --allowedTools "Read,Glob,Grep,Bash"
```

### Security Scan
```bash
claude -p "Run the security-audit skill. Focus on dependency vulnerabilities and secrets detection." --output-format json --allowedTools "Read,Glob,Grep,Bash(npm audit *)"
```

## Structured Output

Use `--output-format json` with `--json-schema` for machine-parseable results:
```bash
claude -p "Audit the Melted Peak system" --output-format json --json-schema '{"type":"object","properties":{"health":{"type":"string"},"issues":{"type":"array","items":{"type":"string"}}}}'
```

## GitHub Actions Integration

```yaml
name: Melted Peak Audit
on: [push]
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run MP Audit
        run: claude -p "Run /audit" --output-format json --allowedTools "Read,Glob,Grep"
```

## Best Practices
- Use `--bare` for consistent behavior across machines
- Use `--allowedTools` to pre-approve needed tools
- Use `--output-format json` for parseable output
- Use `--append-system-prompt` to inject Melted Peak context when needed
