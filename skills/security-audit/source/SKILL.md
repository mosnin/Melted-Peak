# Skill: Security Audit

## Purpose
Comprehensive security audit workflow that systematically evaluates a project across dependency vulnerabilities, OWASP Top 10 risks, secrets exposure, authentication/authorization design, input validation, API security, data protection, and infrastructure hardening. Produces a prioritized findings report with severity classifications.

## Trigger
- When the user requests a security audit or security review
- Before a major release or deployment
- After adding new authentication, authorization, or data-handling code
- When integrating a new third-party dependency or API
- When a vulnerability is reported or suspected

## Workflow

### Step 1: Scope the Audit

Before scanning, establish boundaries:
1. Ask the user (or infer from context) which areas to audit: full audit or targeted (e.g., auth only, API only)
2. Identify the tech stack -- language, framework, package manager, hosting environment
3. Read `active/active_context.md` for recent changes that may warrant focused attention
4. Determine audit depth:

| Depth | When to Use | Coverage |
|-------|------------|----------|
| **Targeted** | Specific concern or single subsystem | One or two sections below |
| **Standard** | Regular periodic audit | All sections, surface-level |
| **Deep** | Pre-release, post-incident, compliance | All sections with full tracing |

### Step 2: Dependency Vulnerability Scanning

1. Identify the package manager(s) in use (npm, pip, cargo, go mod, etc.)
2. Run the appropriate audit command:
   - **npm/yarn**: `npm audit` or `yarn audit`
   - **pip**: check `requirements.txt` / `Pipfile.lock` against known CVE databases
   - **cargo**: `cargo audit` (if available)
   - **go**: `govulncheck` or check go.sum against advisories
3. For each vulnerability found, record:
   - Package name and version
   - CVE identifier (if available)
   - Severity (critical, high, medium, low)
   - Whether a patched version exists
   - Whether the vulnerable code path is actually reachable in this project
4. Check for outdated dependencies that are no longer maintained
5. Flag any dependencies pulled from non-standard registries

### Step 3: OWASP Top 10 Checklist

Evaluate the codebase against each OWASP Top 10 category:

#### A01: Broken Access Control
- Are authorization checks present on every protected route/endpoint?
- Can users access resources belonging to other users (IDOR)?
- Are admin functions protected from non-admin users?
- Is CORS configured restrictively (not `*` in production)?
- Is directory listing disabled?

#### A02: Cryptographic Failures
- Is sensitive data encrypted at rest?
- Is TLS enforced for all data in transit?
- Are strong, current algorithms used (no MD5, SHA-1 for security purposes)?
- Are encryption keys managed properly (not hardcoded, rotated)?
- Is PII minimized in logs and error messages?

#### A03: Injection
- Are SQL queries parameterized (no string concatenation)?
- Is ORM usage safe from raw query injection?
- Are OS commands avoided or safely parameterized?
- Is LDAP, XPath, or NoSQL injection possible?
- Are template engines configured to auto-escape?

#### A04: Insecure Design
- Are rate limits in place for sensitive operations?
- Are business logic flows protected against abuse?
- Are trust boundaries clearly defined?
- Is there defense in depth (not relying on a single control)?

#### A05: Security Misconfiguration
- Are default credentials changed?
- Are unnecessary features, ports, services disabled?
- Are error messages generic in production (no stack traces)?
- Are security headers set (see Infrastructure section)?
- Is the framework running in production mode?

#### A06: Vulnerable and Outdated Components
- Covered by Step 2 (Dependency Vulnerability Scanning)
- Additionally: are client-side libraries (CDN scripts) pinned and integrity-checked?

#### A07: Identification and Authentication Failures
- Covered in detail by Step 4 (Authentication Review)

#### A08: Software and Data Integrity Failures
- Are CI/CD pipelines secured?
- Are dependencies verified with lock files and integrity hashes?
- Is deserialization of untrusted data avoided or safely handled?
- Are software updates verified before applying?

#### A09: Security Logging and Monitoring Failures
- Are authentication events logged (login, logout, failure)?
- Are authorization failures logged?
- Are logs protected from injection and tampering?
- Is there alerting for suspicious patterns?

#### A10: Server-Side Request Forgery (SSRF)
- Are user-supplied URLs validated and restricted?
- Are internal network requests blocked from user-controlled input?
- Is URL schema restricted (no `file://`, `gopher://`)?

### Step 4: Secrets Detection

Scan the entire codebase for exposed secrets:

1. **Hardcoded credentials**: Search for patterns like:
   - `password`, `passwd`, `secret`, `token`, `api_key`, `apikey`, `api-key`
   - `AWS_ACCESS_KEY`, `AWS_SECRET`, `PRIVATE_KEY`
   - Connection strings with embedded credentials
   - Base64-encoded strings that decode to credentials
2. **Environment variable handling**:
   - Are secrets loaded from environment variables or a secrets manager (good)?
   - Are `.env` files excluded from version control via `.gitignore`?
   - Are example env files (`.env.example`) free of real values?
3. **Git history**: Check if secrets were ever committed and later removed (they are still in history)
   - `git log --all -p -S "password"` or similar
4. **Configuration files**: Check `config/`, `settings/`, YAML, JSON, TOML files for embedded secrets
5. **Client-side exposure**: Are any secrets bundled into client-side JavaScript?

### Step 5: Authentication Review

Evaluate the authentication system:

1. **Password policies**:
   - Minimum length (recommend 12+)
   - Complexity requirements or passphrase support
   - Breach database checking (e.g., HaveIBeenPwned integration)
   - Bcrypt, scrypt, or argon2 for hashing (not MD5, SHA-256 alone)
2. **Session management**:
   - Session IDs are random and sufficiently long
   - Sessions expire after inactivity and have absolute timeouts
   - Sessions are invalidated on logout
   - Session fixation is prevented (new ID on login)
3. **Token handling** (JWT, OAuth, API keys):
   - JWTs are validated properly (signature, expiry, issuer, audience)
   - Tokens have appropriate expiry times
   - Refresh token rotation is implemented
   - Token storage is secure (httpOnly cookies preferred over localStorage)
4. **Multi-factor authentication**: Is MFA available for sensitive accounts?
5. **Account recovery**: Is the reset flow secure (time-limited tokens, no secret questions)?
6. **Brute force protection**: Are login attempts rate-limited or locked after failures?

### Step 6: Authorization Review

Evaluate the authorization system:

1. **Role-based access control (RBAC)**:
   - Are roles clearly defined and documented?
   - Is the default permission deny-all?
   - Are role checks enforced server-side (not just UI hiding)?
2. **Privilege escalation**:
   - Can a user modify their own role or permissions?
   - Are admin endpoints protected by role checks, not just authentication?
   - Are elevation actions (e.g., becoming admin) logged and audited?
3. **Data isolation**:
   - Are database queries scoped to the current user/tenant?
   - Can user A access user B's data by manipulating IDs?
   - Are file uploads isolated per user/tenant?
4. **API authorization**:
   - Does every API endpoint enforce authorization?
   - Are batch/bulk endpoints checking per-item permissions?
   - Are GraphQL queries protected against over-fetching unauthorized data?

### Step 7: Input Validation

Evaluate how the application handles untrusted input:

1. **Server-side validation**:
   - Is all input validated on the server (not just client-side)?
   - Are data types, lengths, ranges, and formats checked?
   - Are allowlists preferred over denylists?
2. **Parameterized queries**:
   - Are all database queries parameterized?
   - Are ORMs used safely (no raw query string building)?
3. **Output encoding**:
   - Is output encoded for the correct context (HTML, JavaScript, URL, CSS)?
   - Are template engines auto-escaping by default?
   - Is user content in emails or PDFs sanitized?
4. **File uploads**:
   - Are file types validated by content (magic bytes), not just extension?
   - Are file sizes limited?
   - Are uploads stored outside the web root?
   - Are filenames sanitized?
5. **Content Security Policy**: Is CSP configured to prevent inline script execution?

### Step 8: API Security

Evaluate API design and protections:

1. **Rate limiting**:
   - Are rate limits in place per-user and per-endpoint?
   - Are expensive operations (search, export, report generation) rate-limited more aggressively?
   - Are rate limit headers returned to clients?
2. **CORS configuration**:
   - Is the `Access-Control-Allow-Origin` restrictive (not `*` in production)?
   - Are allowed methods and headers minimal?
   - Is `Access-Control-Allow-Credentials` only set when needed?
3. **Security headers**:
   - `Strict-Transport-Security` (HSTS)
   - `Content-Security-Policy`
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options` or CSP `frame-ancestors`
   - `Referrer-Policy`
   - `Permissions-Policy`
4. **Request validation**:
   - Is request body size limited?
   - Is content type validated?
   - Are unexpected fields rejected or ignored?
5. **Error responses**:
   - Do error responses avoid leaking internal details?
   - Are error formats consistent?
   - Do 404s and 403s not reveal resource existence to unauthorized users?

### Step 9: Data Protection

Evaluate data handling practices:

1. **Encryption at rest**:
   - Is the database encrypted?
   - Are backups encrypted?
   - Are sensitive fields (SSN, credit card) encrypted at the application level?
2. **Encryption in transit**:
   - Is TLS 1.2+ enforced?
   - Are internal service-to-service calls encrypted?
   - Are certificates valid and not self-signed in production?
3. **PII handling**:
   - Is PII inventoried (what data, where stored, who accesses)?
   - Is PII minimized (only collect what is needed)?
   - Is PII masked in logs?
   - Can PII be exported and deleted (GDPR/CCPA compliance)?
4. **Data retention**:
   - Are retention policies defined and enforced?
   - Are old records purged or anonymized?
   - Are audit logs retained appropriately?

### Step 10: Infrastructure Security

Evaluate deployment and infrastructure:

1. **HTTPS**:
   - Is HTTPS enforced (HTTP redirects to HTTPS)?
   - Is HSTS enabled with appropriate max-age?
   - Are HSTS preload and includeSubDomains set?
2. **Cookie flags**:
   - `Secure` flag set (cookies only sent over HTTPS)?
   - `HttpOnly` flag set (cookies not accessible via JavaScript)?
   - `SameSite` attribute set (Lax or Strict)?
   - Cookie path and domain scoped appropriately?
3. **Security headers**: (see API Security section for full list)
4. **Server hardening**:
   - Are default/sample pages removed?
   - Is server version information hidden?
   - Are debug endpoints disabled in production?
   - Are unnecessary ports closed?

### Step 11: Classify and Prioritize Findings

For each finding, assign:

| Severity | Criteria | Response Time |
|----------|----------|---------------|
| **Critical** | Active exploitation possible, data breach risk, authentication bypass | Immediate -- block release |
| **High** | Significant vulnerability but requires specific conditions to exploit | Fix before next release |
| **Medium** | Real risk but limited impact or difficult to exploit | Fix within current sprint |
| **Low** | Minor issue, defense-in-depth improvement, best practice gap | Schedule for future work |
| **Informational** | Observation, no immediate risk, may become relevant later | Log and review periodically |

### Step 12: Report and Integrate with Melted Peak

1. **Present findings** organized by severity (critical first), with:
   - Category (which audit step found it)
   - File and line reference
   - Description of the vulnerability
   - Proof of concept or reproduction steps (where applicable)
   - Recommended fix
   - Severity justification

2. **Update Melted Peak files**:
   - For each critical or high finding: add to `memory/known_issues.md` with tag `[security]`
   - For each finding involving a specific code area: add the area to `active/regression_checklist.md` as a security-sensitive region
   - Update `active/active_context.md` with audit summary and outstanding items
   - If a fix is needed immediately: create an entry in `active/active_issue.md` (following one-issue-at-a-time rule -- pick the most critical)

3. **Generate a fix plan** (if requested):
   - Prioritize fixes by severity and effort
   - Write a change plan in `active/change_plan.md` for the highest-priority fix
   - Include rollback approach for each fix

## Anti-Patterns

- Running only automated scanning without manual review -- tools miss logic flaws and business-context vulnerabilities
- Auditing without understanding the application's threat model -- not all findings are equally relevant
- Treating all findings as equal severity -- prioritize or the team will ignore the report
- Fixing secrets by deleting them from code without rotating them -- the old value is still in git history
- Checking only the happy path for auth -- test with expired tokens, revoked sessions, and manipulated roles
- Assuming the framework handles security automatically -- verify the configuration is correct
- Skipping client-side code -- XSS, secrets exposure, and logic bypass often live in the frontend
- Auditing once and never again -- security is continuous; re-audit after significant changes
