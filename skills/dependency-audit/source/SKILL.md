# Skill: Dependency Audit

## Purpose
Comprehensive audit of project dependencies: vulnerabilities, freshness, license compliance, bundle impact, and unused packages. Produces an upgrade roadmap.

## Trigger
- Periodic maintenance review
- Security vulnerability alert
- Pre-launch security audit
- Bundle size investigation
- New project onboarding (assess dependency health)

## Workflow

### Step 1: Inventory

Build a complete dependency list:

```
For each dependency:
  - Name and current version
  - Latest available version
  - What it does (one line)
  - Direct vs transitive
  - Dev-only vs production
  - Last updated date
```

### Step 2: Vulnerability Scan

Run `npm audit` (or equivalent) and classify findings:

| Severity | Action | Timeline |
|----------|--------|----------|
| **Critical** | Update immediately, may need hotfix | Same day |
| **High** | Update soon, plan into current sprint | This week |
| **Moderate** | Schedule update, assess impact | This month |
| **Low** | Track, update opportunistically | When convenient |

For each vulnerability:
- What's the attack vector?
- Is it exploitable in our usage?
- Is there a patched version?
- Does the patched version have breaking changes?

### Step 3: Freshness Assessment

| Behind By | Risk Level | Action |
|-----------|-----------|--------|
| Patch (0.0.x) | Low | Update freely |
| Minor (0.x.0) | Medium | Read changelog, update |
| Major (x.0.0) | High | Plan migration, read upgrade guide |
| 2+ majors | Critical | Dedicated migration effort |
| Unmaintained (no release in 12+ months) | High | Evaluate alternatives |

### Step 4: License Compliance

| License | Commercial Use | Copyleft? | Action |
|---------|---------------|-----------|--------|
| MIT | Yes | No | Safe |
| Apache-2.0 | Yes | No | Safe |
| BSD-2/3 | Yes | No | Safe |
| ISC | Yes | No | Safe |
| GPL-2.0/3.0 | Restricted | Yes | Review with legal |
| AGPL-3.0 | Very restricted | Yes | Likely remove |
| LGPL | Yes (with conditions) | Partial | Review usage |
| Unlicensed | Unknown | Unknown | Investigate or remove |

### Step 5: Bundle Impact

For frontend dependencies:
- What is each dep's contribution to bundle size?
- Are there lighter alternatives? (e.g., date-fns vs moment, preact vs react)
- Are unused exports being tree-shaken?
- Are dev dependencies accidentally in the production bundle?

### Step 6: Unused Detection

Look for dependencies that are:
- Installed but never imported
- Imported but the imported function is never called
- Only used in deleted/commented-out code
- Dev tools installed as production deps

### Step 7: Create Upgrade Roadmap

Prioritize updates:

```
Priority 1: Critical/high vulnerabilities
Priority 2: Dependencies 2+ majors behind
Priority 3: Unmaintained dependencies (find alternatives)
Priority 4: License issues
Priority 5: Bundle size optimizations
Priority 6: Minor version freshness updates
```

For each upgrade, note:
- Breaking changes expected?
- Migration guide available?
- What code changes are needed?
- Use the dependency-update skill for execution

## Integration with Melted Peak

- **memory/dependency_map.md**: Update with current dependency inventory and quirks
- **memory/known_issues.md**: Log vulnerabilities and unmaintained deps
- **active/change_plan.md**: Use for each upgrade batch
- **skills/dependency-update**: Execute individual upgrades using that skill
- **skills/security-audit**: Cross-reference with security audit findings
