---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing — before committing, creating PRs, or moving to the next task; requires running verification commands and reading actual output before making any success claims
user-invocable: false
---

# Verification Before Completion

No completion claims without fresh verification evidence.

**The Gate Function:**
1. IDENTIFY — what command proves this claim?
2. RUN — execute it fully, fresh, this message
3. READ — full output, exit code, failure count
4. VERIFY — does output confirm the claim?
5. ONLY THEN — make the claim

**Red Flags — Stop and verify first:**
- Using "should", "probably", "seems to"
- Satisfaction expressed before running anything
- Trusting agent self-reports
- Partial verification extrapolated to full pass

**Rationalization Table:**

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Agent said success" | Check the diff |
| "Partial check enough" | Partial proves nothing |
| "Just this once" | No exceptions |

See `skills/verification-before-completion/source/SKILL.md` for full detail.
