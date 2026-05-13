import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/ingredient_database.dart';
import '../models/ingredient.dart';
import '../services/ingredient_parser.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  String _query = '';
  String _filter = 'ทั้งหมด';
  final _filters = const ['ทั้งหมด', 'ให้ประโยชน์', 'ควรระวัง', 'หลีกเลี่ยง'];

  @override
  Widget build(BuildContext context) {
    final results = IngredientDatabase.ingredients.where((ingredient) {
      final normalizedQuery = IngredientParser.normalize(_query);
      final matchesQuery =
          normalizedQuery.isEmpty ||
          ingredient.searchableTerms.any(
            (term) =>
                IngredientParser.normalize(term).contains(normalizedQuery),
          );
      final matchesFilter = _filter == 'ทั้งหมด' || ingredient.tag == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาส่วนผสม')),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'ค้นหาชื่อสาร เช่น Niacinamide, BHA, น้ำหอม',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final selected = _filter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: selected,
                        label: Text(filter),
                        onSelected: (_) => setState(() => _filter = filter),
                        selectedColor: AppColors.softTeal,
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              for (final ingredient in results) ...[
                IngredientCard(
                  ingredient: ingredient,
                  onTap: () =>
                      context.push('/ingredient-detail?id=${ingredient.id}'),
                ),
                const SizedBox(height: 14),
              ],
              if (results.isEmpty) const _EmptyIngredientState(),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  final Ingredient ingredient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tagType = switch (ingredient.tag) {
      'ให้ประโยชน์' => ChipType.safe,
      'หลีกเลี่ยง' => ChipType.warning,
      _ => ChipType.caution,
    };

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tagType == ChipType.safe
                  ? AppColors.softTeal
                  : const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              tagType == ChipType.safe
                  ? Icons.spa_outlined
                  : Icons.warning_amber_rounded,
              color: tagType == ChipType.safe
                  ? AppColors.primaryDark
                  : AppColors.warningDark,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InfoChip(label: ingredient.tag, type: tagType),
                    InfoChip(
                      label: _riskLabel(ingredient.riskLevel),
                      type: tagType,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ingredient.thaiName,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ingredient.shortDescription,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _riskLabel(String riskLevel) {
    return switch (riskLevel) {
      'high' => 'ความเสี่ยงสูง',
      'medium' => 'ความเสี่ยงปานกลาง',
      _ => 'ความเสี่ยงต่ำ',
    };
  }
}

class _EmptyIngredientState extends StatelessWidget {
  const _EmptyIngredientState();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.softBlue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.search_off_outlined, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ยังไม่พบส่วนผสมที่ค้นหา ลองค้นด้วยชื่อภาษาอังกฤษ ชื่อไทย หรือชื่อเรียกอื่น เช่น BHA, Parfum, วิตามินบี 3',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
