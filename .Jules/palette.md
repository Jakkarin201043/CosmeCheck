## 2026-05-23 - Unhidden Icon-Only Button Patterns
**Learning:** Icon-only buttons (like social logins and visibility toggles) without proper ARIA attributes lead to confusing or empty screen reader announcements because the inner icon text or SVGs are read out of context or ignored.
**Action:** Always add descriptive `aria-label` attributes to the `<button>` wrapper and set `aria-hidden="true"` on the internal `<span>` containing the icon/text.
