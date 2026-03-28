#!/bin/bash
# Run code review on staged changes
claude -p "Review the staged git changes using the code-review skill at skills/code-review/source/SKILL.md. Use standard depth." \
  --allowedTools "Read,Glob,Grep,Bash(git diff *),Bash(git log *)" \
  --output-format json
