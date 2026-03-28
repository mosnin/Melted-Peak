#!/bin/bash
# TDD Guard Hook - blocks production code writes when no test was modified first
# Runs on PreToolUse for Edit and Write tools
# Exit 0 = allow, Exit 2 = block with message to Claude

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"//' | sed 's/"//')
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//' | sed 's/"//')

# Only check Edit and Write tools
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" ]]; then
  exit 0
fi

# Skip if no file path found
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Skip non-code files (markdown, yaml, json, config, etc.)
case "$FILE_PATH" in
  *.md|*.yaml|*.yml|*.json|*.toml|*.ini|*.cfg|*.conf|*.env*|*.txt|*.csv|*.xml|*.html|*.css|*.svg|*.gitignore|*.dockerignore|Makefile|Dockerfile|*.lock|*.sh)
    exit 0
    ;;
esac

# Skip Melted Peak system files
case "$FILE_PATH" in
  */active/*|*/memory/*|*/docs/*|*/skills/*|*/knowledge/*|*/peaks/*|*/incoming/*|*/.claude/*|*/frameworks/*)
    exit 0
    ;;
esac

# Skip if the file itself IS a test file
case "$FILE_PATH" in
  *test*|*spec*|*__tests__*|*.test.*|*.spec.*|*_test.*|*_spec.*)
    exit 0
    ;;
esac

# Check if any test file was modified in this session (git diff)
TEST_CHANGES=$(git diff --name-only HEAD 2>/dev/null | grep -iE '(test|spec|__tests__)' | head -1)
TEST_STAGED=$(git diff --cached --name-only 2>/dev/null | grep -iE '(test|spec|__tests__)' | head -1)

if [[ -n "$TEST_CHANGES" || -n "$TEST_STAGED" ]]; then
  exit 0
fi

# No test changes detected — warn
echo "TDD GUARD: You are writing production code ($FILE_PATH) but no test files have been modified in this session. Write the failing test first (RED), then implement. See skills/tdd-enforcement/ for the full TDD workflow." >&2
exit 2
