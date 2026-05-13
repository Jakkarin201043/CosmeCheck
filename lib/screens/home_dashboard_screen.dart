import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'CosmeCheck',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'สวัสดีค่ะ',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ดูแลผิวของคุณไปกับ CosmeCheck',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 34,
                ),
                onTap: () => context.go('/scan'),
                child: Column(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4F3F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.document_scanner_outlined,
                        color: AppColors.primaryDark,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'สแกนฉลากส่วนผสม',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'วิเคราะห์ความเสี่ยงจากภาพถ่าย',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.84,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _FeatureCard(
                    icon: Icons.search,
                    tint: AppColors.softBlue,
                    iconColor: AppColors.secondary,
                    title: 'ค้นหาส่วนผสม',
                    subtitle: 'ตรวจสอบจากฐานข้อมูล',
                    onTap: () => context.go('/ingredients'),
                  ),
                  _FeatureCard(
                    icon: Icons.health_and_safety_outlined,
                    tint: const Color(0xFFFFECEC),
                    iconColor: AppColors.warningDark,
                    title: 'โปรไฟล์การแพ้',
                    subtitle: 'จัดการสารที่แพ้',
                    onTap: () => context.push('/allergy-profile'),
                  ),
                  _FeatureCard(
                    icon: Icons.history,
                    tint: const Color(0xFFEFF4F4),
                    iconColor: AppColors.textPrimary,
                    title: 'ประวัติการสแกน',
                    subtitle: 'ดูผลวิเคราะห์ย้อนหลัง',
                    onTap: () => context.push('/history'),
                  ),
                  _FeatureCard(
                    icon: Icons.menu_book_outlined,
                    tint: AppColors.softBlue,
                    iconColor: const Color(0xFF45658F),
                    title: 'ความรู้ผิว',
                    subtitle: 'บทความและคำแนะนำ',
                    onTap: () => context.push('/education'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AppCard(
                color: const Color(0xFFE3F5FF),
                borderColor: const Color(0xFFD5ECF8),
                onTap: () => context.push('/patch-test'),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ทดสอบก่อนใช้',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'เรียนรู้วิธี Patch Test 7-10 วัน',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color tint;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
