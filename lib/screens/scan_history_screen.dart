import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/scan_result.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppState>().scanHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการสแกน')),
      body: SafeArea(
        child: history.isEmpty
            ? const _EmptyHistoryState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                itemCount: history.length + 1,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const _HistoryLocalNote();
                  }
                  return _HistoryTile(result: history[index - 1]);
                },
              ),
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

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
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.history_outlined,
                color: AppColors.primaryDark,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'ยังไม่มีประวัติการสแกน',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'เมื่อวิเคราะห์ส่วนผสมจากกล้องหรือรูปภาพ รายการล่าสุดจะบันทึกไว้ในเครื่องนี้',
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

class _HistoryLocalNote extends StatelessWidget {
  const _HistoryLocalNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFF1F7F8),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ประวัตินี้บันทึกไว้ในเครื่องของคุณเท่านั้น',
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

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final date = _thaiDate(result.createdAt);
    return AppCard(
      onTap: () => context.push('/scan-result', extra: result),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
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
                const SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'คะแนน ${result.riskScore.toStringAsFixed(1)} / 10',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${result.detectedIngredients.length} ส่วนผสม',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (result.unknownIngredients.isNotEmpty)
                      Text(
                        '${result.unknownIngredients.length} ยังไม่มีข้อมูล',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor(
                          result.status,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        result.status,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: statusColor(result.status),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _thaiDate(DateTime date) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    final buddhistYear = (date.year + 543) % 100;
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} $buddhistYear, ${date.hour}:$minute';
  }
}
