# Escalation Decision Prompt

Use when unsure whether to continue working autonomously or escalate to the user.

---

## Decision Tree

```
Should I escalate to the user?

Am I about to make a destructive or irreversible action?
├── Yes → ESCALATE (always)
└── No
    Am I blocked and the three-strike rule has triggered?
    ├── Yes → ESCALATE (present options, don't guess)
    └── No
        Has the scope expanded beyond the original plan?
        ├── Yes → ESCALATE (get confirmation on new scope)
        └── No
            Am I making an architecture decision that affects future work?
            ├── Yes → ESCALATE (record as ADR, get confirmation)
            └── No
                Am I confident in my approach (high confidence)?
                ├── Yes → Continue working
                └── No → ESCALATE (present what you know and don't know)
```

## How to Escalate

When escalating, provide:
1. **Context**: What you were doing and why you stopped
2. **Options**: 2-3 concrete paths forward (not "what should I do?")
3. **Recommendation**: Which option you'd choose and why
4. **Risk**: What could go wrong with each option

## When to Use
- Three-strike rule triggered
- Scope expansion detected
- Destructive operations needed
- Architecture decisions with long-term impact
- Low confidence on approach
