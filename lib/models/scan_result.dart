class ScanResult {
  const ScanResult({
    required this.id,
    required this.productName,
    required this.ocrText,
    required this.detectedIngredients,
    required this.matchedAllergens,
    required this.helpfulIngredients,
    required this.cautionIngredients,
    required this.unknownIngredients,
    required this.riskScore,
    required this.status,
    required this.createdAt,
    this.source = 'scan',
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] as String,
      productName: json['productName'] as String,
      ocrText: json['ocrText'] as String? ?? '',
      detectedIngredients: _stringList(json['detectedIngredients']),
      matchedAllergens: _stringList(json['matchedAllergens']),
      helpfulIngredients: _stringList(json['helpfulIngredients']),
      cautionIngredients: _stringList(json['cautionIngredients']),
      unknownIngredients: _stringList(json['unknownIngredients']),
      riskScore: (json['riskScore'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      source: json['source'] as String? ?? 'scan',
    );
  }

  final String id;
  final String productName;
  final String ocrText;
  final List<String> detectedIngredients;
  final List<String> matchedAllergens;
  final List<String> helpfulIngredients;
  final List<String> cautionIngredients;
  final List<String> unknownIngredients;
  final double riskScore;
  final String status;
  final DateTime createdAt;
  final String source;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'ocrText': ocrText,
      'detectedIngredients': detectedIngredients,
      'matchedAllergens': matchedAllergens,
      'helpfulIngredients': helpfulIngredients,
      'cautionIngredients': cautionIngredients,
      'unknownIngredients': unknownIngredients,
      'riskScore': riskScore,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'source': source,
    };
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList(growable: false);
    }
    return const [];
  }
}
