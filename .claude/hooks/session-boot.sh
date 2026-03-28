#!/bin/bash
echo "=== MELTED PEAK BOOT ==="
echo "System active. Read CLAUDE.md for boot sequence."
[ -f peaks/active_peaks.yaml ] && grep 'name:' peaks/active_peaks.yaml 2>/dev/null
echo "=== END BOOT ==="
