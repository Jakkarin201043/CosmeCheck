import 'package:cosmecheck/app.dart';
import 'package:cosmecheck/data/ingredient_database.dart';
import 'package:cosmecheck/models/ingredient_confirmation_draft.dart';
import 'package:cosmecheck/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
    final state = AppState();
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const CosmeCheckApp()),
    );
    await tester.pumpAndSettle();

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
    await pumpCosmeCheck(tester, size: const Size(393, 873));

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
    expect(find.byKey(const Key('confirmedIngredientList')), findsOneWidget);
    expect(find.text('Glycerin'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('removeIngredient-0')));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('addIngredientField')),
      'Fragrance',
    );
    await tester.tap(find.byKey(const Key('addIngredientButton')));
    await tester.pump();

    expect(find.text('Fragrance'), findsWidgets);

    await tester.tap(
      find.byKey(const Key('analyzeConfirmedIngredientsButton')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Fragrance'), findsWidgets);
    expect(find.textContaining('/ 10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
