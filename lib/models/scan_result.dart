class ScanResult {
  const ScanResult({
    required this.id,
    required this.productName,
    required this.ocrText,
    required this.detectedIngredients,
    required this.matchedAllergens,
    required this.helpfulIngredients,
    required this.cautionIngredients,
    required this.riskScore,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String productName;
  final String ocrText;
  final List<String> detectedIngredients;
  final List<String> matchedAllergens;
  final List<String> helpfulIngredients;
  final List<String> cautionIngredients;
  final double riskScore;
  final String status;
  final DateTime createdAt;
}
