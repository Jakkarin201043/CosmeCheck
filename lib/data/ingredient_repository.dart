import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ingredient.dart';
import '../services/ingredient_parser.dart';
import 'ingredient_database.dart';

class IngredientRepository {
  const IngredientRepository({
    AssetBundle? assetBundle,
    this.assetPath = 'assets/data/ingredients.json',
  }) : _assetBundle = assetBundle;

  static List<Ingredient>? _cachedIngredients;

  final AssetBundle? _assetBundle;
  final String assetPath;

  Future<List<Ingredient>> loadIngredients() async {
    final cachedIngredients = _cachedIngredients;
    if (cachedIngredients != null) {
      return cachedIngredients;
    }

    try {
      final bundle = _assetBundle ?? rootBundle;
      final assetBytes = await bundle.load(assetPath);
      final rawJson = utf8.decode(
        assetBytes.buffer.asUint8List(
          assetBytes.offsetInBytes,
          assetBytes.lengthInBytes,
        ),
      );
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) {
        _cachedIngredients = IngredientDatabase.ingredients;
        return _cachedIngredients!;
      }

      _cachedIngredients = decoded
          .whereType<Map<String, dynamic>>()
          .map(Ingredient.fromJson)
          .toList(growable: false);
      return _cachedIngredients!;
    } catch (_) {
      _cachedIngredients = IngredientDatabase.ingredients;
      return _cachedIngredients!;
    }
  }

  static List<Ingredient> search(
    List<Ingredient> ingredients,
    String query, {
    String? tag,
  }) {
    final normalizedQuery = IngredientParser.normalize(query);

    return ingredients
        .where((ingredient) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              [
                ingredient.name,
                ingredient.thaiName,
                ingredient.inciName,
                ...ingredient.aliases,
              ].any(
                (term) =>
                    IngredientParser.normalize(term).contains(normalizedQuery),
              );
          final matchesTag =
              tag == null || tag.isEmpty || ingredient.tag == tag;
          return matchesQuery && matchesTag;
        })
        .toList(growable: false);
  }
}
