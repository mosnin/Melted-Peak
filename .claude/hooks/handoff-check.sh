#!/bin/bash
if grep -q 'No previous session\|awaiting first task' memory/session_handoff.md 2>/dev/null; then
  echo "MELTED PEAK: Session ending without handoff. Run /handoff first." >&2
fi
if git -C . status --porcelain 2>/dev/null | grep -q '^'; then
  echo "MELTED PEAK: Uncommitted changes detected." >&2
fi
exit 0
