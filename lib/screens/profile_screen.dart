import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์ผู้ใช้')),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                        color: AppColors.softTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryDark,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'ผู้ใช้ CosmeCheck',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user@cosmecheck.app',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileStat(
                            label: 'สภาพผิว',
                            value: state.skinType,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ProfileStat(
                            label: 'สารที่เฝ้าระวัง',
                            value: '${state.allergens.length} รายการ',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.health_and_safety_outlined,
                      title: 'โปรไฟล์การแพ้',
                      onTap: () => context.push('/allergy-profile'),
                    ),
                    _MenuTile(
                      icon: Icons.history,
                      title: 'ประวัติการสแกน',
                      onTap: () => context.push('/history'),
                    ),
                    _MenuTile(
                      icon: Icons.bookmark_border,
                      title: 'รายการบันทึก',
                      onTap: () => context.go('/saved'),
                    ),
                    _MenuTile(
                      icon: Icons.settings_outlined,
                      title: 'ตั้งค่า',
                      onTap: () {},
                    ),
                    _MenuTile(
                      icon: Icons.logout,
                      title: 'ออกจากระบบ',
                      danger: true,
                      onTap: () => context.go('/login'),
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.warningDark : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: danger ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
