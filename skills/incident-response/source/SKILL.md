# Skill: Incident Response

## Purpose
Structured approach to production incident response covering detection, triage, investigation, mitigation, communication, and post-incident review. Designed to maintain discipline under pressure and integrate incident learnings back into Melted Peak's memory system.

## Trigger
- A production incident is reported or detected
- Alerts fire indicating degraded service
- User reports unexpected production behavior at scale
- A rollback or hotfix is needed urgently
- Post-incident review is requested
- Runbook creation is needed for a recurring incident class

## Workflow

### Phase 1: Detection and Severity Classification

#### Severity Levels
```
P0 -- Critical
  Impact: Complete outage, data loss, security breach, revenue-critical flow broken
  Response: All hands. Drop everything. Mitigate within minutes.
  Communication: Immediate stakeholder notification, status page update
  Example: Site is down, payments are failing, user data is exposed

P1 -- High
  Impact: Major feature broken, significant user subset affected, degraded performance
  Response: Dedicated responder(s). Prioritize above all other work.
  Communication: Stakeholder notification within 30 minutes, status page update
  Example: Search is broken, uploads failing for 20% of users, p99 latency 10x normal

P2 -- Medium
  Impact: Non-critical feature broken, workaround available, limited user impact
  Response: Address within current work cycle. Monitor for escalation.
  Communication: Internal team notification, no external status page update
  Example: Export feature broken, dark mode rendering issue, slow report generation

P3 -- Low
  Impact: Cosmetic issue, edge case, minimal user impact
  Response: Schedule for next sprint. Monitor but do not interrupt current work.
  Communication: Log internally, no immediate notification needed
  Example: Tooltip misaligned, rare timezone edge case, non-critical log noise
```

#### Classification Checklist
1. How many users are affected? (all / subset / individual)
2. Is a revenue-critical flow broken? (yes / no)
3. Is data being lost or corrupted? (yes / no)
4. Is there a security dimension? (yes / no)
5. Is there a workaround? (yes / no)
6. Is the impact growing or stable? (growing / stable)

If any of these are true, escalate one severity level:
- Impact is growing over time
- Data loss or corruption is occurring
- Security is involved
- No workaround exists and a revenue-critical flow is broken

### Phase 2: Triage

#### Assess Impact (first 5 minutes)
1. **What is broken?** Write a one-sentence description of the user-visible symptom
2. **Who is affected?** Identify the scope -- all users, a region, a customer segment, a specific flow
3. **When did it start?** Check monitoring for the exact time the anomaly began
4. **What changed?** Check recent deployments, config changes, infrastructure events, and third-party status pages
5. **Is it getting worse?** Determine if the blast radius is expanding

#### Identify Scope
1. Check error rates -- is this isolated to one service or cascading?
2. Check dependent services -- are downstream systems also affected?
3. Check geographic scope -- is this region-specific?
4. Check platform scope -- is this browser/device/OS-specific?

#### Assign Roles (P0/P1 only)
```
Incident Commander: Coordinates response, makes decisions, owns the timeline
  - Single point of authority during the incident
  - Does NOT debug -- focuses on coordination and communication

Investigator(s): Diagnose the root cause and implement mitigation
  - Hands on keyboards, following the investigation workflow
  - Report findings to the Incident Commander

Communicator: Handles status updates and stakeholder communication
  - Posts status page updates at regular intervals
  - Shields investigators from interruptions
```

For P2/P3 incidents, a single responder fills all roles.

### Phase 3: Investigation Under Pressure

**The cardinal rule: do not skip structure because you are rushed.** Panicked debugging wastes more time than methodical investigation.

#### Structured Investigation Steps
1. **State the hypothesis before acting.** Say out loud (or write down) what you think is wrong before you start looking. This prevents aimless searching.

2. **Check the obvious first:**
   - Was there a recent deploy? Check the deploy log and compare the start time of the incident to the deploy time.
   - Was there a config change? Check config management and feature flag systems.
   - Is a dependency down? Check third-party status pages and internal dependency health.
   - Is there a resource exhaustion? Check CPU, memory, disk, connection pools, queue depth.

3. **Follow the request path:**
   - Start at the user-facing symptom
   - Trace the request through each layer (load balancer, application, database, cache, external service)
   - Identify where the request succeeds and where it fails or degrades
   - The boundary between "works" and "broken" is where the root cause lives

4. **Use timestamps:**
   - Correlate the incident start time with logs, metrics, and events
   - Look for the first anomaly, not just the loudest one
   - The first error is often more informative than the cascade that follows

5. **Limit investigation scope:**
   - Set a timebox: if you have not identified the cause in 15 minutes, escalate or try a different angle
   - Do not go down rabbit holes -- if a lead is not producing results after 5 minutes, back out and try another

#### Log Investigation in Real Time
Write findings to `active/active_issue.md` as you go:
```
### Investigation Timeline
- [HH:MM] Symptom: [what we see]
- [HH:MM] Checked: [what we looked at] -- Result: [what we found]
- [HH:MM] Hypothesis: [current theory]
- [HH:MM] Action: [what we're doing about it]
```

This timeline becomes the foundation of the post-incident review.

### Phase 4: Mitigation Strategies

**Principle: Mitigate first, root-cause second.** The goal is to stop the bleeding. A full fix can come later.

#### Strategy Selection Guide

##### Rollback
```
When to use: A recent deploy caused the incident and the previous version was healthy
How:
1. Identify the last known-good artifact (commit SHA, image digest, package version)
2. Trigger redeployment of that artifact
3. Verify the rollback resolves the symptom
4. Do NOT attempt to "fix forward" during a P0/P1 -- rollback first

Pros: Fast, well-understood, low risk
Cons: Loses new functionality, may not help if the issue is data or config
```

##### Feature Flags
```
When to use: The incident is caused by a specific feature that can be toggled off
How:
1. Identify the feature flag controlling the broken functionality
2. Disable the flag in production
3. Verify the symptom resolves
4. The rest of the deploy remains intact

Pros: Surgical, fast, preserves other changes
Cons: Requires feature flags to already be in place
```

##### Hotfix
```
When to use: The root cause is identified, the fix is small and obvious, rollback is not viable
How:
1. Write the minimal fix -- one logical change only
2. Get a fast review (pair with another engineer, screen share)
3. Run the critical test subset (not the full suite -- speed matters)
4. Deploy through the normal pipeline (do not bypass CI)
5. Monitor closely for 30 minutes post-deploy

Pros: Fixes the actual problem
Cons: Risky under pressure, potential for introducing new bugs
```

##### Traffic Shifting
```
When to use: The issue is load-related, region-specific, or affecting a subset of infrastructure
How:
1. Shift traffic away from the affected region, instance, or shard
2. Verify the symptom resolves for redirected users
3. Investigate the affected infrastructure without user impact

Pros: Buys time without code changes
Cons: Requires traffic management capability, may overload healthy targets
```

##### Scaling
```
When to use: Resource exhaustion (CPU, memory, connections, queue depth)
How:
1. Scale up the constrained resource (add instances, increase limits, expand pool)
2. Verify the symptom resolves
3. Investigate why the resource was exhausted (traffic spike, leak, inefficient query)

Pros: Addresses the immediate constraint
Cons: Treats the symptom, not the cause -- must follow up with root cause investigation
```

#### Mitigation Decision Flowchart
```
Was there a recent deploy?
  Yes -> Can we rollback? -> Yes -> ROLLBACK
                          -> No  -> Is there a feature flag? -> Yes -> DISABLE FLAG
                                                              -> No  -> HOTFIX (if root cause is clear)
  No  -> Is it load-related? -> Yes -> SCALE or SHIFT TRAFFIC
                              -> No  -> Is it a dependency failure? -> Yes -> FAILOVER or DEGRADE GRACEFULLY
                                                                    -> No  -> Continue investigation, escalate if P0/P1
```

### Phase 5: Communication

#### During the Incident

##### Status Update Template (External)
```
[Investigating/Identified/Monitoring/Resolved] -- [Service Name]

We are aware of an issue affecting [description of impact].

Current status: [what we know so far]
Impact: [who is affected and how]
Next update: [time of next update, e.g., "in 30 minutes or sooner if status changes"]
```

##### Internal Update Template
```
Incident: [one-line summary]
Severity: [P0/P1/P2/P3]
Start time: [when it began]
Current status: [investigating/mitigating/monitoring/resolved]

What we know:
- [finding 1]
- [finding 2]

What we're doing:
- [action 1]
- [action 2]

What we need:
- [help or resources needed, if any]

Next update: [time]
```

#### Update Cadence
- P0: Every 15 minutes until resolved
- P1: Every 30 minutes until resolved
- P2: At triage and resolution
- P3: At resolution only

#### Resolution Notification Template
```
[Resolved] -- [Service Name]

The issue affecting [description] has been resolved as of [time].

Root cause: [brief explanation]
Duration: [start time] to [resolution time] ([total duration])
Impact: [summary of who was affected and how]

We will publish a full post-incident review within [48 hours / 5 business days].
```

### Phase 6: Post-Incident Review

**Principle: Blameless.** The review examines systems and processes, not individuals. People made the best decisions they could with the information they had.

#### Timeline Construction
Build a detailed timeline from the investigation log:
```
[Time] Event/observation
[Time] Action taken
[Time] Result of action
...
```

Include: alerts, human actions, system events, communications, and decisions.

#### Root Cause Analysis
Use the "Five Whys" technique:
1. Why did the incident occur? [proximate cause]
2. Why did that happen? [deeper cause]
3. Why did that happen? [systemic cause]
4. Why did that happen? [process or design gap]
5. Why did that happen? [organizational or cultural factor]

Stop when you reach a cause that the team can act on. Not every incident needs all five levels.

#### Contributing Factors
Beyond the root cause, identify:
- What made detection slow?
- What made investigation harder than necessary?
- What made mitigation take longer?
- Were there missing runbooks, alerts, or dashboards?
- Were there communication gaps?

#### Action Items
Every action item must be:
- **Specific**: "Add an alert for queue depth exceeding 10,000" not "improve monitoring"
- **Assigned**: Someone owns it
- **Timebound**: Has a due date
- **Prioritized**: P0/P1 incident action items get scheduled immediately, not "added to the backlog"

Categories of action items:
- **Detection**: Improve alerts, dashboards, or health checks so we catch this faster next time
- **Prevention**: Fix the root cause so this class of incident cannot recur
- **Mitigation**: Improve the ability to respond quickly (runbooks, feature flags, rollback procedures)
- **Process**: Improve communication, escalation, or coordination during incidents

### Phase 7: Runbook Creation

For any incident class that has occurred twice or could reasonably recur, create a runbook.

#### Runbook Template
```markdown
# Runbook: [Incident Class Name]

## Symptoms
- [What alerts fire]
- [What users see]
- [What metrics look like]

## Likely Causes
1. [Most common cause]
2. [Second most common cause]
3. [Less common but possible cause]

## Diagnosis Steps
1. [Check this first]
2. [Then check this]
3. [Then check this]

## Mitigation Steps
1. [Do this to stop the bleeding]
2. [Then do this]
3. [Verify with this check]

## Escalation
- If the above steps do not resolve the issue within [time], escalate to [team/person]
- Contact information: [details]

## History
- [Date]: [Brief description of past occurrence and resolution]
```

## Integration with Melted Peak

### Known Issues
- After any incident, log it in `memory/known_issues.md` with:
  - The root cause
  - The mitigation that worked
  - A reference to the post-incident review
  - The status of follow-up action items

### Regression Checklist
- After any incident caused by a code change, add the affected area to `active/regression_checklist.md`
- Include the specific check that would have caught this before deployment

### Retrospective
- For P0/P1 incidents, run the retrospective skill after the post-incident review
- Feed lessons learned back into the system via `memory/change_log.md` with tag `[incident-learning]`
- If the incident reveals a gap in an existing skill (e.g., deployment-workflow missed a pre-deploy check), update that skill

### Active Context
- During an active incident, update `active/active_context.md` with current incident status
- Create `active/active_issue.md` for the incident -- this is the single-issue focus during response
- After resolution, record the outcome in `memory/progress_log.md` and `memory/recent_deltas.md`

## Critical Rules

- **Mitigate first, root-cause second.** Restoring service is always the top priority during P0/P1.
- **Never skip severity classification.** Correct severity drives correct response urgency and communication.
- **Structure under pressure.** Follow the investigation steps even when rushed. Panicked debugging wastes more time.
- **Blameless post-incident reviews.** Review systems and processes, not people.
- **Every P0/P1 gets a post-incident review.** No exceptions. P2 gets a lightweight review. P3 gets a log entry.
- **Action items must be specific and assigned.** Vague follow-ups do not prevent recurrence.
- **Communicate at the promised cadence.** A "no new information" update is better than silence.

## Anti-Patterns
- Skipping triage and jumping straight to debugging -- you may misclassify severity and under-communicate
- "Fix forward" during a P0 when a rollback is available -- rollback is almost always faster and safer
- Investigating in silence without posting status updates -- stakeholders will interrupt you, costing more time
- Blaming individuals in post-incident reviews -- this shuts down honest reporting of future incidents
- Writing vague action items like "improve monitoring" -- these never get done
- Skipping the post-incident review because "we already know what happened" -- the review captures systemic factors, not just the proximate cause
- Not creating runbooks for recurring incidents -- you will re-investigate from scratch next time
- Letting action items rot in a backlog -- unaddressed action items from P0/P1 incidents should be treated as high-priority work
