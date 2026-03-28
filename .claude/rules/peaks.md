---
globs: "peaks/**"
---

# Rules for Peaks

- Never modify peak source files directly
- Peak integration uses overlay files: `peaks/active_peaks.yaml` and `peaks/active_profiles.yaml`
- Peak-provided components are namespaced: `[peak-name]/[component-name]`
- Check `conflicts.peaks` before mounting a new peak
- All peak operations logged in `memory/change_log.md` with `[peak-mount]` or `[peak-unmount]` tags
- Peak skills and knowledge must be registered in the main registry indexes
