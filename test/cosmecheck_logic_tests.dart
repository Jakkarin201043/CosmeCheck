import 'package:cosmecheck/data/ingredient_database.dart';
import 'package:cosmecheck/data/ingredient_repository.dart';
import 'package:cosmecheck/models/ingredient.dart';
import 'package:cosmecheck/services/ingredient_parser.dart';
import 'package:cosmecheck/services/risk_analyzer.dart';
import 'package:cosmecheck/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<List<Ingredient>> loadJsonIngredients() {
    TestWidgetsFlutterBinding.ensureInitialized();
    return const IngredientRepository().loadIngredients();
  }

  test('ingredient repository loads all 30 JSON ingredients', () async {
    final ingredients = await loadJsonIngredients();

    expect(ingredients, hasLength(30));
    expect(ingredients.map((item) => item.id), contains('fragrance_parfum'));
    expect(ingredients.map((item) => item.id), contains('cetearyl_alcohol'));
    expect(ingredients.every((item) => item.toJson().isNotEmpty), isTrue);
  });

  test('ingredient repository searches JSON aliases', () async {
    final ingredients = await loadJsonIngredients();
    final results = IngredientRepository.search(ingredients, 'Vitamin B3');

    expect(results.map((item) => item.name), contains('Niacinamide'));
  });

  test('ingredient repository maps Fragrance and Parfum searches', () async {
    final ingredients = await loadJsonIngredients();
    final fragranceResults = IngredientRepository.search(
      ingredients,
      'Fragrance',
    );
    final parfumResults = IngredientRepository.search(ingredients, 'Parfum');

    expect(
      fragranceResults.map((item) => item.id),
      contains('fragrance_parfum'),
    );
    expect(parfumResults.map((item) => item.id), contains('fragrance_parfum'));
  });

  test(
    'matcher separates Alcohol Denat from Cetearyl Alcohol in JSON database',
    () async {
      final ingredients = await loadJsonIngredients();

      final denatMatch = IngredientParser.matchKnownIngredients(
        detectedIngredients: const ['Alcohol Denat.'],
        database: ingredients,
      );
      final cetearylMatch = IngredientParser.matchKnownIngredients(
        detectedIngredients: const ['Cetearyl Alcohol'],
        database: ingredients,
      );
      final genericAlcoholMatch = IngredientParser.matchKnownIngredients(
        detectedIngredients: const ['Alcohol'],
        database: ingredients,
      );

      expect(denatMatch.map((item) => item.id), contains('alcohol_denat'));
      expect(
        denatMatch.map((item) => item.id),
        isNot(contains('cetearyl_alcohol')),
      );
      expect(
        cetearylMatch.map((item) => item.id),
        contains('cetearyl_alcohol'),
      );
      expect(
        cetearylMatch.map((item) => item.id),
        isNot(contains('alcohol_denat')),
      );
      expect(
        genericAlcoholMatch.map((item) => item.id),
        isNot(contains('alcohol_denat')),
      );
    },
  );

  test('ingredient search terms include aliases', () {
    final fragrance = IngredientDatabase.findById('fragrance');

    expect(
      fragrance.searchableTerms.any(
        (term) => IngredientParser.normalize(term).contains('parfum'),
      ),
      isTrue,
    );
  });

  test('risk analyzer matches aliases and sensitive skin rules', () {
    final detected = IngredientParser.parse(
      'Water, Glycerin, Parfum, Alcohol Denat., Panthenol',
    );
    final result = RiskAnalyzer.analyze(
      ocrText: detected.join(', '),
      detectedIngredients: detected,
      allergens: const ['Fragrance'],
      skinType: 'ผิวแพ้ง่าย',
      ingredientDatabase: IngredientDatabase.ingredients,
    );

    expect(result.matchedAllergens, contains('Fragrance'));
    expect(result.helpfulIngredients, contains('Glycerin'));
    expect(result.helpfulIngredients, contains('Panthenol'));
    expect(result.cautionIngredients, contains('Fragrance'));
    expect(['ควรระวัง', 'ไม่แนะนำสำหรับโปรไฟล์นี้'], contains(result.status));
  });

  test('parser handles OCR text with line breaks', () {
    final parsed = IngredientParser.parse('Water\nGlycerin\nNiacinamide');

    expect(parsed, containsAll(['Water', 'Glycerin', 'Niacinamide']));
  });

  test('parser removes Ingredients prefix', () {
    final parsed = IngredientParser.parse(
      'Ingredients: Water, Glycerin, Fragrance',
    );

    expect(parsed, isNot(contains('Ingredients: Water')));
    expect(parsed, containsAll(['Water', 'Glycerin', 'Fragrance']));
  });

  test('parser and matcher handle mixed case ingredient text', () {
    final parsed = IngredientParser.parse('ingredients: gLyCeRiN; NIACINAMIDE');
    final known = IngredientParser.matchKnownIngredients(
      detectedIngredients: parsed,
      database: IngredientDatabase.ingredients,
    );

    expect(
      known.map((item) => item.name),
      containsAll(['Glycerin', 'Niacinamide']),
    );
  });

  test('parser handles bullets slashes and semicolons', () {
    final parsed = IngredientParser.parse(
      'INCI: Water • Glycerin / Parfum; Alcohol Denat.',
    );

    expect(
      parsed,
      containsAll(['Water', 'Glycerin', 'Parfum', 'Alcohol Denat']),
    );
  });

  test('matcher maps Parfum alias to Fragrance', () {
    final parsed = IngredientParser.parse('Aqua, Parfum');
    final known = IngredientParser.matchKnownIngredients(
      detectedIngredients: parsed,
      database: IngredientDatabase.ingredients,
    );

    expect(known.map((item) => item.name), contains('Fragrance'));
  });

  test('matcher does not map generic Alcohol to Alcohol Denat', () {
    final known = IngredientParser.matchKnownIngredients(
      detectedIngredients: const ['Alcohol'],
      database: IngredientDatabase.ingredients,
    );

    expect(known.map((item) => item.id), isNot(contains('alcohol-denat')));
  });

  test('matcher still maps explicit Alcohol Denat aliases', () {
    final known = IngredientParser.matchKnownIngredients(
      detectedIngredients: const ['SD Alcohol'],
      database: IngredientDatabase.ingredients,
    );

    expect(known.map((item) => item.id), contains('alcohol-denat'));
  });

  test('parser returns no ingredients for empty OCR text', () {
    expect(IngredientParser.parse('   \n  '), isEmpty);
  });

  test('matcher tolerates common OCR mistakes', () {
    final parsed = IngredientParser.parse('Water, Glycerln, Parfurn');
    final known = IngredientParser.matchKnownIngredients(
      detectedIngredients: parsed,
      database: IngredientDatabase.ingredients,
    );

    expect(
      known.map((item) => item.name),
      containsAll(['Glycerin', 'Fragrance']),
    );
  });

  test(
    'app state analyzes arbitrary OCR text with existing parser and risk flow',
    () {
      final state = AppState()
        ..setAllergen('Fragrance', true)
        ..setAllergen('Alcohol Denat.', true);

      final result = state.analyzeOcrText(
        'Ingredients: Water, Glycerin, Fragrance, Alcohol Denat., Panthenol',
      );

      expect(result.ocrText, contains('Ingredients:'));
      expect(result.detectedIngredients, contains('Glycerin'));
      expect(result.matchedAllergens, contains('Fragrance'));
      expect(result.matchedAllergens, contains('Alcohol Denat.'));
      expect(result.helpfulIngredients, contains('Panthenol'));
    },
  );

  test('app state analyzes user-confirmed ingredient list', () {
    final state = AppState()..setAllergen('Fragrance', true);

    final result = state.analyzeConfirmedIngredients(
      rawOcrText: 'Ingredients: Water, Glycerin',
      ingredients: const ['Glycerin', 'Fragrance'],
      productName: 'Confirmed QA',
    );

    expect(result.ocrText, contains('Ingredients:'));
    expect(result.productName, 'Confirmed QA');
    expect(result.detectedIngredients, contains('Fragrance'));
    expect(result.detectedIngredients, isNot(contains('Water')));
    expect(result.matchedAllergens, contains('Fragrance'));
  });

  test(
    'risk analyzer reports unknown ingredients without raising cautions',
    () {
      final result = RiskAnalyzer.analyze(
        ocrText: 'Water, Mystery Root Extract, Alcohol',
        detectedIngredients: const ['Water', 'Mystery Root Extract', 'Alcohol'],
        allergens: const ['Alcohol Denat.'],
        skinType: 'เธเธดเธงเนเธเนเธเนเธฒเธข',
        ingredientDatabase: IngredientDatabase.ingredients,
      );

      expect(result.unknownIngredients, contains('Mystery Root Extract'));
      expect(result.unknownIngredients, contains('Alcohol'));
      expect(result.matchedAllergens, isNot(contains('Alcohol Denat.')));
      expect(result.cautionIngredients, isNot(contains('Alcohol Denat.')));
    },
  );

  test('allergy profile persists locally', () async {
    SharedPreferences.setMockInitialValues({});

    final state = AppState();
    await state.load();
    state.setAllergen('Lanolin', true);
    state.setSkinType('ผิวแห้ง');
    await state.saveProfile();

    final restored = AppState();
    await restored.load();

    expect(restored.allergens, contains('Lanolin'));
    expect(restored.skinType, 'ผิวแห้ง');
  });
}
