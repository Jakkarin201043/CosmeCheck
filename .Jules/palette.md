## 2024-05-24 - Accessibility for icon-only buttons
**Learning:** Icon-only and single-character buttons (like social sign-in or visibility toggles) in authentication flows need descriptive aria-labels on the button and aria-hidden="true" on their internal text/icons to prevent confusing screen reader announcements.
**Action:** Always add descriptive aria-label attributes to the <button> element and set aria-hidden="true" on the internal <span> for icon-only and single-character buttons.
