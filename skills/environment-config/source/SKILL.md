# Skill: Environment Config

## Purpose
Comprehensive guide for environment and configuration management. Covers environment variable strategy, secret management, configuration layers, type-safe validation, environment parity, .env file management, feature flags, and common anti-patterns.

## Trigger
- Setting up configuration for a new project or service
- Refactoring inconsistent or scattered configuration patterns
- Reviewing secret management or adding new secrets
- Adding feature flags or configuration layers
- Debugging environment-specific failures
- Writing a change plan that modifies configuration

---

## 1. Environment Variable Strategy

### Naming Conventions
Use a consistent prefix and structure for all environment variables:

```
<APP>_<GROUP>_<NAME>
```

Examples:
- `MYAPP_DB_HOST`, `MYAPP_DB_PORT`, `MYAPP_DB_NAME`
- `MYAPP_REDIS_URL`
- `MYAPP_AUTH_SECRET`, `MYAPP_AUTH_ISSUER`
- `MYAPP_SMTP_HOST`, `MYAPP_SMTP_PORT`
- `MYAPP_FEATURE_NEW_DASHBOARD`

### Naming Rules
| Rule | Example | Why |
|------|---------|-----|
| Use SCREAMING_SNAKE_CASE | `MYAPP_DB_HOST` | Universal convention for env vars |
| Prefix with app name | `MYAPP_*` | Prevents collisions with system or third-party vars |
| Group by concern | `MYAPP_DB_*`, `MYAPP_AUTH_*` | Makes related vars easy to find and document |
| Use descriptive names | `MYAPP_DB_CONNECTION_POOL_SIZE` | Never abbreviate ambiguously |
| Boolean vars use positive names | `MYAPP_FEATURE_ANALYTICS_ENABLED` | Avoid double negatives like `DISABLE_X=false` |

### Framework-Specific Prefixes
Some frameworks use special prefixes to control variable exposure:
- `NEXT_PUBLIC_*` -- exposed to the browser in Next.js
- `VITE_*` -- exposed to the browser in Vite
- `REACT_APP_*` -- exposed to the browser in Create React App

Never put secrets in client-exposed prefixes. Only public, non-sensitive values belong there.

### Documentation
Every environment variable must be documented in one of:
- The `.env.example` file with a comment explaining its purpose
- A config schema file (preferred -- self-documenting and validated)
- A dedicated config section in the project README (least preferred)

Document for each variable:
- What it controls
- Whether it is required or optional
- Its default value (if any)
- Valid values or format (e.g., URL, integer, comma-separated list)

---

## 2. Secret Management

### What Must Never Be in Code
These must ONLY exist in environment variables, secret managers, or vaults -- never in source code, config files checked into git, or log output:

- API keys and tokens
- Database credentials (passwords, connection strings with credentials)
- Encryption keys and signing secrets (e.g., JWT secrets)
- OAuth client secrets
- SMTP credentials
- Third-party service credentials
- TLS/SSL private keys
- Webhook signing secrets

### Detection
- Use `.gitignore` to exclude `.env`, `.env.local`, and any file containing secrets
- Add pre-commit hooks or CI checks that scan for high-entropy strings, known secret patterns (e.g., `sk_live_`, `AKIA`), and file patterns (`.pem`, `.key`)
- Review pull requests for accidental secret inclusion

### If a Secret Is Accidentally Committed
1. Rotate the secret immediately (generate a new one)
2. Revoke the old secret
3. Remove from git history (BFG Repo-Cleaner or git filter-branch)
4. Audit for unauthorized use during the exposure window

### Secret Rotation
- Secrets should be rotatable without code deployment
- Design systems to support two active versions of a secret during rotation (old and new both valid for a transition period)
- Automate rotation where possible (e.g., database credential rotation via vault)
- After rotation, verify the old secret no longer works

### Vault Patterns
For production systems, use a secret manager rather than plain environment variables:

| Approach | When to Use |
|----------|------------|
| Environment variables | Small projects, local development, single-server deployments |
| Secret manager (AWS Secrets Manager, GCP Secret Manager, HashiCorp Vault) | Production systems, teams, anything with rotation requirements |
| Encrypted config files (SOPS, sealed-secrets) | Kubernetes deployments, GitOps workflows |

### Key Separation
- Use different secrets for each environment (dev, staging, production)
- Never share API keys across environments
- Use test/sandbox keys for development and staging; production keys only in production

---

## 3. Configuration Layers

### Layer Order (lowest to highest priority)
Configuration is resolved by merging layers. Later layers override earlier ones:

```
1. Code defaults (hardcoded fallback values)
2. Config file defaults (e.g., config/default.json)
3. Environment-specific config (e.g., config/production.json)
4. Environment variables
5. Runtime overrides (CLI flags, API-driven config, feature flags)
```

### Design Principles
- **Every config value has a sensible default** where possible. Required values with no sensible default (like database URLs) should fail fast if missing.
- **Environment-specific config is minimal**. Most config should be the same across environments. Only values that genuinely differ (URLs, credentials, log levels) belong in environment-specific layers.
- **Runtime overrides are for operational control**, not application logic. Use them for feature flags, debug toggles, and incident response (e.g., disabling a misbehaving feature).

### Example Structure
```
config/
  default.ts        # Base defaults for all environments
  production.ts     # Production overrides (minimal)
  staging.ts        # Staging overrides (minimal)
  development.ts    # Development overrides (minimal)
  index.ts          # Merges layers, exports typed config object
```

### Merge Strategy
- Deep merge objects (nested config sections merge rather than replace)
- Arrays replace rather than concatenate (to avoid surprising accumulation)
- Explicit `null` or `undefined` in a higher layer removes a value set by a lower layer
- Log the final resolved config at startup (with secrets redacted) for debuggability

---

## 4. Validation

### Fail-Fast on Startup
Never let an application start with invalid or missing configuration. Validate all configuration at process startup and fail immediately with a clear error message listing every problem.

Bad:
```
# App starts, runs for hours, then crashes when it first tries to
# connect to the database and discovers DB_HOST is not set.
```

Good:
```
# App reads all config, validates it, and exits within 1 second:
# ERROR: Missing required environment variables:
#   - MYAPP_DB_HOST (database hostname)
#   - MYAPP_AUTH_SECRET (JWT signing secret, min 32 characters)
# See .env.example for documentation.
```

### T3 Env Pattern
Define a schema for your environment variables using a validation library (Zod, Joi, Yup, or similar). The schema is the single source of truth for what config exists, its types, and its constraints.

```typescript
// env.ts -- single source of truth for all env vars
import { z } from "zod";

const envSchema = z.object({
  NODE_ENV: z.enum(["development", "staging", "production"]).default("development"),
  PORT: z.coerce.number().int().positive().default(3000),
  DATABASE_URL: z.string().url(),
  AUTH_SECRET: z.string().min(32),
  REDIS_URL: z.string().url().optional(),
  FEATURE_NEW_DASHBOARD: z.coerce.boolean().default(false),
});

export const env = envSchema.parse(process.env);
```

### Benefits of Schema-Based Validation
- **Type safety**: Accessing `env.PORT` returns a number, not a string
- **Documentation**: The schema documents every variable, its type, and whether it is required
- **Fail-fast**: Parsing fails at startup with all missing/invalid variables listed
- **Autocompletion**: IDE autocomplete works on the exported `env` object
- **No silent defaults**: Every default is explicit in the schema

### Validation Checklist
For each environment variable, verify:
1. Is it required or optional? (schema enforces this)
2. What is its type? (string, number, boolean, URL, enum)
3. Are there constraints? (min length for secrets, valid URL format, positive integer)
4. Is there a sensible default? (if so, define it in the schema)
5. Is it a secret? (if so, ensure it is not logged during config dump)

---

## 5. Environment Parity

### The Goal
Dev, staging, and production should be as similar as possible. Differences between environments are the source of "works on my machine" bugs and deployment surprises.

### What Should Be the Same
| Aspect | Parity Strategy |
|--------|----------------|
| Runtime version | Pin the exact version (Node 20.x, Python 3.12, etc.) across all environments |
| Dependencies | Lock file (package-lock.json, poetry.lock) used everywhere, no floating versions |
| Database engine | Same engine and major version everywhere (not SQLite in dev, Postgres in prod) |
| Config structure | Same config schema, same env var names, different values |
| Feature flags | Same flag evaluation logic, different flag values per environment |
| Infrastructure | Containerize to reduce OS-level drift |

### What Legitimately Differs
| Aspect | Dev | Staging | Production |
|--------|-----|---------|------------|
| Database URL | localhost | staging-db.internal | prod-db.internal |
| Log level | debug | info | warn |
| Secret values | test keys | staging keys | production keys |
| TLS | optional/self-signed | required | required |
| Replicas | 1 | 1-2 | N (autoscaled) |
| Error detail | verbose | verbose | redacted |

### Minimizing Drift
- Use the same Dockerfile/container image across environments, parameterized only by env vars
- Run the same database migrations in every environment
- Use infrastructure-as-code so staging mirrors production topology
- Run integration tests against staging before promoting to production
- Periodically audit the delta between staging and production configs

---

## 6. .env File Management

### File Hierarchy
| File | Purpose | In Git? |
|------|---------|---------|
| `.env.example` | Documented template with all variables, placeholder values, and comments | Yes |
| `.env` | Default local environment values | No |
| `.env.local` | Personal local overrides (individual developer settings) | No |
| `.env.development` | Development-specific values (if using framework convention) | Depends on framework |
| `.env.production` | Production values (only if non-secret, otherwise use secret manager) | Rarely |

### .env.example as Documentation
The `.env.example` file is the canonical reference for what environment variables exist. It must be kept in sync with the config schema.

```bash
# .env.example -- copy to .env and fill in values

# Database
MYAPP_DB_HOST=localhost
MYAPP_DB_PORT=5432
MYAPP_DB_NAME=myapp_dev
MYAPP_DB_USER=postgres
MYAPP_DB_PASSWORD=           # Required. Local dev password.

# Authentication
MYAPP_AUTH_SECRET=            # Required. Min 32 chars. Generate with: openssl rand -hex 32
MYAPP_AUTH_ISSUER=http://localhost:3000

# Redis (optional)
# MYAPP_REDIS_URL=redis://localhost:6379

# Feature Flags
MYAPP_FEATURE_NEW_DASHBOARD=false
```

### Rules
- `.env` and `.env.local` must be in `.gitignore` -- always
- `.env.example` must be committed and kept up to date
- When adding a new env var, update `.env.example` in the same commit
- Never put real secrets in `.env.example` -- use empty values or placeholders
- Comments in `.env.example` should explain what each variable does and how to get its value
- Framework-specific `.env.*` files follow the framework's conventions (Next.js, Vite, etc.)

### Onboarding
A new developer should be able to:
1. Copy `.env.example` to `.env`
2. Fill in the few values marked as required
3. Start the application

If this process requires more than 5 minutes of configuration, the setup is too complex.

---

## 7. Feature Flags

### When to Use Feature Flags
| Use Case | Example |
|----------|---------|
| Gradual rollout | Enable new checkout flow for 10% of users, then 50%, then 100% |
| Trunk-based development | Merge incomplete features behind a flag so they do not block other work |
| Kill switch | Disable a feature immediately if it causes problems in production |
| A/B testing | Show different UI variants to different user segments |
| Operational toggle | Disable a non-critical feature under high load |

### When NOT to Use Feature Flags
- Permanent application configuration (use config layers instead)
- Anything that should differ per environment but not per user (use env-specific config)
- As a substitute for proper access control or authorization

### Simple Implementation
For most projects, start with environment-variable-based flags before adopting a feature flag service:

```typescript
// Simple flag from env var
const flags = {
  newDashboard: env.FEATURE_NEW_DASHBOARD,
  betaSearch: env.FEATURE_BETA_SEARCH,
} as const;

// Usage
if (flags.newDashboard) {
  renderNewDashboard();
} else {
  renderLegacyDashboard();
}
```

For more sophisticated needs (user targeting, percentage rollouts, analytics), use a feature flag service (LaunchDarkly, Unleash, Flagsmith, PostHog).

### Flag Lifecycle
1. **Create**: Define the flag in the config schema with a default of `false` (or the safe/old behavior)
2. **Develop**: Build the feature behind the flag, keeping both code paths working
3. **Test**: Test both the flag-on and flag-off paths
4. **Roll out**: Enable in staging, then gradually in production
5. **Stabilize**: Once at 100% and stable, schedule cleanup
6. **Clean up**: Remove the flag, the old code path, and the env var. This is the most important step.

### Cleanup Discipline
Feature flags that are never cleaned up become technical debt. For every flag:
- Set a cleanup date when creating it (e.g., 30 days after 100% rollout)
- Log a known issue or task for removal
- When cleaning up: remove the flag, remove the conditional logic, remove the old code path, update `.env.example`

---

## 8. Configuration Anti-Patterns

### Hardcoded Values
Bad:
```typescript
const API_URL = "https://api.example.com/v2";
const TIMEOUT = 5000;
const MAX_RETRIES = 3;
```

Good:
```typescript
const API_URL = env.EXTERNAL_API_URL;
const TIMEOUT = env.EXTERNAL_API_TIMEOUT;  // default: 5000 in schema
const MAX_RETRIES = env.EXTERNAL_API_MAX_RETRIES;  // default: 3 in schema
```

The key distinction: values that might differ between environments or need to change without a code deploy belong in configuration. True constants (mathematical constants, protocol-required values, array indices) can stay in code.

### Magic Strings
Bad:
```typescript
if (process.env.NODE_ENV === "production") {
  enableCaching();
}
if (config.tier === "enterprise") {
  showAdvancedFeatures();
}
```

Good:
```typescript
// Centralize environment checks
const isProduction = env.NODE_ENV === "production";

// Use feature flags instead of tier checks
if (flags.advancedFeatures) {
  showAdvancedFeatures();
}
```

### Scattered Environment Checks
Bad:
```typescript
// In file A:
if (process.env.NODE_ENV !== "production") { seedDatabase(); }

// In file B:
const logLevel = process.env.NODE_ENV === "production" ? "warn" : "debug";

// In file C:
if (process.env.NODE_ENV === "development") { enableDevTools(); }
```

Good:
```typescript
// config/index.ts -- all environment-dependent logic in one place
export const config = {
  shouldSeedDatabase: env.NODE_ENV === "development",
  logLevel: env.LOG_LEVEL,  // explicitly configured, not derived from NODE_ENV
  enableDevTools: env.NODE_ENV === "development",
};
```

Centralizing environment-dependent logic means there is one place to check when debugging environment-specific behavior, and one place to update when adding a new environment.

### Other Anti-Patterns
| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Reading `process.env` directly throughout the codebase | No validation, no type safety, typos cause silent undefined | Use a validated config module (Section 4) |
| Different variable names for the same thing in different environments | Confusion, misconfig | Standardize names, differ only in values |
| Secrets in config files committed to git | Credential exposure | Use env vars or secret manager, never commit secrets |
| No defaults for optional config | Unnecessary setup burden on developers | Provide sensible defaults in the schema |
| Config changes without testing | Broken environments | Include config in the change plan and validation plan |
| Env vars that only exist in production | Cannot reproduce production behavior locally | Document all vars in `.env.example`, use equivalent test values |

---

## 9. Integration with Melted Peak

### Change Plans for Config Changes
When writing an `active/change_plan.md` that involves configuration changes:
- List every environment variable being added, modified, or removed
- Specify whether it is a secret (requires secure handling) or non-secret
- Note which environments are affected
- Include the `.env.example` update in the file change list
- Describe the rollback approach (what to set variables back to if the change causes problems)

### Regression Checklist for Env-Sensitive Areas
Add entries to `active/regression_checklist.md` for:
- Any code path that reads configuration values
- Areas where behavior differs between environments
- Feature flag boundaries (both the flag-on and flag-off paths)
- Secret-dependent integrations (API clients, auth flows, payment processing)
- Config validation logic (ensure new required vars do not break existing deployments)

Tag entries with `[config]` or `[env-sensitive]` for easy filtering.

### Known Issues
When a configuration problem recurs or is discovered:
1. Log it in `memory/known_issues.md` with the variable name, symptom, and affected environment
2. Link to the relevant pattern from this skill
3. Note whether it was a missing variable, wrong value, wrong type, or missing in a specific environment

### Session Handoff
When handing off a session that involved configuration work:
- Note any new environment variables introduced
- Note any variables removed or renamed
- Flag any config changes that have not yet been applied to all environments
- Note any feature flags created and their current rollout state

---

## Anti-Patterns Summary

- Secrets in source code or committed config files
- No validation of environment variables at startup
- Reading `process.env` directly throughout the codebase instead of through a validated module
- Hardcoded values that should be configurable
- Magic strings for environment checks scattered across files
- Different database engines in development vs. production
- No `.env.example` or an outdated one
- Feature flags that are never cleaned up
- Config changes deployed without a change plan or validation
- Environment variables that only exist in production and cannot be reproduced locally
