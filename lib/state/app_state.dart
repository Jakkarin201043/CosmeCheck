import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/ingredient_database.dart';
import '../data/ingredient_repository.dart';
import '../data/local_scan_storage.dart';
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
  final LocalScanStorage _scanStorage = const LocalScanStorage();
  final List<ScanResult> _scanHistory = [];
  final List<ScanResult> _savedProducts = [];

  List<String> get allergens => _allergens.toList();
  String get skinType => _skinType;
  DateTime get updatedAt => _updatedAt;
  List<Ingredient> get ingredients => List.unmodifiable(_ingredients);
  List<ScanResult> get scanHistory => List.unmodifiable(_scanHistory);
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
    _scanHistory
      ..clear()
      ..addAll(await _scanStorage.loadHistory());
    _savedProducts
      ..clear()
      ..addAll(await _scanStorage.loadSavedProducts());
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
    return analyzeOcrText(ocrText, productName: 'เซรั่มไฮยา', source: 'mock');
  }

  ScanResult analyzeOcrText(
    String ocrText, {
    String productName = 'ผลิตภัณฑ์จากรูปภาพ',
    String source = 'ocr',
  }) {
    return analyzeConfirmedIngredients(
      rawOcrText: ocrText,
      ingredients: IngredientParser.parse(ocrText),
      productName: productName,
      source: source,
    );
  }

  ScanResult analyzeConfirmedIngredients({
    required String rawOcrText,
    required List<String> ingredients,
    String productName =
        'เธเธฅเธดเธ•เธ เธฑเธ“เธ‘เนเธเธฒเธเธฃเธนเธเธ เธฒเธ',
    String source = 'confirmed',
  }) {
    return RiskAnalyzer.analyze(
      ocrText: rawOcrText,
      detectedIngredients: ingredients,
      allergens: allergens,
      skinType: _skinType,
      ingredientDatabase: _ingredients,
      productName: productName,
      source: source,
    );
  }

  ScanResult analyzeConfirmedIngredientGroups({
    required String rawOcrText,
    required List<Ingredient> knownIngredients,
    required List<String> unknownIngredientNames,
    String productName = 'ผลิตภัณฑ์จากการสแกน',
    String source = 'confirmed',
  }) {
    return RiskAnalyzer.analyze(
      ocrText: rawOcrText,
      detectedIngredients: [
        ...knownIngredients.map((ingredient) => ingredient.name),
        ...unknownIngredientNames,
      ],
      allergens: allergens,
      skinType: _skinType,
      ingredientDatabase: _ingredients,
      productName: productName,
      source: source,
    );
  }

  Future<ScanResult> analyzeAndSaveConfirmedIngredientGroups({
    required String rawOcrText,
    required List<Ingredient> knownIngredients,
    required List<String> unknownIngredientNames,
    String productName = 'ผลิตภัณฑ์จากการสแกน',
    String source = 'confirmed',
  }) async {
    final result = analyzeConfirmedIngredientGroups(
      rawOcrText: rawOcrText,
      knownIngredients: knownIngredients,
      unknownIngredientNames: unknownIngredientNames,
      productName: productName,
      source: source,
    );
    await addScanHistory(result);
    return result;
  }

  Future<void> addScanHistory(ScanResult result) async {
    _scanHistory.removeWhere((item) => item.id == result.id);
    _scanHistory.insert(0, result);
    await _scanStorage.saveHistory(_scanHistory);
    notifyListeners();
  }

  Ingredient findIngredientById(String id) {
    return _ingredients.firstWhere(
      (ingredient) => ingredient.id == id,
      orElse: () => IngredientDatabase.findById(id),
    );
  }

  Future<void> saveProduct(ScanResult result) async {
    _savedProducts.removeWhere((item) => item.id == result.id);
    _savedProducts.insert(0, result);
    await _scanStorage.saveSavedProducts(_savedProducts);
    notifyListeners();
  }

  Future<void> removeSavedProduct(String id) async {
    _savedProducts.removeWhere((item) => item.id == id);
    await _scanStorage.saveSavedProducts(_savedProducts);
    notifyListeners();
  }
}
