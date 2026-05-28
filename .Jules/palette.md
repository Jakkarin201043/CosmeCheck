## 2026-05-28 - Missing `aria-label` on Icon Buttons
**Learning:** Found that icon-only buttons like Google and Apple sign-ins lack `aria-label`s, which makes them inaccessible for screen readers. Added `aria-hidden` to their inner span and applied labels at the button level.
**Action:** Always add descriptive `aria-label` to the outer `<button>` element and apply `aria-hidden="true"` to any decorative icon inside.
