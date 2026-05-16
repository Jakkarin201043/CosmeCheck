class MockOcrService {
  static const mockIngredientText =
      'Water, Glycerin, Niacinamide, Alcohol Denat., Butylene Glycol, Propanediol, Panthenol, Allantoin, Sodium Hyaluronate, Fragrance, Disodium EDTA';

  static String recognizeIngredientText() {
    // Preserved as the offline QA fallback while camera/gallery OCR use ML Kit.
    return mockIngredientText;
  }
}
