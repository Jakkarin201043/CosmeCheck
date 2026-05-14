import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        child: saved.isEmpty
            ? const _EmptySavedState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                itemCount: saved.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) => _SavedCard(
                  key: ValueKey('savedProduct-${saved[index].id}'),
                  result: saved[index],
                ),
              ),
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.softTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.bookmark_border,
                color: AppColors.primaryDark,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'ยังไม่มีรายการที่บันทึกไว้',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'กดบันทึกผลลัพธ์ในหน้าผลการวิเคราะห์เพื่อเก็บไว้ดูภายหลัง',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({super.key, required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/scan-result', extra: result),
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
                key: ValueKey('removeSavedProduct-${result.id}'),
                tooltip: 'ลบรายการนี้',
                onPressed: () async {
                  await context.read<AppState>().removeSavedProduct(result.id);
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ลบรายการที่บันทึกแล้ว')),
                  );
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'ข้อมูลที่บันทึก',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(
                label: '${result.detectedIngredients.length} ส่วนผสม',
                type: ChipType.neutral,
              ),
              if (result.unknownIngredients.isNotEmpty)
                InfoChip(
                  label: '${result.unknownIngredients.length} ยังไม่มีข้อมูล',
                  type: ChipType.neutral,
                ),
              InfoChip(
                label: 'คะแนน ${result.riskScore.toStringAsFixed(1)} / 10',
                type: ChipType.caution,
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'ดูผลลัพธ์',
            icon: Icons.article_outlined,
            filled: false,
            onPressed: () => context.push('/scan-result', extra: result),
          ),
        ],
      ),
    );
  }
}
