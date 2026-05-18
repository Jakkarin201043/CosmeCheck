## 2024-05-24 - Accessible Icon Buttons
**Learning:** Icon-only buttons or buttons containing single characters (like social sign-in buttons) cause confusing screen reader announcements if they rely solely on their visual content.
**Action:** Always add descriptive `aria-label` attributes to the `<button>` element and set `aria-hidden="true"` on the internal `<span>` containing the icon/text.
