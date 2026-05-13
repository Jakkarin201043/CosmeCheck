class IngredientConfirmationDraft {
  const IngredientConfirmationDraft({
    required this.rawOcrText,
    required this.parsedIngredients,
    required this.productName,
  });

  final String rawOcrText;
  final List<String> parsedIngredients;
  final String productName;
}
