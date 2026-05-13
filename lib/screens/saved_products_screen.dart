import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/scan_result.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class SavedProductsScreen extends StatelessWidget {
  const SavedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<AppState>().savedProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('รายการบันทึก')),
      body: SafeArea(
        bottom: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          itemCount: saved.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) => _SavedCard(result: saved[index]),
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.softTeal,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.productName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoChip(
                      label: result.status,
                      type: result.status == 'ปลอดภัยเบื้องต้น'
                          ? ChipType.safe
                          : ChipType.warning,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'ลบรายการ',
                onPressed: () {},
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'สารที่ควรระวังหลัก',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.cautionIngredients.isEmpty
                ? [
                    const InfoChip(
                      label: 'ไม่พบสารที่ควรระวัง',
                      type: ChipType.safe,
                    ),
                  ]
                : result.cautionIngredients
                      .map(
                        (item) => InfoChip(label: item, type: ChipType.caution),
                      )
                      .toList(),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'เปรียบเทียบ',
            icon: Icons.compare_arrows,
            filled: false,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
