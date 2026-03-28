#!/bin/bash
# Context Pressure Monitor - warns agent when context window is running low
# Runs on PostToolUse for all tools
# Uses debounce: only warns every 10 tool calls to avoid noise
# Exit 0 = normal, Exit 2 = warning injected into conversation

# Track call count via temp file for debounce
COUNTER_FILE="/tmp/mp-context-monitor-$$"
if [ ! -f "$COUNTER_FILE" ]; then
  echo "0" > "$COUNTER_FILE"
fi

COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Only check every 10 tool calls (debounce)
if [ $((COUNT % 10)) -ne 0 ]; then
  exit 0
fi

# Check conversation size by looking at the session JSONL file size
# Large sessions indicate high context usage
SESSION_DIR="$HOME/.claude/projects"
if [ -d "$SESSION_DIR" ]; then
  # Find the most recent session file
  LATEST=$(find "$SESSION_DIR" -name "*.jsonl" -newer /tmp/mp-session-start 2>/dev/null | head -1)
  if [ -n "$LATEST" ]; then
    SIZE=$(wc -c < "$LATEST" 2>/dev/null || echo "0")
    # Rough heuristic: >2MB session file = getting large, >4MB = critical
    if [ "$SIZE" -gt 4000000 ]; then
      echo "CONTEXT PRESSURE CRITICAL (session file >4MB): Consider running /handoff now to preserve state before context degrades. Wrap up current task, update active_context.md, and write session_handoff.md." >&2
      exit 2
    elif [ "$SIZE" -gt 2000000 ]; then
      echo "CONTEXT PRESSURE WARNING (session file >2MB): Context window is getting large. Plan to wrap up soon. Avoid starting new complex tasks. Consider running /handoff if current task is at a natural stopping point." >&2
      exit 2
    fi
  fi
fi

exit 0
