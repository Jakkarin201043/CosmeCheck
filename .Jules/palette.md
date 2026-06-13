## 2026-06-13 - [Form Accessibility Pattern]
**Learning:** [When improving authentication forms in this static frontend repository, changing the "Sign In" button `type` to `"submit"` natively enables "Enter" key submission, functioning as a critical UX win without adding complex JS.]
**Action:** [Always ensure primary action buttons in forms use `type="submit"` rather than `type="button"` and add `onsubmit="event.preventDefault();"` if server interaction is not yet implemented or to prevent page reloads during local testing.]
