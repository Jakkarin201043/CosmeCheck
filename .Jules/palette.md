## 2024-06-05 - Auth Form Accessibility & UX
**Learning:** The static frontend authentication forms lacked proper semantic attributes (`type="submit"`, `for`/`id` linking, `autocomplete`) and `aria-label`s for icon-only buttons, reducing accessibility and keyboard navigation UX.
**Action:** Always ensure inputs have associated labels via `for`/`id`, use `type="submit"` for primary actions, and add descriptive `aria-label`s and `aria-hidden="true"` to icon-only interactive elements.
