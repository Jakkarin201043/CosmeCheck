## 2026-05-05 - Enhance Login Form Accessibility
**Learning:** Found multiple instances where form inputs lacked `id` attributes matching their `<label>`'s `for` attribute, and several icon-only buttons (password toggle, social login) lacked `aria-label`s. These are critical for screen reader users and form a pattern to watch for in other components.
**Action:** Always verify form structure (labels properly linked to inputs) and ensure all icon-only interactive elements have descriptive `aria-label`s when creating or modifying UI components.
