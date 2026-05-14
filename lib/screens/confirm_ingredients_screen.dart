import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/ingredient.dart';
import '../models/ingredient_confirmation_draft.dart';
import '../services/ingredient_parser.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class ConfirmIngredientsScreen extends StatefulWidget {
  const ConfirmIngredientsScreen({super.key, required this.draft});

  final IngredientConfirmationDraft draft;

  @override
  State<ConfirmIngredientsScreen> createState() =>
      _ConfirmIngredientsScreenState();
}

class _ConfirmIngredientsScreenState extends State<ConfirmIngredientsScreen> {
  late final TextEditingController _ingredientController;
  late final List<String> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
    _ingredients = _dedupe(widget.draft.parsedIngredients);
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient(String value) {
    final parsed = IngredientParser.parse(value);
    if (parsed.isEmpty) {
      return;
    }

    setState(() {
      for (final ingredient in parsed) {
        if (!_containsIngredient(ingredient)) {
          _ingredients.add(ingredient);
        }
      }
      _ingredientController.clear();
    });
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _analyzeConfirmedIngredients() {
    if (_ingredients.isEmpty) {
      return;
    }

    final result = context.read<AppState>().analyzeConfirmedIngredients(
      rawOcrText: widget.draft.rawOcrText,
      ingredients: List.unmodifiable(_ingredients),
      productName: widget.draft.productName,
    );
    context.push('/scan-result', extra: result);
  }

  bool _containsIngredient(String value) {
    final normalized = IngredientParser.normalize(value);
    return _ingredients.any(
      (ingredient) => IngredientParser.normalize(ingredient) == normalized,
    );
  }

  List<Ingredient> get _suggestions {
    return context
        .watch<AppState>()
        .ingredients
        .where((ingredient) => !_containsAnyIngredientTerm(ingredient))
        .take(6)
        .toList();
  }

  bool _containsAnyIngredientTerm(Ingredient ingredient) {
    return [
      ingredient.name,
      ingredient.inciName,
      ingredient.thaiName,
      ...ingredient.aliases,
    ].any(_containsIngredient);
  }

  List<Ingredient> _knownMatches(String ingredient) {
    return IngredientParser.matchKnownIngredients(
      detectedIngredients: [ingredient],
      database: context.read<AppState>().ingredients,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAnalyze = _ingredients.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสอบส่วนผสม'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/scan');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยืนยันก่อนวิเคราะห์',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ตรวจรายการที่ OCR อ่านได้ ลบส่วนที่ไม่ใช่ส่วนผสม หรือเพิ่มรายการที่อ่านตกหล่น',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _RawOcrCard(rawText: widget.draft.rawOcrText),
                    const SizedBox(height: 22),
                    SectionTitle('ส่วนผสมที่อ่านได้'),
                    const SizedBox(height: 12),
                    if (_ingredients.isEmpty)
                      const _EmptyIngredientNotice()
                    else
                      ListView.separated(
                        key: const Key('confirmedIngredientList'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _ingredients.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final ingredient = _ingredients[index];
                          final knownMatches = _knownMatches(ingredient);
                          return _IngredientReviewTile(
                            ingredient: ingredient,
                            knownMatch: knownMatches.isEmpty
                                ? null
                                : knownMatches.first,
                            onRemove: () => _removeIngredient(index),
                            removeKey: ValueKey('removeIngredient-$index'),
                          );
                        },
                      ),
                    const SizedBox(height: 22),
                    _AddIngredientCard(
                      controller: _ingredientController,
                      suggestions: _suggestions,
                      onAdd: _addIngredient,
                    ),
                  ],
                ),
              ),
            ),
            _AnalyzeBar(
              canAnalyze: canAnalyze,
              ingredientCount: _ingredients.length,
              onAnalyze: _analyzeConfirmedIngredients,
            ),
          ],
        ),
      ),
    );
  }

  static List<String> _dedupe(List<String> values) {
    final normalized = <String>{};
    final deduped = <String>[];
    for (final value in values) {
      final trimmed = value.trim();
      final key = IngredientParser.normalize(trimmed);
      if (trimmed.isNotEmpty && normalized.add(key)) {
        deduped.add(trimmed);
      }
    }
    return deduped;
  }
}

class _RawOcrCard extends StatelessWidget {
  const _RawOcrCard({required this.rawText});

  final String rawText;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFF1F7F8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.document_scanner_outlined,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ข้อความ OCR ดิบ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 128),
            child: SingleChildScrollView(
              child: SelectableText(
                rawText,
                key: const Key('rawOcrTextPreview'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientReviewTile extends StatelessWidget {
  const _IngredientReviewTile({
    required this.ingredient,
    required this.knownMatch,
    required this.onRemove,
    required this.removeKey,
  });

  final String ingredient;
  final Ingredient? knownMatch;
  final VoidCallback onRemove;
  final Key removeKey;

  @override
  Widget build(BuildContext context) {
    final known = knownMatch != null;
    return Container(
      key: ValueKey(
        'ingredientReview-${IngredientParser.normalize(ingredient)}',
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            key: ValueKey(
              known
                  ? 'ingredientKnown-${IngredientParser.normalize(ingredient)}'
                  : 'ingredientUnknown-${IngredientParser.normalize(ingredient)}',
            ),
            known ? Icons.check_circle_outline : Icons.help_outline,
            color: known ? AppColors.safe : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  known
                      ? 'ตรงกับฐานข้อมูล: ${knownMatch!.name}'
                      : 'ยังไม่พบในฐานข้อมูล สามารถคงไว้เพื่อวิเคราะห์ข้อความได้',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: removeKey,
            tooltip: 'ลบส่วนผสม',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            color: AppColors.warningDark,
          ),
        ],
      ),
    );
  }
}

class _EmptyIngredientNotice extends StatelessWidget {
  const _EmptyIngredientNotice();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFFFF7E8),
      borderColor: const Color(0xFFFFE0A8),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF9A6500)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'เพิ่มส่วนผสมอย่างน้อย 1 รายการก่อนวิเคราะห์',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF735000),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddIngredientCard extends StatelessWidget {
  const _AddIngredientCard({
    required this.controller,
    required this.suggestions,
    required this.onAdd,
  });

  final TextEditingController controller;
  final List<Ingredient> suggestions;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'เพิ่มส่วนผสม',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('addIngredientField'),
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: onAdd,
            decoration: InputDecoration(
              hintText: 'เช่น Glycerin, Fragrance',
              suffixIcon: IconButton(
                key: const Key('addIngredientButton'),
                tooltip: 'เพิ่มส่วนผสม',
                onPressed: () => onAdd(controller.text),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ),
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final ingredient in suggestions)
                  ActionChip(
                    key: ValueKey('suggestIngredient-${ingredient.id}'),
                    avatar: const Icon(Icons.add, size: 18),
                    label: Text(ingredient.name),
                    onPressed: () => onAdd(ingredient.name),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AnalyzeBar extends StatelessWidget {
  const _AnalyzeBar({
    required this.canAnalyze,
    required this.ingredientCount,
    required this.onAnalyze,
  });

  final bool canAnalyze;
  final int ingredientCount;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$ingredientCount รายการพร้อมวิเคราะห์',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('analyzeConfirmedIngredientsButton'),
              onPressed: canAnalyze ? onAnalyze : null,
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('วิเคราะห์'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
