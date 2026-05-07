## 2024-05-24 - Disabling Spellcheck for Sensitive Medical/Allergy Data
**Learning:** Browsers natively send input field data to external spellcheck services. For privacy and security, fields containing sensitive user data (like medical conditions or allergy notes) should have this disabled.
**Action:** Added `spellcheck="false"` to allergy notes textarea and ingredients to avoid input field. Will ensure similar fields in the future have this attribute set to false.
