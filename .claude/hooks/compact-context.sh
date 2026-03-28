#!/bin/bash
echo "=== MELTED PEAK CONTEXT ==="
[ -f active/active_context.md ] && head -5 active/active_context.md
[ -f active/active_issue.md ] && head -3 active/active_issue.md
echo "Rules: 1) Track attempts 2) One issue 3) Plan before code 4) Verify after"
echo "=== END ==="
