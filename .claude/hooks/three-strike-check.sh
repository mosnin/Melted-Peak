#!/bin/bash
if [ -f active/active_issue.md ]; then
  ATTEMPTS=$(grep -c '### Attempt' active/active_issue.md 2>/dev/null || echo 0)
  if [ "$ATTEMPTS" -ge 3 ]; then
    echo "MELTED PEAK THREE-STRIKE: $ATTEMPTS attempts logged. Stop and analyze per docs/core/15_error_recovery_protocol.md" >&2
  fi
fi
exit 0
