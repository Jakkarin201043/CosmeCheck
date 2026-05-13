## 2024-05-13 - Accessible Icon-Only Social Sign-in Buttons
**Learning:** Social sign-in buttons that rely on single characters (like 'G') or abstract icons without text labels are poorly announced by screen readers, creating confusion during authentication flows.
**Action:** Always add descriptive `aria-label`s (e.g., "Sign in with Google") to icon-only buttons and set `aria-hidden="true"` on the internal icon/text span to prevent redundant or confusing screen reader announcements.
