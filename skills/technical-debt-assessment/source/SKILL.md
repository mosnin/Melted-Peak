# Skill: Technical Debt Assessment

## Purpose
Systematic identification, classification, prioritization, and management of technical debt across a codebase. Provides frameworks for deciding when to accept debt, when to pay it down, and how to prevent it from accumulating.

## Trigger
- When the user requests a debt audit or assessment
- Before planning a major feature (to understand existing constraints)
- When velocity has visibly degraded
- During retrospectives that surface recurring friction
- When onboarding to a new or unfamiliar codebase

## Workflow

### Phase 1: Debt Identification

Scan the codebase for the following categories of debt:

#### Code Smells
- Long methods or functions (>50 lines as a starting heuristic)
- Deep nesting (>3 levels)
- Duplicated logic across files
- God objects or files with too many responsibilities
- Dead code (unused functions, unreachable branches, commented-out blocks)
- Magic numbers and hardcoded values
- Inconsistent naming or style across modules

#### Architecture Violations
- Circular dependencies between modules
- Layer violations (e.g., UI calling the database directly)
- Tight coupling where loose coupling was intended
- Shared mutable state across boundaries
- Missing abstraction boundaries (everything in one package)

#### Outdated Dependencies
- Dependencies with known security vulnerabilities
- Dependencies more than two major versions behind
- Deprecated libraries with no migration plan
- Pinned versions that block other upgrades

#### Missing Tests
- Core business logic without unit tests
- Integration points without integration tests
- Known edge cases without coverage
- Error paths that are never exercised
- Features added after the last test update

#### Documentation Gaps
- Public APIs without usage documentation
- Complex algorithms without explanatory comments
- Missing architecture decision records for non-obvious choices
- Outdated README or setup instructions
- Configuration options that are undocumented

### Phase 2: Debt Classification

For each identified item, classify along three dimensions:

#### Intent
| Type | Definition | Example |
|------|-----------|---------|
| **Intentional** | Taken deliberately with awareness of tradeoffs | "We skipped tests to hit the deadline; logged in backlog" |
| **Accidental** | Introduced without awareness | "Nobody realized this created a circular dependency" |
| **Bit Rot** | Was fine when written but the world changed | "This library was current two years ago" |

#### Impact
| Level | Definition | Signals |
|-------|-----------|---------|
| **High** | Actively blocking work or causing incidents | Bugs traced here, developers avoid this area, deployment failures |
| **Medium** | Slowing work or increasing risk | Extra workarounds needed, new hires confused, fragile in testing |
| **Low** | Annoying but not harmful today | Style inconsistency, minor duplication, verbose but correct |

#### Fix Cost
| Level | Definition | Rough Scope |
|-------|-----------|-------------|
| **Trivial** | Under an hour, minimal risk | Rename, delete dead code, update a comment |
| **Small** | A few hours, low risk | Extract a function, add missing tests for one module |
| **Medium** | A day or two, moderate risk | Refactor a subsystem, migrate a dependency |
| **Large** | A week or more, significant risk | Rearchitect a layer, rewrite a core module |

### Phase 3: Cost-Benefit Analysis

For each high or medium impact item, evaluate:

#### Cost of Leaving It
- **Ongoing friction**: How much time does this cost per week/sprint?
- **Risk exposure**: What is the probability and severity of a failure caused by this debt?
- **Compound interest**: Will this debt make future work harder? Does it attract more debt?
- **Knowledge cost**: Does this require tribal knowledge that could be lost?

#### Cost of Fixing It
- **Direct effort**: Developer hours to implement the fix
- **Testing burden**: Effort to verify the fix and check for regressions
- **Disruption**: Will fixing this block other in-flight work?
- **Rollback complexity**: How hard is it to undo if the fix goes wrong?

#### Opportunity Cost
- What feature or improvement work is displaced by fixing this debt?
- Is there upcoming work that would be significantly cheaper if this debt were fixed first?
- Would fixing this unblock other high-value work?

### Phase 4: Debt Inventory

Record all identified debt in a structured format. Each entry should follow this template:

```
### DEBT-[NNN]: [Short Title]
- **Category**: Code Smell | Architecture | Dependency | Testing | Documentation
- **Intent**: Intentional | Accidental | Bit Rot
- **Impact**: High | Medium | Low
- **Fix Cost**: Trivial | Small | Medium | Large
- **Location**: [file paths or module names]
- **Description**: [What the debt is and why it matters]
- **Ongoing Cost**: [How this debt affects current work]
- **Fix Approach**: [Brief description of how to resolve it]
- **Priority Score**: [Calculated in Phase 5]
- **Status**: Open | In Progress | Resolved | Accepted
- **Logged**: [date]
- **Resolved**: [date or blank]
```

Store the inventory in a location appropriate to the project. For Melted Peak managed projects, high-impact items should also be logged in `memory/known_issues.md` with a `[tech-debt]` tag.

### Phase 5: Prioritization Framework

Use a weighted scoring matrix to rank debt items:

#### Risk Score (1-5)
How likely is this to cause a production issue or block critical work?
- 5: Active incidents or blocking current sprint
- 4: Will likely cause problems within weeks
- 3: Moderate chance of causing problems in the quarter
- 2: Unlikely to cause problems soon but increases fragility
- 1: Cosmetic or style-only concern

#### Frequency Score (1-5)
How often do developers encounter or work around this debt?
- 5: Multiple times per day
- 4: Daily
- 3: Weekly
- 2: Monthly
- 1: Rarely

#### Fix Cost Score (inverse, 1-5)
Lower cost gets a higher score (easier wins rank higher):
- 5: Trivial (under an hour)
- 4: Small (a few hours)
- 3: Medium (a day or two)
- 2: Large (a week)
- 1: Very large (multiple weeks)

#### Priority Score
**Priority = Risk x Frequency x Fix Cost Score**

| Score Range | Priority Tier | Action |
|-------------|--------------|--------|
| 75-125 | Critical | Fix immediately, before new features |
| 40-74 | High | Schedule in the next sprint |
| 15-39 | Medium | Add to backlog, fix when in the area |
| 1-14 | Low | Track but do not schedule proactively |

### Phase 6: Paydown Strategies

Select the strategy that fits the team's current situation:

#### Boy Scout Rule
"Leave the code better than you found it." Fix small debt items whenever you touch a file for other reasons. Best for: trivial and small fix-cost items. No dedicated time required.

#### Dedicated Debt Sprints
Allocate an entire sprint (or a fixed percentage of each sprint) to debt paydown. Best for: medium and large items that need focused attention. Typical allocation: 15-20% of sprint capacity.

#### Alongside Features
Bundle debt fixes with feature work that touches the same area. Best for: medium items where the debt is in the path of planned work. Requires change plans that explicitly include the debt fix.

#### Strangler Pattern
For large architectural debt, build the replacement alongside the existing system and migrate incrementally. Best for: large items where a big-bang rewrite is too risky.

#### Debt Firebreak
When compound interest is accelerating, stop all feature work and fix the top N items. Best for: critical situations where velocity has collapsed. Use sparingly -- requires stakeholder alignment.

### Phase 7: Velocity vs. Debt Tradeoff

#### When to Accept New Debt
- Time-boxed prototypes or experiments (with explicit cleanup deadline)
- Genuine external deadlines where the debt is intentional, logged, and bounded
- The debt is isolated and will not compound

#### When to Refuse New Debt
- The area already has high existing debt (compounding risk)
- The debt would affect shared infrastructure or core paths
- There is no plan or timeline for paying it down
- The team cannot articulate what they are trading off

#### When to Pay Down Existing Debt
- Velocity has measurably declined in the affected area
- The debt is blocking or complicating planned work
- The debt is in a high-risk area (security, data integrity, payments)
- A quick win exists (high priority score, low fix cost)
- New team members are being slowed by the debt

### Phase 8: Prevention Patterns

#### Code Review Gates
- Reviewers explicitly check for new debt introduction
- Changes that add debt must include a `DEBT-[NNN]` reference showing the debt is logged
- Complexity increases require justification

#### Complexity Budgets
- Set thresholds for cyclomatic complexity, file length, and dependency count
- Enforce via linting or CI checks
- Require a waiver (logged as intentional debt) to exceed the budget

#### Dependency Freshness
- Automated alerts when dependencies fall behind
- Quarterly dependency review as a recurring task
- Upgrade path documented before adopting new dependencies

#### Test Coverage Floors
- Set a minimum coverage threshold for new code
- Do not allow coverage to decrease without a logged debt item
- Focus coverage on high-risk paths, not vanity percentages

#### Architecture Decision Records
- Document every non-obvious architectural choice
- Include "consequences" section that names expected debt
- Review ADRs when the surrounding code changes

### Phase 9: Metrics

Track these metrics over time to measure debt health:

#### Debt Ratio
Number of open debt items / total modules (or files, or endpoints). Trend matters more than absolute value.

#### Age Distribution
Histogram of debt items by age. A healthy codebase has few old items. A growing tail of old items signals systemic neglect.

#### Paydown Rate
Debt items resolved per sprint (or per month). Should roughly match or exceed the rate of new debt creation.

#### Debt by Category
Breakdown of open items by category (code smell, architecture, dependency, testing, documentation). Reveals systemic weaknesses.

#### Velocity Impact
Compare velocity in high-debt areas vs. low-debt areas. Quantifies the real cost of debt to stakeholders.

## Melted Peak Integration

### Known Issues
High and medium impact debt items should be logged to `memory/known_issues.md` with the `[tech-debt]` tag. Include the DEBT ID for cross-reference with the full inventory.

### Pattern Journal
Recurring debt patterns (e.g., "every new endpoint skips input validation", "test coverage always drops after rushed sprints") should be logged in `memory/metrics/pattern_journal.md`. At three occurrences, propose a prevention pattern or a new skill.

### Retrospective
When a debt item causes an incident or significantly impacts a sprint, run the retrospective skill. Feed lessons back into the prevention patterns and update the prioritization scores.

### Regression Checklist
Areas where debt has been paid down should be added to `active/regression_checklist.md` -- recently refactored code is a common source of regressions.

### Change Plans
Debt paydown work follows the same change plan discipline as feature work. Write the plan in `active/change_plan.md` before starting fixes.

## Anti-Patterns

- Tracking debt without ever paying it down -- an inventory that only grows is useless
- Paying down debt without measuring impact -- you cannot justify the investment without data
- Treating all debt as equal -- a cosmetic issue is not the same as a ticking time bomb
- Big-bang rewrites to "fix all the debt" -- incremental paydown is almost always safer
- Blaming developers for debt -- debt is a system problem, not a people problem
- Ignoring debt until a crisis forces action -- proactive management is cheaper than firefighting
- Logging debt in a place nobody checks -- the inventory must be visible and reviewed regularly
