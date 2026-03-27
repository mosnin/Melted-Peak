# Skill: Dependency Audit

## Purpose
Comprehensive dependency audit workflow that systematically evaluates a project's dependency health across inventory, vulnerability scanning, freshness, license compliance, bundle impact, unused detection, upgrade path planning, and automation strategy. Produces a prioritized action plan with Melted Peak integration.

## Trigger
- When the user requests a dependency audit or dependency review
- Before a major release or deployment
- When onboarding to a new or inherited codebase
- During quarterly or periodic maintenance cycles
- When a vulnerability is reported in a dependency
- When bundle size has grown unexpectedly or dependency count feels excessive

## Workflow

### Step 1: Scope the Audit

Before scanning, establish boundaries:
1. Ask the user (or infer from context) which dimensions to audit: full audit or targeted (e.g., vulnerabilities only, licenses only)
2. Identify the tech stack -- language, framework, package manager(s), monorepo vs single package
3. Read `active/active_context.md` for recent dependency-related changes
4. Determine audit depth:

| Depth | When to Use | Coverage |
|-------|------------|----------|
| **Quick scan** | Fast health check, CI integration | Inventory + vulnerabilities + unused detection |
| **Standard** | Regular periodic audit | All eight dimensions, surface-level |
| **Deep** | Pre-release, new codebase, compliance review | All dimensions with full tracing and alternative research |

### Step 2: Dependency Inventory

Build a complete picture of what is installed:

1. **Identify all dependency sources**:
   - `package.json` / `package-lock.json` (npm/yarn/pnpm)
   - `requirements.txt` / `Pipfile` / `pyproject.toml` (Python)
   - `Cargo.toml` / `Cargo.lock` (Rust)
   - `go.mod` / `go.sum` (Go)
   - `Gemfile` / `Gemfile.lock` (Ruby)
   - `pom.xml` / `build.gradle` (Java/Kotlin)
   - Any other manifest files in the project

2. **Catalog each dependency** with:
   - Name and installed version
   - Whether it is a direct or transitive dependency
   - Whether it is a production or development dependency
   - Brief description of its purpose in the project
   - Last publish date (check the registry if available)
   - Maintainer health (active project or abandoned?)

3. **Count and summarize**:
   - Total direct dependencies (prod vs dev)
   - Total transitive dependencies
   - Dependencies with no clear purpose (candidates for removal)

### Step 3: Vulnerability Scanning

Scan for known security issues:

1. **Run the appropriate audit tools**:
   - **npm/yarn/pnpm**: `npm audit`, `yarn audit`, `pnpm audit`
   - **pip**: `pip-audit` or check against OSV database
   - **cargo**: `cargo audit`
   - **go**: `govulncheck`
   - **Ruby**: `bundle-audit`
   - **General**: Check deps against the OSV (Open Source Vulnerabilities) database

2. **For each vulnerability found, record**:
   - Package name and affected version range
   - CVE or advisory identifier
   - Severity: critical, high, medium, low
   - Whether a patched version exists
   - Whether the vulnerable code path is actually reachable in this project
   - Exploitability context (is it a dev-only dep? Is the vulnerable function called?)

3. **Classify findings**:

| Severity | Criteria | Action |
|----------|----------|--------|
| **Critical** | RCE, auth bypass, data exfiltration in prod dep, reachable code path | Immediate fix -- block release |
| **High** | Significant vuln in prod dep, patch available | Fix before next release |
| **Medium** | Vuln with limited impact or difficult exploit conditions | Fix within current sprint |
| **Low** | Dev-only dep vuln, or theoretical risk with no known exploit | Schedule for next maintenance |

4. **Check for advisories without CVEs**: Some vulnerabilities are disclosed on GitHub advisories or package-specific channels before CVEs are assigned

### Step 4: Freshness Assessment

Evaluate how current the dependency set is:

1. **For each direct dependency, determine**:
   - Current installed version
   - Latest available version
   - Number of major/minor/patch versions behind
   - Date of the installed version vs date of the latest version
   - Whether the package follows semver

2. **Flag staleness tiers**:

| Tier | Criteria | Risk |
|------|----------|------|
| **Current** | On latest or within one patch | Low |
| **Slightly behind** | One minor version behind | Low-medium |
| **Notably behind** | Two+ minor versions or one major version behind | Medium |
| **Significantly outdated** | Two+ major versions behind | High |
| **Abandoned** | No releases in 12+ months, no maintainer activity | High |

3. **Identify breaking changes between current and latest**:
   - Read changelogs for each outdated dependency
   - Note any migration guides or codemods available
   - Estimate effort to update (trivial, moderate, significant)

4. **Check for deprecated packages**: Is the package itself deprecated in favor of a successor?

### Step 5: License Compliance

Verify that all dependency licenses are compatible with the project:

1. **Extract license information** for every dependency (direct and transitive):
   - Check `package.json` license field, `LICENSE` files, or registry metadata
   - Flag any dependency with no license specified (legally risky)

2. **Classify licenses by risk**:

| Category | Examples | Risk Level |
|----------|----------|------------|
| **Permissive** | MIT, BSD-2, BSD-3, ISC, Apache-2.0 | Low -- generally safe |
| **Weak copyleft** | LGPL-2.1, LGPL-3.0, MPL-2.0 | Medium -- safe for linking, conditions on modifications |
| **Strong copyleft** | GPL-2.0, GPL-3.0, AGPL-3.0 | High -- may require releasing your source code |
| **Non-commercial** | CC-BY-NC, various custom licenses | High -- incompatible with commercial projects |
| **Unlicensed** | No license file or field | High -- no legal permission to use |
| **Custom/Unknown** | Non-standard license text | Review required |

3. **Check for license conflicts**:
   - Is the project proprietary? Then copyleft dependencies are a problem
   - Is the project open-source? Verify license compatibility with the project's own license
   - Are there dependencies with conflicting licenses in the same dependency tree?

4. **Generate a license summary**: List of all unique licenses in use, count of packages per license

### Step 6: Bundle Impact Analysis

Evaluate which dependencies contribute most to bundle/artifact size:

1. **Measure dependency sizes**:
   - For JavaScript projects: use `bundlephobia` data or `source-map-explorer` / `webpack-bundle-analyzer` output
   - For other ecosystems: check package sizes on the registry, compiled artifact sizes
   - Note: distinguish between install size and bundle/runtime size

2. **Identify the heaviest dependencies**:
   - Rank by contribution to final bundle
   - Note whether the entire package is used or just a small part
   - Check for tree-shaking compatibility (does the package support ESM?)

3. **Research lighter alternatives**:
   - For each heavy dependency, search for alternatives that provide the needed functionality at lower cost
   - Consider native/built-in alternatives (e.g., `fetch` instead of `axios`, `crypto` instead of `uuid`)
   - Estimate the effort to switch

4. **Check for duplicate functionality**:
   - Multiple packages doing the same thing (e.g., both `lodash` and `underscore`)
   - Utility libraries where only one function is used (could replace with a local implementation)

### Step 7: Unused Dependency Detection

Find dependencies that are installed but never used:

1. **Scan the codebase for imports/requires**:
   - Search for `import ... from 'package-name'` and `require('package-name')` patterns
   - For each declared dependency, verify it appears in at least one import
   - Check both source code and configuration files (some deps are used in config only, e.g., babel plugins, eslint plugins)

2. **Check for indirect usage patterns**:
   - CLI tools listed in `scripts` (e.g., `typescript` used via `tsc` in scripts)
   - Babel/PostCSS/ESLint plugins referenced in config files
   - Type definition packages (`@types/*`) used only by the compiler
   - Peer dependencies required by other packages

3. **Classify unused dependencies**:
   - **Definitely unused**: no import, no config reference, no script usage
   - **Possibly unused**: only referenced in dead/commented code
   - **Indirectly used**: no import but used via config, scripts, or as a peer dep

4. **Recommend removal** for definitely unused dependencies and flag possibly unused ones for manual review

### Step 8: Upgrade Path Planning

Create a prioritized plan for bringing dependencies up to date:

1. **Prioritize upgrades by**:
   - Security vulnerabilities (critical/high first)
   - Abandoned packages needing replacement
   - License compliance issues
   - Packages blocking other upgrades (dependency chain bottlenecks)
   - Freshness (most outdated first, weighted by usage)

2. **Map dependency chains**:
   - Identify which packages depend on which -- updating package A may require updating package B first
   - Find the critical path: the sequence of updates that unblocks the most other updates
   - Note any circular or conflicting version requirements

3. **Estimate effort per upgrade**:

| Effort | Criteria |
|--------|----------|
| **Trivial** | Patch version, no breaking changes, drop-in replacement |
| **Moderate** | Minor version, some API changes, limited code updates needed |
| **Significant** | Major version, migration guide available, multiple files affected |
| **Major project** | Major version, no migration guide, core dependency, extensive refactoring |

4. **Group related upgrades**: Some packages should be updated together (e.g., `@babel/*` packages, a framework and its plugins)

5. **Write the upgrade sequence** as an ordered list, with each entry noting:
   - Package and version change
   - Estimated effort
   - Dependencies that must be updated first
   - Whether it can be automated or needs manual review

### Step 9: Automation Assessment

Evaluate and recommend automation for ongoing dependency maintenance:

1. **Assess current automation**:
   - Is Dependabot, Renovate, or a similar tool configured?
   - Are automated PRs being merged or accumulating?
   - Are there CI checks that run on dependency update PRs?

2. **Recommend automation strategy**:

| Update Type | Automation Level | Rationale |
|-------------|-----------------|-----------|
| **Patch versions** | Auto-merge if tests pass | Low risk, high volume |
| **Minor versions** | Auto-PR, manual merge after review | Moderate risk, need changelog check |
| **Major versions** | Manual review required | High risk, breaking changes likely |
| **Security patches** | Auto-merge with priority CI | Urgency outweighs review cost |
| **Dev dependencies** | Auto-merge if tests pass | No production impact |

3. **Configuration recommendations**:
   - Grouping rules (update related packages together)
   - Schedule (daily, weekly, monthly)
   - Auto-merge criteria (test suite must pass, no major version bumps)
   - Ignore rules (packages to skip, version ranges to pin)
   - Review assignment (who reviews dependency PRs)

4. **Identify what cannot be automated**:
   - Major version upgrades with breaking changes
   - Package replacements (switching to an alternative)
   - License changes in new versions
   - Dependencies that require manual testing beyond the test suite

### Step 10: Report and Integrate with Melted Peak

1. **Present the audit report** organized by dimension:
   - Executive summary: overall dependency health rating (healthy, needs attention, at risk)
   - Key metrics: total deps, vulnerable count, outdated count, unused count
   - Critical findings (vulnerabilities, license issues) listed first
   - Full findings by dimension with severity and recommended action

2. **Update Melted Peak files**:
   - **`memory/dependency_map.md`**: Update with current inventory, noting versions, purpose, and any quirks discovered
   - **`memory/known_issues.md`**: Add entries for each critical or high vulnerability with tag `[dependency]`, each license compliance issue with tag `[license]`
   - **`active/regression_checklist.md`**: Add dependency-sensitive areas (features that rely heavily on specific packages)
   - **`active/active_context.md`**: Update with audit summary and outstanding action items

3. **Generate an upgrade change plan** (if requested or if critical issues found):
   - Write upgrade sequence to `active/change_plan.md` following the upgrade path from Step 8
   - Include rollback approach for each upgrade (revert lock file to pre-update state)
   - Reference the dependency-update skill for executing individual updates

## Anti-Patterns

- Running `npm audit` alone and calling it a dependency audit -- vulnerability scanning is one of eight dimensions
- Updating everything to latest in one batch -- use the upgrade path to sequence changes safely
- Ignoring dev dependencies in the audit -- they affect build security, bundle size, and developer experience
- Treating all outdated packages as equally urgent -- prioritize by vulnerability, usage, and effort
- Removing a dependency flagged as "unused" without checking indirect usage patterns (configs, scripts, peer deps)
- Ignoring license compliance because "everyone uses MIT" -- transitive deps may introduce copyleft or unlicensed code
- Automating all updates without a test suite -- auto-merge is only safe when tests catch regressions
- Auditing once and never again -- dependency health drifts; schedule periodic audits
- Replacing a heavy dependency with a lighter one without checking feature parity -- the switch may introduce bugs
- Skipping the inventory step -- you cannot assess what you have not cataloged
