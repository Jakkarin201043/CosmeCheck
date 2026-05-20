## 2024-05-18 - ARIA Labels for Icon-Only Buttons
**Learning:** Icon-only buttons (like social sign-in buttons or password visibility toggles) are inaccessible to screen readers without descriptive text. The internal spans containing the icons/text should also be hidden from screen readers.
**Action:** Always add descriptive `aria-label` attributes to the `<button>` element and set `aria-hidden="true"` on the internal `<span>` containing the icon/text to prevent confusing screen reader announcements.
