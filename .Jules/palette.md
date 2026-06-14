## 2024-05-18 - Playwright Strict Mode with get_by_label
**Learning:** When testing forms with Playwright, `page.get_by_label("Password")` can throw strict mode violations if the form also contains a button with `aria-label="Toggle password visibility"`, as it resolves to multiple elements.
**Action:** Use precise ID selectors (e.g., `page.locator('#password')`) or `exact=True` when interacting with form inputs to avoid unintended matches with similarly labeled utility buttons.
