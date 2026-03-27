# Skill: Deployment Workflow

## Purpose
Structured deployment workflow covering pre-deployment validation, execution strategies, post-deployment verification, and rollback procedures. Integrates with Melted Peak's change plan and regression checklist to ensure deployments are planned, verified, and recoverable.

## Trigger
- When a change plan is ready to be deployed
- When user asks about deployment strategy or process
- Before any production or staging deployment
- When a rollback is needed
- When verifying environment parity between staging and production

## Workflow

### Phase 1: Pre-Deployment Validation

#### Configuration Checks
1. Verify all environment variables are set for the target environment
2. Confirm secrets and credentials are available (not hardcoded, sourced from vault/secrets manager)
3. Validate configuration files parse correctly (JSON/YAML syntax, required fields present)
4. Compare config against the environment's expected schema -- flag any missing or unexpected keys

#### Migration Safety
1. Review pending database migrations -- are they backward-compatible?
2. Confirm migrations can run without downtime (no locking large tables, no destructive column drops while old code runs)
3. Verify rollback migrations exist for every forward migration
4. Test migrations against a copy of production data if possible
5. Check migration ordering -- no dependency conflicts between migration files

#### Environment Verification
1. Confirm target environment is reachable (network, DNS, firewall rules)
2. Verify deployment credentials and permissions are valid
3. Check resource capacity (disk, memory, CPU headroom for the deploy)
4. Confirm dependent services are healthy (databases, caches, queues, third-party APIs)
5. Validate that the artifact to be deployed matches what was tested (checksum, git SHA, image digest)

#### Change Plan Alignment
1. Read `active/change_plan.md` -- does the deployment match the planned changes?
2. Confirm every file change in the plan has been committed and is present in the artifact
3. Review `active/regression_checklist.md` -- all sensitive areas verified pre-deploy?

### Phase 2: Deployment Execution

#### CI/CD Pipeline Patterns
- **Build**: Artifact is built from a specific commit SHA (never from "latest" or a mutable tag)
- **Test**: Full test suite passes in CI before any deployment proceeds
- **Stage**: Deploy to staging first, always. No direct-to-production deploys for non-trivial changes
- **Approve**: Require explicit approval gate between staging validation and production deploy
- **Deploy**: Automated deployment to production using the same artifact that passed staging

#### Deployment Strategies

##### Blue-Green Deployment
```
When to use: Zero-downtime requirement, quick rollback needed
How:
1. Deploy new version to idle environment (green)
2. Run smoke tests against green
3. Switch traffic from blue to green (load balancer / DNS)
4. Keep blue running as immediate fallback
5. Tear down blue after confidence period (15-60 minutes)

Rollback: Switch traffic back to blue -- instant recovery
```

##### Canary Deployment
```
When to use: Gradual rollout, risk reduction for large user bases
How:
1. Deploy new version to a small subset (1-5% of traffic)
2. Monitor error rates, latency, and business metrics
3. If metrics are healthy, increase traffic incrementally (5% -> 25% -> 50% -> 100%)
4. Each increment has a stabilization period (5-15 minutes minimum)
5. If any metric degrades, halt and evaluate

Rollback: Route 100% traffic back to old version
```

##### Rolling Deployment
```
When to use: Standard deploys, stateless services
How:
1. Replace instances one at a time (or in small batches)
2. Each new instance passes health check before next batch proceeds
3. Old instances drain connections gracefully before shutdown

Rollback: Redeploy previous version using the same rolling strategy
```

#### Deployment Execution Checklist
- [ ] Artifact verified (SHA/digest matches tested build)
- [ ] Change plan reviewed and aligned
- [ ] Staging deployment succeeded
- [ ] Staging smoke tests passed
- [ ] Approval gate passed (explicit human or automated approval)
- [ ] Deployment window confirmed (avoid peak traffic, Fridays, holidays)
- [ ] On-call team notified
- [ ] Monitoring dashboards open and visible during deploy

### Phase 3: Post-Deployment Validation

#### Smoke Tests
Run immediately after deployment completes:
1. Core user flows work end-to-end (login, primary actions, data reads/writes)
2. API health endpoints return 200
3. Critical background jobs are processing
4. Static assets load correctly (no broken CSS/JS/images)
5. Authentication and authorization function correctly

#### Health Checks
Monitor for the first 15-30 minutes:
1. HTTP error rate is at or below pre-deploy baseline
2. Response latency (p50, p95, p99) is within normal range
3. CPU and memory usage are stable (no leaks or spikes)
4. Database connection pool is healthy
5. Queue depth is not growing unexpectedly
6. No new exceptions appearing in error tracking (Sentry, Datadog, etc.)

#### Business Metric Verification
Monitor for 1-4 hours post-deploy:
1. Conversion rates are stable
2. User engagement metrics are within normal range
3. No spike in support tickets or user complaints
4. Revenue-critical flows are processing correctly

#### Post-Deploy Checklist
- [ ] Smoke tests pass
- [ ] Error rate at or below baseline
- [ ] Latency within normal range
- [ ] No new error classes in error tracking
- [ ] Business metrics stable
- [ ] On-call team confirms no anomalies

### Phase 4: Rollback Procedures

#### When to Rollback
Rollback immediately if any of these occur:
- Error rate exceeds 2x the pre-deploy baseline
- A critical user flow is broken (login, checkout, data loss)
- p99 latency exceeds 3x the pre-deploy baseline
- Data corruption is detected
- Security vulnerability is discovered in the deployed code

Do NOT rollback for:
- Cosmetic issues that do not affect functionality
- Minor log noise or non-critical warnings
- Issues that existed before the deploy

#### How to Rollback

##### Application Rollback
1. Trigger redeployment of the previous known-good artifact (same SHA/digest used in prior deploy)
2. Use the same deployment strategy (blue-green switch, rolling redeploy, canary reset to 0%)
3. Do NOT attempt a "fix forward" under pressure -- rollback first, investigate second

##### Database Rollback
1. Run reverse migrations if the forward migration has already been applied
2. If reverse migration is not safe (data loss risk), do NOT roll back the database -- fix forward for the data layer only
3. Ensure application code is compatible with both the old and new schema during the transition

##### Verification After Rollback
1. Re-run the full smoke test suite against the rolled-back version
2. Confirm error rates return to pre-deploy baseline
3. Confirm latency returns to pre-deploy baseline
4. Notify the team that rollback is complete and stable
5. Log the rollback event in `memory/progress_log.md` with the reason

### Phase 5: Environment Parity

#### Staging vs Production Verification
Before trusting a staging deployment as a production signal:

1. **Infrastructure parity**: Staging should mirror production architecture (same services, same topology, scaled down but not structurally different)
2. **Data parity**: Staging has representative data (anonymized production snapshots preferred over synthetic data)
3. **Configuration parity**: Same config keys, same feature flags (staging may have test values but must have the same structure)
4. **Dependency parity**: Same versions of databases, caches, queues, and third-party SDKs
5. **Network parity**: Same firewall rules, same DNS patterns, same TLS configuration

#### Parity Drift Detection
- Maintain a checklist of parity dimensions in the project's deployment documentation
- Before each production deploy, verify no new drift has been introduced since the last deploy
- Flag and fix parity gaps before relying on staging results

## Integration with Melted Peak

### Change Plan Maps to Deployment Steps
- Each step in `active/change_plan.md` should have a corresponding deployment verification
- The change plan's "expected outcome" becomes the post-deploy smoke test assertion
- The change plan's "rollback approach" becomes the rollback procedure for this deploy

### Regression Checklist for Deployment
- Before deploying, review `active/regression_checklist.md` for all areas affected by the change
- After a successful deploy, note the deployment in `memory/progress_log.md`
- After a rollback, log the incident in `memory/known_issues.md` with root cause

### Session Integration
- Update `active/active_context.md` with deployment status after each phase
- If a deploy fails, create an `active/active_issue.md` for the failure -- do not debug inline during the deploy
- Record deployment outcomes in `memory/recent_deltas.md`

## Anti-Patterns
- Deploying directly to production without staging validation
- Deploying on Fridays, holidays, or outside the team's working hours
- Deploying without a rollback plan
- "Fix forward" under pressure instead of rolling back first
- Skipping smoke tests because "the CI passed"
- Deploying database migrations that cannot be reversed
- Deploying multiple unrelated changes in a single deployment
- Ignoring environment parity drift between staging and production
- Manual deployments when an automated pipeline exists
