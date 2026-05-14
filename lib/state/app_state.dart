import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/ingredient_database.dart';
import '../data/ingredient_repository.dart';
import '../data/mock_scan_history.dart';
import '../models/ingredient.dart';
import '../models/scan_result.dart';
import '../models/user_allergy_profile.dart';
import '../services/ingredient_parser.dart';
import '../services/mock_ocr_service.dart';
import '../services/risk_analyzer.dart';

class AppState extends ChangeNotifier {
  static const allAllergens = [
    'Fragrance',
    'Alcohol Denat.',
    'Essential Oil',
    'Lanolin',
    'Paraben',
  ];

  static const skinTypes = ['ผิวแห้ง', 'ผิวมัน', 'ผิวผสม', 'ผิวแพ้ง่าย'];

  Set<String> _allergens = {'Fragrance', 'Alcohol Denat.', 'Paraben'};
  String _skinType = 'ผิวแพ้ง่าย';
  DateTime _updatedAt = DateTime.now();
  List<Ingredient> _ingredients = IngredientDatabase.ingredients;
  final IngredientRepository _ingredientRepository =
      const IngredientRepository();
  final List<ScanResult> _savedProducts = [...MockScanHistory.items.take(2)];

  List<String> get allergens => _allergens.toList();
  String get skinType => _skinType;
  DateTime get updatedAt => _updatedAt;
  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  List<ScanResult> get savedProducts => List.unmodifiable(_savedProducts);

  UserAllergyProfile get profile => UserAllergyProfile(
    allergens: allergens,
    skinType: _skinType,
    updatedAt: _updatedAt,
  );

  Future<void> load() async {
    _ingredients = await _ingredientRepository.loadIngredients();
    final prefs = await SharedPreferences.getInstance();
    _allergens = (prefs.getStringList('allergens') ?? _allergens.toList())
        .toSet();
    _skinType = prefs.getString('skinType') ?? _skinType;
    final updated = prefs.getString('updatedAt');
    _updatedAt = updated == null ? _updatedAt : DateTime.parse(updated);
  }

  void setAllergen(String allergen, bool enabled) {
    if (enabled) {
      _allergens.add(allergen);
    } else {
      _allergens.remove(allergen);
    }
    notifyListeners();
  }

  void setSkinType(String skinType) {
    _skinType = skinType;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    _updatedAt = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('allergens', allergens);
    await prefs.setString('skinType', _skinType);
    await prefs.setString('updatedAt', _updatedAt.toIso8601String());
    notifyListeners();
  }

  ScanResult analyzeMockOcr() {
    final ocrText = MockOcrService.recognizeIngredientText();
    return analyzeOcrText(ocrText, productName: 'เซรั่มไฮยา');
  }

  ScanResult analyzeOcrText(
    String ocrText, {
    String productName = 'ผลิตภัณฑ์จากรูปภาพ',
  }) {
    return analyzeConfirmedIngredients(
      rawOcrText: ocrText,
      ingredients: IngredientParser.parse(ocrText),
      productName: productName,
    );
  }

  ScanResult analyzeConfirmedIngredients({
    required String rawOcrText,
    required List<String> ingredients,
    String productName =
        'เธเธฅเธดเธ•เธ เธฑเธ“เธ‘เนเธเธฒเธเธฃเธนเธเธ เธฒเธ',
  }) {
    return RiskAnalyzer.analyze(
      ocrText: rawOcrText,
      detectedIngredients: ingredients,
      allergens: allergens,
      skinType: _skinType,
      ingredientDatabase: _ingredients,
      productName: productName,
    );
  }

  Ingredient findIngredientById(String id) {
    return _ingredients.firstWhere(
      (ingredient) => ingredient.id == id,
      orElse: () => IngredientDatabase.findById(id),
    );
  }

  void saveProduct(ScanResult result) {
    if (_savedProducts.every((item) => item.id != result.id)) {
      _savedProducts.insert(0, result);
      notifyListeners();
    }
  }
}
