#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
if echo "$FILE_PATH" | grep -qE '(active/|memory/|docs/|incoming/|\.claude/|peaks/|CLAUDE\.md|README\.md|\.gitkeep|\.gitignore)'; then
  exit 0
fi
if [ -f active/change_plan.md ] && grep -q 'No active change plan' active/change_plan.md 2>/dev/null; then
  echo "MELTED PEAK: Modifying code without a change plan. Write to active/change_plan.md first." >&2
  exit 2
fi
exit 0
