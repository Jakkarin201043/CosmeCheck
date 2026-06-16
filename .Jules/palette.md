
## 2026-06-16 - Prevent Default Submit on Static Forms
**Learning:** In purely static HTML projects, form submissions via an explicit submit button default to a GET or POST request to the current URL. While adding a submit button natively enables 'Enter' to submit (a major accessibility win), it causes 'Method Not Allowed' (501) or page reload errors when tested locally via a simple Python server, breaking the local development UX flow.
**Action:** When adding type="submit" to a form button in a static local project, always add onsubmit="event.preventDefault();" to the <form> tag to prevent the browser from attempting a real submission that fails against a local static server, while still providing the native 'Enter to submit' functionality for users.
