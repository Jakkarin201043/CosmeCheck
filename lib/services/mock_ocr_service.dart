class MockOcrService {
  static const mockIngredientText =
      'Water, Glycerin, Niacinamide, Alcohol Denat., Butylene Glycol, Propanediol, Panthenol, Allantoin, Sodium Hyaluronate, Fragrance, Disodium EDTA';

  static String recognizeIngredientText() {
    // TODO: Replace this with a real OCR implementation after the prototype flow is approved.
    return mockIngredientText;
  }
}
