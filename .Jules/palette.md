## 2024-11-20 - Disable Spellcheck on Sensitive Inputs
**Learning:** Input fields and textareas containing sensitive user data (e.g., medical or allergy notes) should have spellcheck disabled to prevent transmitting sensitive data to spellcheck servers, improving privacy.
**Action:** Add spellcheck="false" to all input and textarea elements that handle sensitive or medical information.