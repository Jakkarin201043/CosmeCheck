## 2024-05-20 - Adding ARIA attributes to Material Symbols
**Learning:** When using Material Symbols Outlined icons within buttons, screen readers may read the text content of the icon (e.g., "visibility_off" or "ios") which is confusing for visually impaired users.
**Action:** Always add `aria-hidden="true"` to the `<span>` element containing the Material Symbol text, and provide a descriptive `aria-label` on the parent `<button>` element.
