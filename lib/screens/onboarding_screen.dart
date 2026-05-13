import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: compact ? 12 : 28),
                      Container(
                        width: compact ? 82 : 96,
                        height: compact ? 82 : 96,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.16),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.manage_search,
                          color: AppColors.primaryDark,
                          size: compact ? 44 : 52,
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 18),
                      Text(
                        'CosmeCheck',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ผู้ช่วยส่วนตัวดูแลผิวและเช็คความเสี่ยงแพ้',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: compact ? 22 : 44),
                      _SkincareIllustration(size: compact ? 210 : 250),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _Dot(active: true),
                          _Dot(active: false),
                          _Dot(active: false),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'เริ่มต้นใช้งาน',
                        onPressed: () => context.go('/login'),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkincareIllustration extends StatelessWidget {
  const _SkincareIllustration({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = size / 250;
    return SizedBox(
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softTeal,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 38,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 26 * scale,
            child: Container(
              width: 190 * scale,
              height: 54 * scale,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Container(
            width: 142 * scale,
            height: 154 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(46),
                bottom: Radius.circular(24),
              ),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x160B2545),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64 * scale,
                  height: 10 * scale,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 18 * scale),
                Icon(
                  Icons.science_outlined,
                  color: AppColors.primaryDark,
                  size: 44 * scale,
                ),
                SizedBox(height: 10 * scale),
                Text(
                  'INCI',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
