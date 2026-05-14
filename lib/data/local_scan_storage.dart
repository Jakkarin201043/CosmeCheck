import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_result.dart';

class LocalScanStorage {
  const LocalScanStorage();

  static const _historyKey = 'scanHistoryResults';
  static const _savedKey = 'savedProductResults';

  Future<List<ScanResult>> loadHistory() => _loadResults(_historyKey);

  Future<void> saveHistory(List<ScanResult> results) {
    return _saveResults(_historyKey, results);
  }

  Future<List<ScanResult>> loadSavedProducts() => _loadResults(_savedKey);

  Future<void> saveSavedProducts(List<ScanResult> results) {
    return _saveResults(_savedKey, results);
  }

  Future<List<ScanResult>> _loadResults(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedResults = prefs.getStringList(key) ?? const [];

    return encodedResults
        .map((encoded) => jsonDecode(encoded))
        .whereType<Map<String, dynamic>>()
        .map(ScanResult.fromJson)
        .toList(growable: false);
  }

  Future<void> _saveResults(String key, List<ScanResult> results) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedResults = results
        .map((result) => jsonEncode(result.toJson()))
        .toList(growable: false);
    await prefs.setStringList(key, encodedResults);
  }
}
