## 2024-10-24 - Native Form Submission & Accessibility
**Learning:** Authentication forms in this app lack semantic HTML, preventing native 'Enter' key submission and causing poor screen reader experiences.
**Action:** Always use method="POST", add hidden CSRF tokens, explicitly link labels with input IDs, use appropriate autocomplete attributes, and use type="submit" for primary buttons.
