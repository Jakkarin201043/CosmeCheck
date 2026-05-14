import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/ingredient.dart';
import '../models/ingredient_confirmation_draft.dart';
import '../services/ingredient_parser.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

const _knownGroupTitle = 'พบในฐานข้อมูล';
const _unknownGroupTitle = 'ยังไม่มีในฐานข้อมูล';
const _unknownNote =
    'ส่วนผสมเหล่านี้ถูกอ่านข้อความได้ แต่ยังไม่มีข้อมูลในฐานข้อมูลของแอพ จึงไม่ควรสรุปว่าปลอดภัยหรืออันตราย';
const _emptyKnownMessage = 'ยังไม่พบส่วนผสมที่ตรงกับฐานข้อมูล';
const _emptyUnknownMessage = 'ยังไม่มีส่วนผสมที่อยู่นอกฐานข้อมูล';
const _addUnknownLabel = 'เพิ่มส่วนผสมเอง';
const _removeUnknownLabel = 'ลบส่วนผสมนี้';

class ConfirmIngredientsScreen extends StatefulWidget {
  const ConfirmIngredientsScreen({super.key, required this.draft});

  final IngredientConfirmationDraft draft;

  @override
  State<ConfirmIngredientsScreen> createState() =>
      _ConfirmIngredientsScreenState();
}

class _ConfirmIngredientsScreenState extends State<ConfirmIngredientsScreen> {
  late final TextEditingController _ingredientController;
  late final List<Ingredient> _knownIngredients;
  late final List<String> _unknownIngredientNames;

  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
    final initial = _initialClassification();
    _knownIngredients = _dedupeKnown(initial.knownIngredients);
    _unknownIngredientNames = _dedupeUnknown(initial.unknownIngredientNames);
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  IngredientParseResult _initialClassification() {
    if (widget.draft.knownIngredients.isNotEmpty ||
        widget.draft.unknownIngredientNames.isNotEmpty) {
      return IngredientParseResult(
        rawIngredientNames: widget.draft.parsedIngredients,
        knownIngredients: widget.draft.knownIngredients,
        unknownIngredientNames: widget.draft.unknownIngredientNames,
      );
    }

    return IngredientParser.classifyDetectedIngredients(
      detectedIngredients: widget.draft.parsedIngredients,
      database: context.read<AppState>().ingredients,
    );
  }

  void _addIngredient(String value) {
    final parsed = IngredientParser.parse(value);
    if (parsed.isEmpty) {
      return;
    }

    final result = IngredientParser.classifyDetectedIngredients(
      detectedIngredients: parsed,
      database: context.read<AppState>().ingredients,
    );

    setState(() {
      for (final ingredient in result.knownIngredients) {
        _addKnownIngredient(ingredient);
      }
      for (final ingredientName in result.unknownIngredientNames) {
        _addUnknownIngredient(ingredientName);
      }
      _ingredientController.clear();
    });
  }

  void _addKnownIngredient(Ingredient ingredient) {
    if (_knownIngredients.any((item) => item.id == ingredient.id)) {
      return;
    }
    _knownIngredients.add(ingredient);
    _unknownIngredientNames.removeWhere(
      (unknown) => IngredientParser.matchesAnyTerm(unknown, ingredient),
    );
  }

  void _addUnknownIngredient(String value) {
    final cleaned = IngredientParser.cleanIngredientName(value);
    final normalized = IngredientParser.normalize(cleaned);
    if (normalized.isEmpty || _isKnownTermPresent(cleaned)) {
      return;
    }
    if (_unknownIngredientNames.any(
      (item) => IngredientParser.normalize(item) == normalized,
    )) {
      return;
    }
    _unknownIngredientNames.add(cleaned);
  }

  void _removeKnownIngredient(int index) {
    setState(() => _knownIngredients.removeAt(index));
  }

  void _removeUnknownIngredient(int index) {
    setState(() => _unknownIngredientNames.removeAt(index));
  }

  void _analyzeConfirmedIngredients() {
    if (_knownIngredients.isEmpty && _unknownIngredientNames.isEmpty) {
      return;
    }

    final result = context.read<AppState>().analyzeConfirmedIngredientGroups(
      rawOcrText: widget.draft.rawOcrText,
      knownIngredients: List.unmodifiable(_knownIngredients),
      unknownIngredientNames: List.unmodifiable(_unknownIngredientNames),
      productName: widget.draft.productName,
    );
    context.push('/scan-result', extra: result);
  }

  bool _isKnownTermPresent(String value) {
    return _knownIngredients.any(
      (ingredient) => IngredientParser.matchesAnyTerm(value, ingredient),
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
    ].any(_isKnownTermPresent);
  }

  @override
  Widget build(BuildContext context) {
    final ingredientCount =
        _knownIngredients.length + _unknownIngredientNames.length;
    final canAnalyze = ingredientCount > 0;

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
                      'ตรวจรายการที่ OCR อ่านได้ ลบส่วนที่ไม่ใช่ส่วนผสม หรือเพิ่มรายการที่อ่านตกหล่นก่อนวิเคราะห์',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _RawOcrCard(rawText: widget.draft.rawOcrText),
                    const SizedBox(height: 22),
                    _KnownIngredientSection(
                      ingredients: _knownIngredients,
                      onRemove: _removeKnownIngredient,
                    ),
                    const SizedBox(height: 22),
                    _UnknownIngredientSection(
                      ingredientNames: _unknownIngredientNames,
                      onRemove: _removeUnknownIngredient,
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
              ingredientCount: ingredientCount,
              knownCount: _knownIngredients.length,
              unknownCount: _unknownIngredientNames.length,
              onAnalyze: _analyzeConfirmedIngredients,
            ),
          ],
        ),
      ),
    );
  }

  static List<Ingredient> _dedupeKnown(List<Ingredient> values) {
    final ids = <String>{};
    final deduped = <Ingredient>[];
    for (final ingredient in values) {
      if (ids.add(ingredient.id)) {
        deduped.add(ingredient);
      }
    }
    return deduped;
  }

  static List<String> _dedupeUnknown(List<String> values) {
    final normalized = <String>{};
    final deduped = <String>[];
    for (final value in values) {
      final cleaned = IngredientParser.cleanIngredientName(value);
      final key = IngredientParser.normalize(cleaned);
      if (cleaned.isNotEmpty && normalized.add(key)) {
        deduped.add(cleaned);
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

class _KnownIngredientSection extends StatelessWidget {
  const _KnownIngredientSection({
    required this.ingredients,
    required this.onRemove,
  });

  final List<Ingredient> ingredients;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(_knownGroupTitle),
        const SizedBox(height: 12),
        if (ingredients.isEmpty)
          const _EmptyGroupNotice(
            icon: Icons.search_off_outlined,
            message: _emptyKnownMessage,
          )
        else
          ListView.separated(
            key: const Key('knownIngredientList'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _KnownIngredientReviewTile(
                ingredient: ingredients[index],
                onRemove: () => onRemove(index),
                removeKey: ValueKey('removeKnownIngredient-$index'),
              );
            },
          ),
      ],
    );
  }
}

class _UnknownIngredientSection extends StatelessWidget {
  const _UnknownIngredientSection({
    required this.ingredientNames,
    required this.onRemove,
  });

  final List<String> ingredientNames;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(_unknownGroupTitle),
        const SizedBox(height: 12),
        const _UnknownNote(),
        const SizedBox(height: 12),
        if (ingredientNames.isEmpty)
          const _EmptyGroupNotice(
            icon: Icons.check_circle_outline,
            message: _emptyUnknownMessage,
          )
        else
          ListView.separated(
            key: const Key('unknownIngredientList'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredientNames.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ingredientName = ingredientNames[index];
              return _UnknownIngredientReviewTile(
                ingredientName: ingredientName,
                onRemove: () => onRemove(index),
                removeKey: ValueKey('removeUnknownIngredient-$index'),
              );
            },
          ),
      ],
    );
  }
}

class _KnownIngredientReviewTile extends StatelessWidget {
  const _KnownIngredientReviewTile({
    required this.ingredient,
    required this.onRemove,
    required this.removeKey,
  });

  final Ingredient ingredient;
  final VoidCallback onRemove;
  final Key removeKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('knownIngredientReview-${ingredient.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.safe),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () =>
                  context.push('/ingredient-detail?id=${ingredient.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'ตรงกับฐานข้อมูล: ${ingredient.thaiName}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            key: removeKey,
            tooltip: 'ลบส่วนผสมนี้',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            color: AppColors.warningDark,
          ),
        ],
      ),
    );
  }
}

class _UnknownIngredientReviewTile extends StatelessWidget {
  const _UnknownIngredientReviewTile({
    required this.ingredientName,
    required this.onRemove,
    required this.removeKey,
  });

  final String ingredientName;
  final VoidCallback onRemove;
  final Key removeKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(
        'unknownIngredientReview-${IngredientParser.normalize(ingredientName)}',
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredientName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            key: removeKey,
            tooltip: _removeUnknownLabel,
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            color: AppColors.warningDark,
          ),
        ],
      ),
    );
  }
}

class _UnknownNote extends StatelessWidget {
  const _UnknownNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFFFF7E8),
      borderColor: const Color(0xFFFFE0A8),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF9A6500)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _unknownNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class _EmptyGroupNotice extends StatelessWidget {
  const _EmptyGroupNotice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFF8FAFA),
      borderColor: AppColors.border,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
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
            _addUnknownLabel,
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
              hintText: 'เช่น Glycerin, Caprylyl Glycol',
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
    required this.knownCount,
    required this.unknownCount,
    required this.onAnalyze,
  });

  final bool canAnalyze;
  final int ingredientCount;
  final int knownCount;
  final int unknownCount;
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
            '$ingredientCount รายการพร้อมวิเคราะห์ ($knownCount ในฐานข้อมูล, $unknownCount ยังไม่มีข้อมูล)',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
