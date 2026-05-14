import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/scan_result.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key, required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final warningColor = statusColor(result.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลการวิเคราะห์'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
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
                    AppCard(
                      color: const Color(0xFFFFF3F3),
                      borderColor: const Color(0xFFFFD1D1),
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD7D7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _statusIcon(result.status),
                              color: warningColor,
                              size: 46,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            result.status,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: warningColor,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _statusDescription(result),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _RiskMetric(
                                      label: 'คะแนนความเสี่ยง',
                                      value:
                                          '${result.riskScore.toStringAsFixed(1)} / 10',
                                      color: warningColor,
                                    ),
                                  ),
                                  Container(width: 1, color: AppColors.border),
                                  Expanded(
                                    child: _RiskMetric(
                                      label: 'ความเหมาะสม',
                                      value: _suitability(result.status),
                                      color: warningColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (result.unknownIngredients.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const _UnknownIngredientResultNotice(),
                    ],
                    const SizedBox(height: 26),
                    _ChipSection(
                      title: 'สารที่ตรงกับโปรไฟล์การแพ้ของคุณ',
                      chips: result.matchedAllergens,
                      emptyText: 'ไม่พบสารที่ตรงกับโปรไฟล์การแพ้',
                      type: ChipType.warning,
                    ),
                    const SizedBox(height: 20),
                    _ChipSection(
                      title: 'สารที่เป็นประโยชน์หรือช่วยปลอบประโลมผิว',
                      chips: result.helpfulIngredients,
                      emptyText:
                          'ยังไม่พบสารกลุ่มช่วยปลอบประโลมในข้อมูลตัวอย่าง',
                      type: ChipType.safe,
                    ),
                    const SizedBox(height: 20),
                    _ChipSection(
                      title: 'สารที่ต้องระวัง',
                      chips: result.cautionIngredients,
                      emptyText: 'ไม่พบสารที่ควรระวังจากฐานข้อมูลตัวอย่าง',
                      type: ChipType.caution,
                    ),
                    const SizedBox(height: 20),
                    _ChipSection(
                      title: 'ส่วนผสมที่ยังไม่อยู่ในฐานข้อมูล',
                      chips: result.unknownIngredients,
                      emptyText:
                          'ไม่มีส่วนผสมที่อยู่นอกฐานข้อมูลตัวอย่างในรายการนี้',
                      type: ChipType.neutral,
                    ),
                    const SizedBox(height: 24),
                    AppCard(
                      color: const Color(0xFFF1F7F8),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _analysisExplanation(result),
                              softWrap: true,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
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
            _ResultActions(result: result),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(String status) {
    if (status == 'ปลอดภัยเบื้องต้น') {
      return Icons.check_circle_outline;
    }
    return Icons.warning_amber_rounded;
  }

  String _statusDescription(ScanResult result) {
    if (result.matchedAllergens.isNotEmpty) {
      return 'พบสารที่ตรงกับโปรไฟล์การแพ้หรือสารที่ควรระวังสำหรับผิวของคุณ';
    }
    if (result.cautionIngredients.isNotEmpty) {
      return 'พบสารที่อาจระคายเคืองในบางสภาพผิว ควรทดสอบก่อนใช้';
    }
    return 'ไม่พบสารที่ตรงกับโปรไฟล์การแพ้จากข้อมูลตัวอย่าง แต่ควรสังเกตผิวเมื่อเริ่มใช้';
  }

  String _suitability(String status) {
    if (status == 'ไม่แนะนำสำหรับโปรไฟล์นี้') {
      return 'ไม่เหมาะกับโปรไฟล์นี้';
    }
    if (status == 'ควรระวัง') {
      return 'ควรทดสอบก่อนใช้';
    }
    return 'ใช้ได้เบื้องต้น';
  }

  String _analysisExplanation(ScanResult result) {
    final allergens = result.matchedAllergens.join(', ');
    final cautions = result.cautionIngredients.join(', ');

    if (result.matchedAllergens.isNotEmpty) {
      return 'ผลการวิเคราะห์พบ $allergens ซึ่งตรงกับโปรไฟล์การแพ้ของคุณ และพบสารที่ควรระวัง เช่น $cautions จึงควรใช้ด้วยความระมัดระวัง ทำ Patch Test และหยุดใช้หากมีอาการผิดปกติ';
    }
    if (result.cautionIngredients.isNotEmpty) {
      return 'ผลการวิเคราะห์พบสารที่ควรระวัง เช่น $cautions ซึ่งอาจทำให้ผิวแห้งหรือระคายเคืองในบางคน ควรทดสอบก่อนใช้ โดยเฉพาะผู้ที่มีผิวแพ้ง่าย';
    }
    return 'ผลนี้เป็นการประเมินเบื้องต้นจากข้อมูลส่วนผสมที่อ่านได้ ไม่ใช่การยืนยันว่าผลิตภัณฑ์เหมาะกับทุกคน ควรสังเกตอาการผิวเมื่อเริ่มใช้';
  }
}

class _UnknownIngredientResultNotice extends StatelessWidget {
  const _UnknownIngredientResultNotice();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('scanResultUnknownNotice'),
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
              'มีบางส่วนผสมที่ยังไม่มีข้อมูลในฐานข้อมูล ผลลัพธ์นี้จึงเป็นการประเมินเบื้องต้นเท่านั้น',
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

class _ResultActions extends StatelessWidget {
  const _ResultActions({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackButtons = constraints.maxWidth < 340;
          final saveButton = PrimaryButton(
            label: 'บันทึกสินค้า',
            icon: Icons.bookmark_border,
            filled: false,
            onPressed: () {
              context.read<AppState>().saveProduct(result);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('บันทึกสินค้าแล้ว')));
            },
          );
          final detailButton = PrimaryButton(
            label: 'ดูรายละเอียด',
            onPressed: () => context.push('/ingredient-detail?id=niacinamide'),
          );

          if (stackButtons) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [saveButton, const SizedBox(height: 10), detailButton],
            );
          }

          return Row(
            children: [
              Expanded(child: saveButton),
              const SizedBox(width: 12),
              Expanded(child: detailButton),
            ],
          );
        },
      ),
    );
  }
}

class _RiskMetric extends StatelessWidget {
  const _RiskMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ChipSection extends StatelessWidget {
  const _ChipSection({
    required this.title,
    required this.chips,
    required this.emptyText,
    required this.type,
  });

  final String title;
  final List<String> chips;
  final String emptyText;
  final ChipType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        const SizedBox(height: 12),
        if (chips.isEmpty)
          Text(
            emptyText,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: chips
                .map((item) => InfoChip(label: item, type: type))
                .toList(),
          ),
      ],
    );
  }
}
