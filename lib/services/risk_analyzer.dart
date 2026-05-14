import '../models/ingredient.dart';
import '../models/scan_result.dart';
import 'ingredient_parser.dart';

class RiskAnalyzer {
  static ScanResult analyze({
    required String ocrText,
    required List<String> detectedIngredients,
    required List<String> allergens,
    required String skinType,
    required List<Ingredient> ingredientDatabase,
    String productName = 'ผลิตภัณฑ์จากการสแกน',
    String source = 'scan',
  }) {
    final knownIngredients = IngredientParser.matchKnownIngredients(
      detectedIngredients: detectedIngredients,
      database: ingredientDatabase,
    );

    final matchedAllergens = _matchedAllergens(
      allergens: allergens,
      detectedIngredients: detectedIngredients,
      knownIngredients: knownIngredients,
    );
    final helpfulIngredients = _helpfulIngredients(
      detectedIngredients: detectedIngredients,
      knownIngredients: knownIngredients,
    );
    final cautionIngredients = _cautionIngredients(knownIngredients);
    final unknownIngredients = _unknownIngredients(
      detectedIngredients: detectedIngredients,
      ingredientDatabase: ingredientDatabase,
    );
    final riskScore = _riskScore(
      matchedAllergens: matchedAllergens,
      knownIngredients: knownIngredients,
      skinType: skinType,
    );

    return ScanResult(
      id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
      productName: productName,
      ocrText: ocrText,
      detectedIngredients: detectedIngredients,
      matchedAllergens: matchedAllergens,
      helpfulIngredients: helpfulIngredients,
      cautionIngredients: cautionIngredients,
      unknownIngredients: unknownIngredients,
      riskScore: riskScore,
      status: _statusForScore(riskScore),
      createdAt: DateTime.now(),
      source: source,
    );
  }

  static List<String> _matchedAllergens({
    required List<String> allergens,
    required List<String> detectedIngredients,
    required List<Ingredient> knownIngredients,
  }) {
    final detected = detectedIngredients
        .map(IngredientParser.normalize)
        .toSet();
    final matches = <String>[];

    for (final allergen in allergens) {
      final normalizedAllergen = IngredientParser.normalize(allergen);
      final directlyDetected = detected.contains(normalizedAllergen);
      final knownMatch = knownIngredients.any(
        (ingredient) => IngredientParser.matchesAnyTerm(allergen, ingredient),
      );
      if ((directlyDetected || knownMatch) && !matches.contains(allergen)) {
        matches.add(allergen);
      }
    }
    return matches;
  }

  static List<String> _helpfulIngredients({
    required List<String> detectedIngredients,
    required List<Ingredient> knownIngredients,
  }) {
    const soothingTerms = {'panthenol', 'allantoin', 'glycerin', 'niacinamide'};

    final helpful = <String>{
      for (final ingredient in knownIngredients)
        if (ingredient.tag == 'ให้ประโยชน์') ingredient.name,
      for (final detected in detectedIngredients)
        if (soothingTerms.contains(IngredientParser.normalize(detected)))
          detected,
    }.toList();

    helpful.sort();
    return helpful;
  }

  static List<String> _cautionIngredients(List<Ingredient> knownIngredients) {
    final caution = knownIngredients
        .where(
          (ingredient) =>
              ingredient.tag == 'ควรระวัง' ||
              ingredient.tag == 'หลีกเลี่ยง' ||
              ingredient.riskLevel == 'medium' ||
              ingredient.riskLevel == 'high',
        )
        .map((ingredient) => ingredient.name)
        .toSet()
        .toList();
    caution.sort();
    return caution;
  }

  static List<String> _unknownIngredients({
    required List<String> detectedIngredients,
    required List<Ingredient> ingredientDatabase,
  }) {
    final seen = <String>{};
    final unknown = <String>[];

    for (final ingredient in detectedIngredients) {
      final normalized = IngredientParser.normalize(ingredient);
      if (normalized.isEmpty || !seen.add(normalized)) {
        continue;
      }

      final knownMatches = IngredientParser.matchKnownIngredients(
        detectedIngredients: [ingredient],
        database: ingredientDatabase,
      );
      if (knownMatches.isEmpty) {
        unknown.add(ingredient);
      }
    }

    return unknown;
  }

  static double _riskScore({
    required List<String> matchedAllergens,
    required List<Ingredient> knownIngredients,
    required String skinType,
  }) {
    var score = 1.0;
    score += matchedAllergens.length * 2.8;

    final sensitiveSkin = skinType == 'ผิวแพ้ง่าย';
    final drySkin = skinType == 'ผิวแห้ง';
    final hasFragrance = knownIngredients.any(
      (item) =>
          item.id == 'fragrance' ||
          item.id == 'fragrance_parfum' ||
          IngredientParser.normalize(item.name).contains('fragrance'),
    );
    final hasAlcoholDenat = knownIngredients.any(
      (item) =>
          item.id == 'alcohol-denat' ||
          item.id == 'alcohol_denat' ||
          IngredientParser.normalize(item.name) == 'alcohol denat',
    );

    if (hasFragrance) {
      score += sensitiveSkin ? 1.4 : 0.5;
    }
    if (hasAlcoholDenat) {
      score += (sensitiveSkin || drySkin) ? 1.2 : 0.5;
    }

    for (final ingredient in knownIngredients) {
      if (ingredient.riskLevel == 'high') {
        score += 0.8;
      } else if (ingredient.riskLevel == 'medium') {
        score += 0.3;
      }
    }

    return score.clamp(0, 10).toDouble();
  }

  static String _statusForScore(double riskScore) {
    if (riskScore >= 7) {
      return 'ไม่แนะนำสำหรับโปรไฟล์นี้';
    }
    if (riskScore >= 4) {
      return 'ควรระวัง';
    }
    return 'ปลอดภัยเบื้องต้น';
  }
}
