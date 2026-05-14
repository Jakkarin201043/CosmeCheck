import '../models/ingredient.dart';

class IngredientParser {
  static final RegExp _labelPrefixPattern = RegExp(
    r'\b(active\s+ingredients?|ingredients?|inci)\b\s*[:：\-]?',
    caseSensitive: false,
  );

  static final RegExp _thaiLabelPrefixPattern = RegExp(r'ส่วนผสม\s*[:：\-]?');

  static List<String> parse(String rawText) {
    final sanitized = rawText
        .replaceAll(_labelPrefixPattern, ',')
        .replaceAll(_thaiLabelPrefixPattern, ',')
        .replaceAll(RegExp(r'[\u2022\u2023\u25E6\u2043\u2219●▪◦·]+'), ',')
        .replaceAll(RegExp(r'\s*/\s*'), ',')
        .replaceAll(RegExp(r'[,;\n\r]+'), ',');

    return sanitized
        .split(',')
        .map(_trimIngredientToken)
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<Ingredient> matchKnownIngredients({
    required List<String> detectedIngredients,
    required List<Ingredient> database,
  }) {
    final detectedCandidates = detectedIngredients
        .expand(normalizedCandidates)
        .where((item) => item.isNotEmpty)
        .toSet();

    return database.where((ingredient) {
      return _ingredientMatchTerms(ingredient).any((term) {
        final termCandidates = normalizedCandidates(term);
        return termCandidates.any(
          (normalizedTerm) => detectedCandidates.any(
            (detected) => _isIngredientMatch(
              detected: detected,
              normalizedTerm: normalizedTerm,
            ),
          ),
        );
      });
    }).toList();
  }

  static bool matchesAnyTerm(String value, Ingredient ingredient) {
    final valueCandidates = normalizedCandidates(value);
    return _ingredientMatchTerms(ingredient).any(
      (term) => normalizedCandidates(
        term,
      ).any((termCandidate) => valueCandidates.contains(termCandidate)),
    );
  }

  static String normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9ก-๙]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static Set<String> normalizedCandidates(String value) {
    final base = normalize(value);
    if (base.isEmpty) {
      return const {};
    }

    final digitFixed = normalize(
      value.replaceAll('0', 'o').replaceAll('1', 'l').replaceAll('5', 's'),
    );
    final ocrFixed = digitFixed
        .replaceAll('rn', 'm')
        .replaceAll('parfurn', 'parfum')
        .replaceAll('glycerln', 'glycerin')
        .replaceAll('niacinarnide', 'niacinamide')
        .replaceAll('fragranee', 'fragrance')
        .replaceAll('alcohoi', 'alcohol');

    return {base, digitFixed, ocrFixed};
  }

  static String _trimIngredientToken(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'^[\s\-–—:;,.()[\]{}]+'), '')
        .replaceAll(RegExp(r'[\s\-–—:;,.()[\]{}]+$'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static List<String> _ingredientMatchTerms(Ingredient ingredient) {
    final terms = [
      ingredient.id,
      ingredient.name,
      ingredient.inciName,
      ingredient.thaiName,
      ...ingredient.aliases,
    ];

    final normalizedName = normalize(ingredient.name);
    if (ingredient.id == 'alcohol-denat' ||
        ingredient.id == 'alcohol_denat' ||
        normalizedName == 'alcohol denat') {
      return terms
          .where((term) => normalize(term) != 'alcohol')
          .toList(growable: false);
    }

    return terms;
  }

  static bool _isIngredientMatch({
    required String detected,
    required String normalizedTerm,
  }) {
    if (detected == normalizedTerm) {
      return true;
    }

    if (!detected.startsWith('$normalizedTerm ')) {
      return false;
    }

    final remainder = detected.substring(normalizedTerm.length).trim();
    return RegExp(r'^[0-9.]+$').hasMatch(remainder);
  }
}
