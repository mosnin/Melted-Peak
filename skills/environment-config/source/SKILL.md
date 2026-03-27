# Skill: Environment & Configuration Management

## Purpose
Manage environment variables, secrets, configuration layers, and feature flags safely. Prevent configuration-related bugs and security issues.

## Trigger
- Setting up a new project or environment
- Adding new environment variables or secrets
- Deploying to a new environment
- Reviewing configuration security
- Implementing feature flags

## Workflow

### Step 1: Classify Configuration

| Type | Examples | Storage | Commits? |
|------|---------|---------|----------|
| **Public config** | App name, API URL, feature toggles | `.env` / config files | Yes (non-sensitive) |
| **Secrets** | API keys, DB passwords, JWT secrets | Vault / env vars only | NEVER |
| **Build config** | Node version, build flags, compile options | Package.json, config files | Yes |
| **Runtime config** | Log level, cache TTL, rate limits | Env vars or config service | Depends |

### Step 2: Environment Variable Conventions

#### Naming
```
PREFIX_CATEGORY_NAME

Examples:
  NEXT_PUBLIC_API_URL      (public, exposed to client)
  DATABASE_URL             (secret, server only)
  STRIPE_SECRET_KEY        (secret, server only)
  NEXT_PUBLIC_APP_NAME     (public, exposed to client)
  REDIS_URL                (secret, server only)
```

Rules:
- SCREAMING_SNAKE_CASE always
- Prefix with `NEXT_PUBLIC_` only if intentionally client-exposed
- Group by service: `DATABASE_`, `STRIPE_`, `REDIS_`, `AUTH_`
- Never put secrets in client-accessible vars

#### .env File Strategy
```
.env.example      ← Committed. Documented template with placeholder values.
.env.local        ← Gitignored. Local development overrides.
.env.development  ← Optional. Shared dev defaults (non-secret only).
.env.production   ← Never committed. Production secrets in vault/CI.
```

### Step 3: Validate Configuration

Use fail-fast validation at startup (T3 Env pattern):

```
Define schema:
  DATABASE_URL: required, string, starts with postgres://
  STRIPE_SECRET_KEY: required, string, starts with sk_
  NEXT_PUBLIC_APP_URL: required, string, valid URL
  LOG_LEVEL: optional, enum(debug|info|warn|error), default: info

At app start:
  Validate all env vars against schema
  Fail immediately with clear error if any are missing or invalid
  Never silently use undefined values
```

### Step 4: Manage Secrets

| Rule | Why |
|------|-----|
| Never commit secrets to git | Even in "private" repos, git history is permanent |
| Never log secrets | Logs are often aggregated and searchable |
| Use different secrets per environment | Compromise in dev shouldn't affect production |
| Rotate secrets on schedule | Limits exposure window from unknown compromises |
| Use vault services in production | AWS Secrets Manager, HashiCorp Vault, Vercel env vars |
| Audit secret access | Know who/what has access to each secret |

If a secret is accidentally committed:
1. Rotate the secret immediately (generate new one)
2. Revoke the old secret
3. Remove from git history (BFG Repo-Cleaner or git filter-branch)
4. Audit for unauthorized use during exposure window

### Step 5: Environment Parity

Minimize differences between environments:

| Should be SAME | Should DIFFER |
|---------------|--------------|
| Application code | Database credentials |
| Dependencies (lock file) | API keys (use test keys in dev) |
| Config schema | Domain/URLs |
| Feature flag names | Feature flag values (sometimes) |
| Build process | Scale/resources |

### Step 6: Feature Flags

Use feature flags for:
- Gradual rollouts (enable for 10% → 50% → 100%)
- Kill switches (disable broken feature without deploy)
- A/B testing (different experiences for different users)

Simple implementation:
```
FEATURE_NEW_DASHBOARD=true
FEATURE_DARK_MODE=true
FEATURE_BETA_API=false
```

Rules:
- Name flags with `FEATURE_` prefix
- Default to `false` (features off by default)
- Remove flag AND code path after full rollout
- Document each flag's purpose and expected removal date

### Step 7: Configuration Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Hardcoded values | Can't change without deploy | Extract to config |
| Magic strings | Unclear meaning, typo-prone | Named constants or enum |
| Environment checks scattered in code | `if (process.env.NODE_ENV === ...)` everywhere | Centralize in config module |
| Optional config with no default | Silent undefined at runtime | Validate + provide defaults |
| Copying .env between machines | Drift, stale secrets | Use .env.example + personal .env.local |

## Integration with Melted Peak

- **Change plan**: Config changes (new env vars, secret rotation) need a change plan
- **Regression checklist**: Add env-dependent code as sensitive areas
- **Known issues**: Log configuration drift or missing env vars
- **Deployment skill**: Pre-deploy config verification
