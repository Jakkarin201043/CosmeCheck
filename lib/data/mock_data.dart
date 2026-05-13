import '../models/ingredient.dart';
import '../models/scan_result.dart';
import '../services/mock_ocr_service.dart';
import 'ingredient_database.dart';
import 'mock_scan_history.dart';

class MockData {
  static const mockOcrText = MockOcrService.mockIngredientText;

  static List<Ingredient> get ingredients => IngredientDatabase.ingredients;

  static ScanResult get mockScanResult => MockScanHistory.items.first;

  static List<ScanResult> get scanHistory => MockScanHistory.items;

  static Ingredient findIngredient(String id) {
    return IngredientDatabase.findById(id);
  }
}
