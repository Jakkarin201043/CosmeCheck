## 2024-05-24 - Form Keyboard Accessibility

**Learning:** When building static HTML mockups or SPAs without full backend integration, adding `onsubmit="event.preventDefault();"` directly to the form ensures hitting "Enter" doesn't trigger a page reload while still allowing `type="submit"` buttons to natively handle keyboard submission accessibility.
**Action:** Always include this pattern when upgrading static forms to use semantic `type="submit"` buttons.
