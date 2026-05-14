# CosmeCheck

CosmeCheck is a Thai Flutter offline MVP for skincare ingredient scanning and review. The app uses local OCR, a local ingredient database, local scan history, and local saved products. It does not use a backend, cloud sync, Firebase, Supabase, or an AI API.

## Offline MVP Features

- Camera OCR from a captured label image using `image_picker` and local ML Kit text recognition.
- Gallery OCR from an existing image using the same local OCR and parser flow.
- Confirm Ingredients step before analysis, with separate known and unknown ingredient sections.
- Unknown ingredient handling that preserves OCR text without judging unknowns as safe or dangerous.
- Local scan history persisted with `shared_preferences`.
- Local saved products persisted with `shared_preferences`, including remove support.
- Ingredient Search and Ingredient Detail backed by `assets/data/ingredients.json`.
- 100 local/offline ingredient records in the JSON database.
- Mock scan fallback retained for regression testing.
- Cautious educational wording and medical disclaimer on scan result and ingredient detail screens.

## Current App Flow

Camera/Gallery OCR -> Confirm Ingredients -> Scan Result -> History/Saved

The mock fallback still opens a sample Scan Result directly so the app remains testable if OCR is unavailable.

## Build And Verification

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
```

Debug APK output:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## Manual QA Checklist

- เปิดแอพได้
- Camera OCR: ถ่ายรูปฉลากแล้วเข้า Confirm Ingredients
- Gallery OCR: เลือกรูปจากเครื่องแล้วเข้า Confirm Ingredients
- Confirm Ingredients: ลบ known ingredient ได้
- Confirm Ingredients: เพิ่ม known ingredient ได้
- Confirm Ingredients: ลบ unknown ingredient ได้
- Confirm Ingredients: เพิ่ม unknown ingredient ได้
- กด Analyze แล้วไปหน้า Scan Result
- Unknown ingredients แสดงใน Scan Result และไม่ถูกตัดสินว่าปลอดภัยหรืออันตราย
- กดบันทึกผลลัพธ์ได้
- History แสดงผลสแกนจริง
- Saved Products แสดงรายการที่บันทึกจริง
- ลบ Saved Product ได้
- ปิดแอพแล้วเปิดใหม่ History ยังอยู่
- ปิดแอพแล้วเปิดใหม่ Saved Products ยังอยู่
- Mock fallback ยังใช้งานได้
- ภาษาไทยไม่ล้นจอ

## Known Limitations

- No backend.
- No cloud sync.
- No Firebase or Supabase.
- No AI API.
- No live camera preview or real-time OCR.
- OCR quality still depends on image clarity, lighting, and physical-device behavior.
- Physical Android device QA is still required before broader release.
