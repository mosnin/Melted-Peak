# Accessibility Review Skill

## Purpose

Structured workflow for reviewing web interfaces against WCAG 2.1 AA standards. Covers semantic HTML, keyboard navigation, screen reader compatibility, color contrast, form accessibility, and interactive element correctness.

## Severity Ratings

| Level | Meaning | Examples |
|-------|---------|----------|
| **P0** | Blocks access -- user cannot complete task | Missing form labels, keyboard trap, no alt text on functional image |
| **P1** | Significant barrier -- task completion is degraded | Poor focus management, missing skip links, low contrast on body text |
| **P2** | Minor inconvenience -- usable but suboptimal | Redundant ARIA, inconsistent focus style, verbose alt text |

---

## 1. WCAG 2.1 AA Quick Checklist

Run through these checks first to get a high-level picture:

- [ ] All interactive elements reachable and operable via keyboard alone
- [ ] Visible focus indicator on every focusable element
- [ ] Screen reader announces content in a logical, complete order
- [ ] Text contrast ratio meets 4.5:1 (normal) / 3:1 (large text)
- [ ] No information conveyed by color alone
- [ ] Page has a descriptive `<title>`
- [ ] Language attribute set on `<html>`
- [ ] Content reflows at 320px width without horizontal scroll
- [ ] No content flashes more than 3 times per second
- [ ] Error messages are programmatically associated with their fields

---

## 2. Semantic HTML Audit

### Elements and Landmarks

- Use native HTML elements over ARIA when possible (`<button>` not `<div role="button">`)
- Verify landmark regions: `<header>`, `<nav>`, `<main>`, `<aside>`, `<footer>`
- Each page must have exactly one `<main>`
- Multiple `<nav>` elements must have distinct `aria-label` values

### Heading Hierarchy

- Exactly one `<h1>` per page
- Headings must not skip levels (no `<h1>` followed by `<h3>`)
- Headings must reflect content structure, not visual styling
- Do not use headings for visual effect alone -- use CSS instead

### Images and Alt Text

- Decorative images: `alt=""` (empty, not missing)
- Informative images: alt text describes the content or function
- Complex images (charts, diagrams): provide extended description via `aria-describedby` or adjacent text
- Background images that convey information must have a text alternative
- `<svg>` elements need `role="img"` and `aria-label` or `<title>` element

---

## 3. Interactive Element Review

### Focus Indicators

- Every focusable element must have a visible focus style
- Focus indicator must have at least 3:1 contrast against adjacent colors
- Do not use `outline: none` without providing a replacement
- Custom focus styles should be at least as visible as the browser default

### ARIA Attributes

- Do not use ARIA to replicate native HTML behavior
- Verify `aria-expanded`, `aria-selected`, `aria-checked` reflect actual state
- Dynamic content changes must use `aria-live` regions (see section 6)
- `aria-hidden="true"` must not be set on focusable elements
- Custom widgets must implement the correct ARIA pattern (see WAI-ARIA Authoring Practices)

### Role Assignments

- Only use valid ARIA roles
- `role="presentation"` or `role="none"` removes semantic meaning -- use intentionally
- Composite roles (e.g., `tablist`/`tab`/`tabpanel`) must include all required children/relationships
- Verify `role` is not applied to elements that already have the correct implicit role

---

## 4. Color Contrast Verification

### Ratios

| Content Type | Minimum Ratio |
|-------------|---------------|
| Normal text (< 18pt / < 14pt bold) | 4.5:1 |
| Large text (>= 18pt / >= 14pt bold) | 3:1 |
| UI components and graphical objects | 3:1 |

### Checks

- Test foreground/background combinations in all component states (default, hover, active, disabled)
- Check placeholder text contrast (often fails)
- Verify contrast on overlaid text (images, gradients, video)
- Disabled elements are exempt from contrast requirements but should still be perceivable
- Links within text must be distinguishable by more than color (underline, bold, icon)

### Tools

- Browser DevTools color picker shows contrast ratio
- axe DevTools, Lighthouse, or WAVE for automated scanning
- Manual check with a contrast ratio calculator for edge cases

---

## 5. Keyboard Navigation Testing

### Tab Order

- Tab order must follow visual reading order (left-to-right, top-to-bottom for LTR languages)
- `tabindex="0"` to add elements to natural tab order
- `tabindex="-1"` for programmatic focus only (not in tab sequence)
- Never use `tabindex` values greater than 0

### Focus Traps

- Modals must trap focus within the dialog until dismissed
- Focus must return to the trigger element when the modal closes
- No unintentional focus traps elsewhere on the page
- Escape key must close modal dialogs

### Skip Links

- Provide a "skip to main content" link as the first focusable element
- Skip link must be visible on focus
- Target must be a focusable element or have `tabindex="-1"`

### Keyboard Shortcuts

- Custom shortcuts must not conflict with browser or assistive technology shortcuts
- Single-character shortcuts must be remappable, disableable, or only active on focus
- Document all custom keyboard interactions

---

## 6. Screen Reader Testing Approach

### What to Check

- Page title announced on load
- Landmarks navigable via screen reader shortcuts
- Headings list provides a meaningful document outline
- Form fields announce label, role, state, and any help text
- Dynamic updates announced via `aria-live` regions
- Images convey correct information (or are skipped if decorative)
- Tables have proper headers (`<th>`, `scope`, or `headers` attributes)

### Common Issues

- Content visually present but not in the accessibility tree (`aria-hidden`, `display: none`)
- Content in the accessibility tree but not visible (off-screen text without purpose)
- Announcements that are too verbose or too terse
- Missing or incorrect `aria-label` overriding visible text
- Focusable elements with no accessible name

### ARIA Live Regions

- `aria-live="polite"` for non-urgent updates (search results, status messages)
- `aria-live="assertive"` only for critical, time-sensitive alerts
- Keep live region content concise
- Avoid removing and re-adding live regions dynamically
- `role="status"` implies `aria-live="polite"`; `role="alert"` implies `aria-live="assertive"`

---

## 7. Form Accessibility

### Labels

- Every input must have a visible, programmatically associated `<label>`
- Use `for`/`id` pairing or wrap the input inside the `<label>`
- Placeholder text is not a substitute for a label
- Group related inputs with `<fieldset>` and `<legend>`

### Error Messages

- Display errors on submit and on field blur
- Associate error text with the field via `aria-describedby`
- Use `aria-invalid="true"` on fields with errors
- Summarize errors at the top of the form with links to each field
- Do not rely on color alone to indicate errors

### Required Fields

- Mark required fields with `required` or `aria-required="true"`
- Indicate required status visually (asterisk with legend, or text)
- Announce required status to screen readers

### Autocomplete

- Use `autocomplete` attribute on fields that collect personal data (name, email, address, etc.)
- Correct values: `name`, `email`, `tel`, `street-address`, `postal-code`, etc.
- Helps users with cognitive disabilities and password managers

---

## 8. Common Anti-Patterns and Fixes

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| `<div>` or `<span>` as button | No keyboard support, no role | Use `<button>` |
| Click handler on non-interactive element | Inaccessible to keyboard | Use `<button>` or `<a>` with `href` |
| `outline: none` globally | Removes focus indicator | Provide custom visible focus style |
| `tabindex > 0` | Breaks natural tab order | Use `tabindex="0"` and reorder DOM |
| `aria-label` on non-interactive `<div>` | Ignored by most screen readers | Apply to interactive or landmark elements |
| Image without `alt` attribute | Screen reader reads filename | Add descriptive `alt` or `alt=""` |
| Auto-playing media | Disorienting for screen reader users | Require user activation; provide pause control |
| CSS `content` for meaningful text | Not reliably exposed to AT | Use real text in HTML |
| `display: none` on live region | Prevents announcements | Use `visibility` or off-screen positioning |
| Infinite scroll without keyboard access | Traps keyboard users | Provide pagination alternative or keyboard controls |

---

## Review Output Format

When reporting findings, use this structure:

```
### [P0/P1/P2] Short description

**Location**: file/component/selector
**WCAG Criterion**: X.X.X criterion name
**Issue**: What is wrong
**Impact**: Who is affected and how
**Fix**: Specific remediation steps
```

Order findings by severity (P0 first), then by location.
