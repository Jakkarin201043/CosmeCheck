import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class PatchTestScreen extends StatelessWidget {
  const PatchTestScreen({super.key});

  static const _steps = [
    ('1', 'ทำความสะอาดผิว', 'เลือกบริเวณเล็ก ๆ เช่น หลังใบหูหรือท้องแขน'),
    ('2', 'ทาผลิตภัณฑ์ปริมาณเล็กน้อย', 'ใช้ปริมาณเท่าเมล็ดถั่วและไม่ต้องถูแรง'),
    ('3', 'รอ 24 ชั่วโมง', 'หลีกเลี่ยงการล้างหรือทาผลิตภัณฑ์อื่นทับบริเวณนั้น'),
    ('4', 'สังเกตอาการแดง คัน แสบ หรือบวม', 'หากมีอาการผิดปกติให้หยุดใช้ทันที'),
    (
      '5',
      'ทดสอบต่อเนื่อง 7-10 วัน',
      'บางอาการอาจเกิดช้าจึงควรสังเกตอย่างต่อเนื่อง',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วิธีทดสอบก่อนใช้')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ทดสอบก่อนใช้ครีมหรือเซรั่มใหม่ 7-10 วัน',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              for (final step in _steps) ...[
                AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.softTeal,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            step.$1,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.$2,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              step.$3,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.45,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              AppCard(
                color: const Color(0xFFFFF1F1),
                borderColor: const Color(0xFFFFD4D4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warningDark,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'หากมีอาการผิดปกติ ให้หยุดใช้ทันทีและปรึกษาแพทย์ผิวหนัง',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.warningDark,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }
}
