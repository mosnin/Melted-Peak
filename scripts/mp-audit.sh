#!/bin/bash
# Run Melted Peak self-audit via headless mode
claude -p "Read docs/core/20_self_audit_protocol.md and execute all 8 audit checks. Report results." \
  --allowedTools "Read,Glob,Grep" \
  --output-format json
