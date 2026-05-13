# CosmeCheck

Flutter prototype for skincare ingredient scanning. Current OCR scope is gallery image OCR plus the existing mock scan fallback.

## Manual QA Checklist

- Gallery OCR: choose a clear INCI/ingredient label image and confirm the scan result opens with detected ingredients.
- Cancel image picker: tap gallery scan, cancel selection, and confirm the scan screen stays stable with no error.
- Blurry image: choose a blurry label and confirm the app shows a friendly Thai empty/error message without crashing.
- Ingredients prefix: test labels with `Ingredients:`, `INCI:`, `Active Ingredients:`, or `ส่วนผสม:` and confirm parsing ignores the prefix.
- Fragrance alias: test `Parfum` or `Fragrance / Parfum` and confirm Fragrance risk is detected.
- Mock fallback: tap the mock scan button and confirm it still opens the scan result.
- Result validation: confirm raw OCR/parsing output does not make medical diagnosis claims.
