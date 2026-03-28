---
name: peak
description: Manage peaks — import, mount, unmount, list, or create domain-specific sub-systems
user-invocable: true
---

# /peak — Peak Manager

- `/peak list` — show all peaks and mount status
- `/peak mount [name]` — mount a peak (add to active_peaks.yaml)
- `/peak unmount [name]` — unmount a peak
- `/peak import [url]` — import new peak from git URL
- `/peak create [name]` — scaffold a new peak

See `skills/peak-manager/source/SKILL.md` for full workflow.
