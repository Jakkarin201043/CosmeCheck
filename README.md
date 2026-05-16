# CosmeCheck

CosmeCheck is a Thai Flutter offline MVP for skincare ingredient scanning and review. The current MVP uses local camera/gallery OCR, a local 100-item ingredient database, local scan history, and local saved products. It does not use a backend, cloud sync, Firebase, Supabase, or an AI API.

ข้อมูลนี้ใช้เพื่อการให้ความรู้และประเมินเบื้องต้นเท่านั้น ไม่ใช่การวินิจฉัยโรค หากมีอาการผิดปกติควรปรึกษาแพทย์ผิวหนัง

## Offline MVP Features

- App name and visible identity: `CosmeCheck`.
- Camera OCR from a captured label image using `image_picker` and local Google ML Kit text recognition.
- Gallery OCR from an existing image using the same local OCR and parser flow.
- Confirm Ingredients step before analysis, with separate known and unknown ingredient sections.
- Unknown ingredient handling preserves OCR text without judging unknowns as safe or dangerous.
- Scan Result shows known matches, cautious notes, unknown ingredient chips, and the medical disclaimer.
- Local scan history persisted with `shared_preferences`.
- Local saved products persisted with `shared_preferences`, including remove support.
- Ingredient Search and Ingredient Detail backed by `assets/data/ingredients.json`.
- 100 local/offline ingredient records with English names, Thai names, INCI names, and aliases.
- Mock scan fallback retained for offline QA and regression testing.

## Current App Flow

```text
Camera OCR / Gallery OCR -> Confirm Ingredients -> Scan Result -> History / Saved
```

The mock fallback still opens a sample Scan Result directly so the app remains testable if OCR is unavailable.

## Local Privacy

- Camera and gallery images are processed locally on the device for the current offline MVP.
- Scan history, saved products, skin type, and selected watch-list ingredients are stored locally with `shared_preferences`.
- The MVP has no backend, cloud sync, Firebase, Supabase, or AI API integration.

## Version And Build

- App version: `0.1.0+1`.
- Android display name: `CosmeCheck`.
- iOS display name: `CosmeCheck`.
- Android application ID remains `com.example.cosmecheck` for the prototype.
- iOS bundle identifier remains controlled by `$(PRODUCT_BUNDLE_IDENTIFIER)`.
- MVP icon and splash assets are generated locally from simple teal/blue scanner-style assets.

## Build And Verification

```powershell
cd E:\CosmeCheck\CosmeCheck\stitch_cosmecheck_skincare_ui_showcase
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
flutter build apk --release
```

Debug APK output:

```text
E:\CosmeCheck\CosmeCheck\stitch_cosmecheck_skincare_ui_showcase\build\app\outputs\flutter-apk\app-debug.apk
```

Release APK output, if the local QA release build succeeds:

```text
E:\CosmeCheck\CosmeCheck\stitch_cosmecheck_skincare_ui_showcase\build\app\outputs\flutter-apk\app-release.apk
```

The current Android release build config uses debug signing for local MVP QA only. A production release needs a private keystore and signing configuration outside this repository.

## Manual Android QA Checklist

- เปิดแอพได้
- Camera OCR: ถ่ายรูปฉลากแล้วเข้า Confirm Ingredients
- Gallery OCR: เลือกรูปจากเครื่องแล้วเข้า Confirm Ingredients
- Confirm Ingredients: known ingredients แสดงถูก
- Confirm Ingredients: unknown ingredients แสดงถูก
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
- Ingredient Search ค้นหาได้ทั้งชื่ออังกฤษ ไทย INCI alias
- Ingredient Detail เปิดข้อมูลจาก database 100 ตัวได้
- Fragrance / Parfum alias ทำงาน
- Alcohol Denat. ไม่ปนกับ Cetearyl/Cetyl/Stearyl Alcohol
- Mock fallback ยังใช้งานได้
- ภาษาไทยไม่ล้นจอ
- ไม่มีชื่อแอพเก่าใน UI

## Known Limitations

- No backend.
- No cloud sync.
- No Firebase or Supabase.
- No AI API.
- No live camera preview or real-time OCR.
- OCR quality still depends on image clarity, lighting, and physical-device behavior.
- Unknown ingredients are carried through neutrally until reviewed or added to the local database.
- Physical Android device QA is still required before broader release.
