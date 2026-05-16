import 'dart:convert';

import 'package:cosmecheck/data/ingredient_database.dart';
import 'package:cosmecheck/data/ingredient_repository.dart';
import 'package:cosmecheck/models/ingredient.dart';
import 'package:cosmecheck/models/scan_result.dart';
import 'package:cosmecheck/services/ingredient_parser.dart';
import 'package:cosmecheck/services/risk_analyzer.dart';
import 'package:cosmecheck/state/app_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ScanResult sampleResult({
    String id = 'scan-test-001',
    String productName = 'Local QA',
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
      source: 'camera',
    );
  }

  Future<List<Ingredient>> loadJsonIngredients() {
    TestWidgetsFlutterBinding.ensureInitialized();
    return const IngredientRepository().loadIngredients();
  }

  test('ingredient JSON asset parses as 100 complete unique records', () async {
    final rawJson = await rootBundle.loadString('assets/data/ingredients.json');
    final decoded = jsonDecode(rawJson);

    expect(decoded, isA<List<dynamic>>());

    final records = decoded as List<dynamic>;
    const requiredFields = {
      'id',
      'name',
      'thaiName',
      'inciName',
      'aliases',
      'category',
      'tag',
      'riskLevel',
      'shortDescription',
      'whatIsIt',
      'benefits',
      'cautions',
      'suitableFor',
      'avoidIf',
      'commonIn',
      'mythVsFact',
      'references',
    };

    expect(records, hasLength(100));
    expect(
      records.whereType<Map<String, dynamic>>().every(
        (record) => record.keys.toSet().containsAll(requiredFields),
      ),
      isTrue,
    );
    expect(
      records.map((record) => (record as Map<String, dynamic>)['id']).toSet(),
      hasLength(100),
    );
    expect(
      rawJson,
      isNot(
        anyOf([
          contains('รักษาสิว'),
          contains('รักษาฝ้า'),
          contains('รักษาโรค'),
          contains('วินิจฉัย'),
          contains('diagnose'),
          contains('treat disease'),
          contains('cure'),
          contains('prevent disease'),
          contains('100% safe'),
          contains('100% dangerous'),
          contains('ปลอดภัย 100'),
          contains('อันตราย 100'),
        ]),
      ),
    );
  });

  test('ingredient repository loads all 100 JSON ingredients', () async {
    final ingredients = await loadJsonIngredients();

    expect(ingredients, hasLength(100));
    expect(ingredients.map((item) => item.id), contains('fragrance_parfum'));
    expect(ingredients.map((item) => item.id), contains('cetearyl_alcohol'));
    expect(ingredients.map((item) => item.id), contains('bakuchiol'));
    expect(ingredients.every((item) => item.toJson().isNotEmpty), isTrue);
  });

  test(
    'scan result serializes and restores unknown ingredients and source',
    () {
      final result = sampleResult();
      final restored = ScanResult.fromJson(result.toJson());

      expect(restored.id, result.id);
      expect(restored.productName, result.productName);
      expect(restored.detectedIngredients, result.detectedIngredients);
      expect(restored.unknownIngredients, result.unknownIngredients);
      expect(restored.riskScore, result.riskScore);
      expect(restored.status, result.status);
      expect(restored.createdAt, result.createdAt);
      expect(restored.source, 'camera');
    },
  );

  test('ingredient repository searches JSON aliases', () async {
    final ingredients = await loadJsonIngredients();
    final results = IngredientRepository.search(ingredients, 'Vitamin B3');

    expect(results.map((item) => item.name), contains('Niacinamide'));
  });

  test(
    'ingredient repository searches name, Thai name, INCI, and aliases',
    () async {
      final ingredients = await loadJsonIngredients();
      final bakuchiol = ingredients.firstWhere(
        (item) => item.id == 'bakuchiol',
      );
      final peptide = ingredients.firstWhere(
        (item) => item.id == 'peptide_complex',
      );
      final dipropyleneGlycol = ingredients.firstWhere(
        (item) => item.id == 'dipropylene_glycol',
      );

      expect(
        IngredientRepository.search(
          ingredients,
          bakuchiol.name,
        ).map((item) => item.id),
        contains('bakuchiol'),
      );
      expect(
        IngredientRepository.search(
          ingredients,
          bakuchiol.thaiName,
        ).map((item) => item.id),
        contains('bakuchiol'),
      );
      expect(
        IngredientRepository.search(
          ingredients,
          dipropyleneGlycol.inciName,
        ).map((item) => item.id),
        contains('dipropylene_glycol'),
      );
      expect(
        IngredientRepository.search(
          ingredients,
          peptide.aliases.first,
        ).map((item) => item.id),
        contains('peptide_complex'),
      );
    },
  );

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
    expect(
      ingredients
          .where(
            (item) =>
                IngredientParser.normalize(item.name).contains('fragrance') ||
                IngredientParser.normalize(item.name).contains('parfum'),
          )
          .map((item) => item.id),
      ['fragrance_parfum'],
    );
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
      expect(
        ingredients
            .firstWhere((item) => item.id == 'cetearyl_alcohol')
            .riskLevel,
        'low',
      );
      expect(
        ingredients.firstWhere((item) => item.id == 'cetyl_alcohol').riskLevel,
        'low',
      );
      expect(
        ingredients
            .firstWhere((item) => item.id == 'stearyl_alcohol')
            .riskLevel,
        'low',
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
    'parser separates OCR ingredients into known records and unknown names',
    () async {
      final ingredients = await loadJsonIngredients();
      final result = IngredientParser.parseForConfirmation(
        rawText:
            'Ingredients: Water, Glycerin, Niacinamide, Caprylyl Glycol, Fragrance, Mystery Leaf Extract',
        database: ingredients,
      );

      expect(
        result.knownIngredients.map((item) => item.name),
        containsAll([
          'Glycerin',
          'Niacinamide',
          'Caprylyl Glycol',
          'Fragrance / Parfum',
        ]),
      );
      expect(
        result.unknownIngredientNames,
        containsAll(['Water', 'Mystery Leaf Extract']),
      );
      expect(result.unknownIngredientNames, hasLength(2));
    },
  );

  test('unknown ingredients do not change risk score by default', () async {
    final ingredients = await loadJsonIngredients();

    final knownOnly = RiskAnalyzer.analyze(
      ocrText: 'Glycerin, Niacinamide',
      detectedIngredients: const ['Glycerin', 'Niacinamide'],
      allergens: const [],
      skinType: 'ผิวผสม',
      ingredientDatabase: ingredients,
    );
    final withUnknown = RiskAnalyzer.analyze(
      ocrText: 'Glycerin, Niacinamide, Mystery Leaf Extract',
      detectedIngredients: const [
        'Glycerin',
        'Niacinamide',
        'Mystery Leaf Extract',
      ],
      allergens: const [],
      skinType: 'ผิวผสม',
      ingredientDatabase: ingredients,
    );

    expect(withUnknown.unknownIngredients, contains('Mystery Leaf Extract'));
    expect(withUnknown.riskScore, knownOnly.riskScore);
    expect(withUnknown.cautionIngredients, knownOnly.cautionIngredients);
    expect(withUnknown.matchedAllergens, knownOnly.matchedAllergens);
  });

  test('unknown ingredients still work with 100 item database', () async {
    final ingredients = await loadJsonIngredients();
    final result = IngredientParser.parseForConfirmation(
      rawText: 'Ingredients: Bakuchiol, Mystery Cloud Extract',
      database: ingredients,
    );

    expect(
      result.knownIngredients.map((item) => item.id),
      contains('bakuchiol'),
    );
    expect(result.unknownIngredientNames, contains('Mystery Cloud Extract'));

    final analysis = RiskAnalyzer.analyze(
      ocrText: 'Bakuchiol, Mystery Cloud Extract',
      detectedIngredients: result.confirmedIngredientNames,
      allergens: const [],
      skinType: 'เธเธดเธงเธเธชเธก',
      ingredientDatabase: ingredients,
    );

    expect(analysis.helpfulIngredients, contains('Bakuchiol'));
    expect(analysis.unknownIngredients, contains('Mystery Cloud Extract'));
    expect(
      analysis.cautionIngredients,
      isNot(contains('Mystery Cloud Extract')),
    );
  });

  test('app state saves and loads local scan history', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    await state.addScanHistory(sampleResult(productName: 'History QA'));

    final restored = AppState();
    await restored.load();

    expect(restored.scanHistory, hasLength(1));
    expect(restored.scanHistory.first.productName, 'History QA');
    expect(
      restored.scanHistory.first.unknownIngredients,
      contains('Mystery Leaf Extract'),
    );
    expect(restored.scanHistory.first.source, 'camera');
  });

  test('app state persists saved products and removes saved product', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    await state.saveProduct(
      sampleResult(id: 'saved-001', productName: 'Saved QA'),
    );

    final restored = AppState();
    await restored.load();
    expect(restored.savedProducts, hasLength(1));
    expect(restored.savedProducts.first.productName, 'Saved QA');

    await restored.removeSavedProduct('saved-001');

    final afterRemove = AppState();
    await afterRemove.load();
    expect(afterRemove.savedProducts, isEmpty);
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
