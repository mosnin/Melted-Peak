# Incident Response -- Summary

Structured seven-phase production incident response workflow: Detect, Triage, Investigate, Mitigate, Communicate, Review, and create Runbooks. Maintains discipline under pressure and feeds incident learnings back into Melted Peak.

## When to Use
- A production incident is reported or alerts fire
- Service degradation or outage is detected
- A rollback or emergency hotfix is needed
- Post-incident review is requested
- Creating runbooks for recurring incident classes

## Key Steps
1. **Detect and Classify**: Assign severity P0-P3 using the classification checklist
2. **Triage**: Assess impact, identify scope, assign roles (P0/P1), determine what changed
3. **Investigate**: Follow structured investigation steps -- hypothesis first, check the obvious, trace the request path, use timestamps
4. **Mitigate**: Choose strategy (rollback, feature flag, hotfix, traffic shift, scaling) -- mitigate first, root-cause second
5. **Communicate**: Post status updates at the correct cadence using templates
6. **Review**: Blameless post-incident review with timeline, Five Whys, contributing factors, and specific action items
7. **Runbook**: Create or update runbooks for any incident class that recurs or could recur

## Critical Rules
- Mitigate first, root-cause second (P0/P1)
- Never skip severity classification
- Structure under pressure -- no panicked debugging
- Blameless reviews -- systems and processes, not people
- Every P0/P1 gets a post-incident review, no exceptions
- Action items must be specific, assigned, and timebound

## Context Cost
Small -- the skill is a workflow guide with templates, not reference material.
