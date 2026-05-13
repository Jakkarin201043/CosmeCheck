import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class AllergyProfileScreen extends StatelessWidget {
  const AllergyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์การแพ้')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เลือกสารที่คุณต้องการให้ CosmeCheck ช่วยเตือนเมื่อพบในฉลาก',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: AppState.allAllergens.map((allergen) {
                    return SwitchListTile.adaptive(
                      value: state.allergens.contains(allergen),
                      onChanged: (value) => state.setAllergen(allergen, value),
                      title: Text(
                        allergen,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text('แจ้งเตือนเมื่อพบในผลสแกน'),
                      activeThumbColor: AppColors.primaryDark,
                      activeTrackColor: AppColors.primary.withValues(
                        alpha: 0.28,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              const SectionTitle('สภาพผิวของคุณ'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppState.skinTypes.map((type) {
                  final selected = state.skinType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) => state.setSkinType(type),
                    selectedColor: AppColors.softTeal,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.primaryDark
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                    side: BorderSide(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'บันทึกโปรไฟล์',
                onPressed: () async {
                  await context.read<AppState>().saveProfile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('บันทึกโปรไฟล์การแพ้แล้ว')),
                    );
                  }
                },
              ),
              const SizedBox(height: 18),
              const DisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }
}
