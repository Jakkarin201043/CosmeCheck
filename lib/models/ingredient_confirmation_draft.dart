import '../services/ingredient_parser.dart';
import 'ingredient.dart';

class IngredientConfirmationDraft {
  const IngredientConfirmationDraft({
    required this.rawOcrText,
    required this.productName,
    this.parsedIngredients = const [],
    this.knownIngredients = const [],
    this.unknownIngredientNames = const [],
    this.source = 'ocr',
  });

  factory IngredientConfirmationDraft.fromOcrText({
    required String rawOcrText,
    required List<Ingredient> database,
    required String productName,
    String source = 'ocr',
  }) {
    final result = IngredientParser.parseForConfirmation(
      rawText: rawOcrText,
      database: database,
    );

    return IngredientConfirmationDraft(
      rawOcrText: rawOcrText,
      productName: productName,
      parsedIngredients: result.rawIngredientNames,
      knownIngredients: result.knownIngredients,
      unknownIngredientNames: result.unknownIngredientNames,
      source: source,
    );
  }

  final String rawOcrText;
  final List<String> parsedIngredients;
  final List<Ingredient> knownIngredients;
  final List<String> unknownIngredientNames;
  final String productName;
  final String source;
}
