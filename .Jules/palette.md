## 2026-05-12 - Authentication Form UX & Security Baseline
**Learning:** Authentication forms in this app consistently lack basic structural accessibility and standard security markers (e.g., `<label for="...">`, autocomplete attributes, aria-labels for visibility toggles, and CSRF token placeholders).
**Action:** Next time, ensure all authentication form inputs have correct `id`/`name`/`autocomplete` attributes perfectly linked to `for` labels, make sure any icon buttons have `aria-label`s, ensure `method="POST"`, and include hidden CSRF token placeholders.
