import 'package:cosmecheck/app.dart';
import 'package:cosmecheck/data/ingredient_database.dart';
import 'package:cosmecheck/models/ingredient_confirmation_draft.dart';
import 'package:cosmecheck/models/scan_result.dart';
import 'package:cosmecheck/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ScanResult sampleResult({
    String id = 'widget-scan-001',
    String productName = 'Widget QA',
  }) {
    return ScanResult(
      id: id,
      productName: productName,
      ocrText: 'Ingredients: Glycerin, Mystery Leaf Extract',
      detectedIngredients: const ['Glycerin', 'Mystery Leaf Extract'],
      matchedAllergens: const [],
      helpfulIngredients: const ['Glycerin'],
      cautionIngredients: const [],
      unknownIngredients: const ['Mystery Leaf Extract'],
      riskScore: 1.3,
      status: 'ปลอดภัยเบื้องต้น',
      createdAt: DateTime(2026, 5, 14, 12, 30),
      source: 'gallery',
    );
  }

  Future<AppState> pumpCosmeCheck(
    WidgetTester tester, {
    Size size = const Size(393, 873),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
    CosmeCheckApp.resetRouterForTesting();
    final state = AppState();
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const CosmeCheckApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    return state;
  }

  testWidgets('CosmeCheck opens onboarding screen', (tester) async {
    await pumpCosmeCheck(tester);

    expect(find.text('CosmeCheck'), findsOneWidget);
  });

  testWidgets('primary app routes fit small phone viewports', (tester) async {
    const deviceSizes = [
      Size(360, 640),
      Size(393, 873),
      Size(375, 667),
      Size(430, 932),
    ];

    for (final size in deviceSizes) {
      await pumpCosmeCheck(tester, size: size);

      for (final route in [
        '/onboarding',
        '/login',
        '/home',
        '/ingredients',
        '/scan',
        '/saved',
        '/profile',
        '/allergy-profile',
        '/ingredient-detail?id=${IngredientDatabase.ingredients.first.id}',
        '/patch-test',
        '/education',
        '/history',
      ]) {
        CosmeCheckApp.router.go(route);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(
          tester.takeException(),
          isNull,
          reason: 'route $route overflowed at ${size.width}x${size.height}',
        );
      }
    }
  });

  testWidgets('ingredient search empty state is reachable on small screens', (
    tester,
  ) async {
    await pumpCosmeCheck(tester, size: const Size(360, 640));

    CosmeCheckApp.router.go('/ingredients');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.enterText(find.byType(TextField), 'not-a-real-ingredient');
    await tester.pump();

    expect(find.byIcon(Icons.search_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ingredient search finds a 100 item database addition', (
    tester,
  ) async {
    final state = await pumpCosmeCheck(tester, size: const Size(393, 873));
    expect(state.ingredients, hasLength(100));

    CosmeCheckApp.router.go('/ingredients');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.enterText(find.byType(TextField), 'Bakuchiol');
    await tester.pump();

    expect(find.text('Bakuchiol'), findsWidgets);
    expect(find.textContaining('Bakuchiol Extract'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ingredient detail opens a 100 item database addition', (
    tester,
  ) async {
    final state = await pumpCosmeCheck(tester, size: const Size(393, 873));
    expect(state.ingredients.map((item) => item.id), contains('bakuchiol'));

    CosmeCheckApp.router.go('/ingredient-detail?id=bakuchiol');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Bakuchiol'), findsOneWidget);
    expect(find.text('Bakuchiol Extract'), findsOneWidget);
    expect(find.textContaining('Anti-aging'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'history and saved screens show empty states without local data',
    (tester) async {
      await pumpCosmeCheck(tester, size: const Size(393, 873));

      CosmeCheckApp.router.go('/history');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('ยังไม่มีประวัติการสแกน'), findsOneWidget);

      CosmeCheckApp.router.go('/saved');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('ยังไม่มีรายการที่บันทึกไว้'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('mock scan still opens result with expected sections', (
    tester,
  ) async {
    final state = await pumpCosmeCheck(tester, size: const Size(375, 667));
    state.setAllergen('Fragrance', true);
    state.setAllergen('Alcohol Denat.', true);
    state.setAllergen('Paraben', true);

    CosmeCheckApp.router.go('/scan');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('cameraOcrButton')), findsOneWidget);
    expect(find.byKey(const Key('galleryOcrButton')), findsOneWidget);
    expect(find.byKey(const Key('mockScanButton')), findsOneWidget);
    expect(find.text('ถ่ายรูปฉลาก'), findsOneWidget);
    expect(find.text('เลือกรูปจากเครื่อง'), findsOneWidget);
    expect(find.text('ทดสอบด้วยข้อมูลจำลอง'), findsOneWidget);

    await tester.tap(find.byKey(const Key('mockScanButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Alcohol Denat.'), findsWidgets);
    expect(find.textContaining('Fragrance'), findsWidgets);
    expect(find.textContaining('Glycerin'), findsWidgets);
    expect(find.textContaining('/ 10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirm ingredients supports review add remove and analyze', (
    tester,
  ) async {
    final state = await pumpCosmeCheck(tester, size: const Size(393, 873));

    CosmeCheckApp.router.go(
      '/confirm-ingredients',
      extra: const IngredientConfirmationDraft(
        rawOcrText: 'Ingredients: Water, Glycerin',
        parsedIngredients: ['Water', 'Glycerin'],
        productName: 'QA OCR',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('rawOcrTextPreview')), findsOneWidget);
    expect(find.text('พบในฐานข้อมูล'), findsOneWidget);
    expect(find.text('ยังไม่มีในฐานข้อมูล'), findsOneWidget);
    expect(find.byKey(const Key('knownIngredientList')), findsOneWidget);
    expect(find.byKey(const Key('unknownIngredientList')), findsOneWidget);
    expect(find.text('Glycerin'), findsWidgets);
    expect(find.text('Water'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('removeUnknownIngredient-0')));
    await tester.pump();
    expect(find.text('Water'), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('addIngredientField')));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('addIngredientField')),
      'Fragrance',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('Fragrance'), findsWidgets);
    expect(find.byKey(const Key('knownIngredientList')), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('analyzeConfirmedIngredientsButton')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Fragrance'), findsWidgets);
    expect(find.textContaining('/ 10'), findsOneWidget);
    expect(state.scanHistory, hasLength(1));
    expect(state.scanHistory.first.productName, 'QA OCR');
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirm ingredients keeps analyze disabled when list is empty', (
    tester,
  ) async {
    await pumpCosmeCheck(tester, size: const Size(360, 640));

    CosmeCheckApp.router.go('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    CosmeCheckApp.router.go(
      '/confirm-ingredients',
      extra: const IngredientConfirmationDraft(
        rawOcrText: 'Noise only',
        parsedIngredients: [],
        productName: 'Empty QA',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final analyzeButton = tester.widget<FilledButton>(
      find.byKey(const Key('analyzeConfirmedIngredientsButton')),
    );

    expect(analyzeButton.onPressed, isNull);
    expect(find.byKey(const Key('knownIngredientList')), findsNothing);
    expect(find.byKey(const Key('unknownIngredientList')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirm ingredients dedupes and carries unknowns to result', (
    tester,
  ) async {
    await pumpCosmeCheck(tester, size: const Size(393, 873));

    CosmeCheckApp.router.go('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    CosmeCheckApp.router.go(
      '/confirm-ingredients',
      extra: const IngredientConfirmationDraft(
        rawOcrText: 'Ingredients: Glycerin, glycerin, Mystery Root Extract',
        parsedIngredients: ['Glycerin', 'glycerin', 'Mystery Root Extract'],
        productName: 'Unknown QA',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(
      find.byKey(const ValueKey('knownIngredientReview-glycerin')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('unknownIngredientReview-mystery root extract'),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('addIngredientField')));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('addIngredientField')),
      'Glycerin, Mystery Root Extract',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('knownIngredientReview-glycerin')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('unknownIngredientReview-mystery root extract'),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const Key('analyzeConfirmedIngredientsButton')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Mystery Root Extract'), findsWidgets);
    expect(find.byKey(const Key('scanResultUnknownNotice')), findsOneWidget);
    expect(find.textContaining('/ 10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirm ingredients supports manually adding unknown text', (
    tester,
  ) async {
    await pumpCosmeCheck(tester, size: const Size(393, 873));

    CosmeCheckApp.router.go(
      '/confirm-ingredients',
      extra: const IngredientConfirmationDraft(
        rawOcrText: 'Ingredients: Glycerin',
        parsedIngredients: ['Glycerin'],
        productName: 'Manual Unknown QA',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.ensureVisible(find.byKey(const Key('addIngredientField')));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('addIngredientField')),
      'Mystery Leaf Extract',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(
      find.byKey(
        const ValueKey('unknownIngredientReview-mystery leaf extract'),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const Key('analyzeConfirmedIngredientsButton')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Mystery Leaf Extract'), findsWidgets);
    expect(find.byKey(const Key('scanResultUnknownNotice')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scan result save button persists item on saved screen', (
    tester,
  ) async {
    await pumpCosmeCheck(tester, size: const Size(393, 873));

    CosmeCheckApp.router.go('/scan-result', extra: sampleResult());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.tap(find.text('บันทึกผลลัพธ์'));
    await tester.pump();

    CosmeCheckApp.router.go('/saved');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Widget QA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved products screen removes persisted saved item', (
    tester,
  ) async {
    final state = await pumpCosmeCheck(tester, size: const Size(393, 873));
    await state.saveProduct(
      sampleResult(id: 'remove-saved', productName: 'Remove QA'),
    );

    CosmeCheckApp.router.go('/saved');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Remove QA'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('removeSavedProduct-remove-saved')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Remove QA'), findsNothing);
    expect(find.text('ยังไม่มีรายการที่บันทึกไว้'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
