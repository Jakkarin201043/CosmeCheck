import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class IngredientDetailScreen extends StatelessWidget {
  const IngredientDetailScreen({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final tagType = switch (ingredient.tag) {
      'ให้ประโยชน์' => ChipType.safe,
      'หลีกเลี่ยง' => ChipType.warning,
      _ => ChipType.caution,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดส่วนผสม')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InfoChip(label: ingredient.tag, type: tagType),
                        InfoChip(
                          label: _riskLabel(ingredient.riskLevel),
                          type: tagType,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ingredient.name,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ingredient.thaiName,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'INCI: ${ingredient.inciName}',
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'หมวดหมู่: ${ingredient.category}',
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (ingredient.aliases.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ingredient.aliases
                            .map(
                              (alias) => InfoChip(
                                label: alias,
                                type: ChipType.neutral,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _DetailSection(title: 'คืออะไร', body: ingredient.whatIsIt),
              _ListSection(title: 'ประโยชน์', items: ingredient.benefits),
              _ListSection(title: 'ข้อควรระวัง', items: ingredient.cautions),
              _ListSection(title: 'เหมาะกับ', items: ingredient.suitableFor),
              _ListSection(
                title: 'ควรหลีกเลี่ยงถ้า',
                items: ingredient.avoidIf,
              ),
              _ListSection(
                title: 'พบได้ในผลิตภัณฑ์แบบไหน',
                items: ingredient.commonIn,
              ),
              _ListSection(title: 'Myth vs Fact', items: ingredient.mythVsFact),
              const SizedBox(height: 8),
              const SectionTitle('แหล่งอ้างอิง'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ingredient.references
                    .map(
                      (item) => InfoChip(label: item, type: ChipType.neutral),
                    )
                    .toList(),
              ),
              const SizedBox(height: 22),
              const DisclaimerCard(),
            ],
          ),
        ),
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

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    if (body.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title),
            const SizedBox(height: 10),
            Text(
              body,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title),
            const SizedBox(height: 10),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 7,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
