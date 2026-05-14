import '../services/ingredient_parser.dart';
import 'ingredient.dart';

class IngredientConfirmationDraft {
  const IngredientConfirmationDraft({
    required this.rawOcrText,
    required this.productName,
    this.parsedIngredients = const [],
    this.knownIngredients = const [],
    this.unknownIngredientNames = const [],
  });

  factory IngredientConfirmationDraft.fromOcrText({
    required String rawOcrText,
    required List<Ingredient> database,
    required String productName,
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
    );
  }

  final String rawOcrText;
  final List<String> parsedIngredients;
  final List<Ingredient> knownIngredients;
  final List<String> unknownIngredientNames;
  final String productName;
}
