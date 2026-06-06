
## 2024-05-24 - Login Form Missing Semantic Logic
**Learning:** Static mockups often lack core form logic. Login forms heavily rely on `autocomplete` attributes (`email`, `current-password`) and `type="submit"` buttons to feel natively responsive and allow browser autofill and keyboard (Enter key) submission to work seamlessly. Additionally, buttons containing text representing an icon (like "G" for Google) need an `aria-label` to be read correctly by screen readers.
**Action:** When auditing forms, proactively check for ID-Label linkages, `autocomplete` attributes, and `type="submit"` on primary actions to ensure keyboard accessibility and native browser support.
