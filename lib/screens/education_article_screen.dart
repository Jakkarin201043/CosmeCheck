import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

class EducationArticleScreen extends StatelessWidget {
  const EducationArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('บทความความรู้')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alcohol ในสกินแคร์น่ากลัวไหม?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Alcohol ไม่ได้แปลว่าไม่ดีเสมอไป บทบาทและความเหมาะสมขึ้นอยู่กับชนิดของแอลกอฮอล์ สูตรผลิตภัณฑ์ ความเข้มข้น และสภาพผิวของแต่ละคน',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
              _ArticleCard(
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFFFF1F1),
                title: 'แอลกอฮอล์ที่อาจทำให้ผิวแห้ง',
                body:
                    'เช่น Alcohol Denat. และ Ethanol อาจช่วยให้เนื้อผลิตภัณฑ์แห้งไว แต่บางคนอาจรู้สึกแห้ง แสบ หรือระคายเคือง โดยเฉพาะผิวแพ้ง่าย',
              ),
              const SizedBox(height: 14),
              _ArticleCard(
                icon: Icons.spa_outlined,
                color: AppColors.softTeal,
                title: 'Fatty Alcohols ที่ช่วยให้ผิวนุ่ม',
                body:
                    'เช่น Cetyl Alcohol, Cetearyl Alcohol และ Stearyl Alcohol มักทำหน้าที่ช่วยให้เนื้อครีมนุ่มและช่วยเคลือบผิว ไม่เหมือนแอลกอฮอล์ระเหยไว',
              ),
              const SizedBox(height: 18),
              AppCard(
                color: AppColors.softBlue,
                borderColor: const Color(0xFFD6E9FF),
                child: Text(
                  'สรุป: ความเหมาะสมขึ้นอยู่กับสภาพผิว สูตรผลิตภัณฑ์ และความเข้มข้น หากมีผิวแพ้ง่ายหรือเคยระคายเคือง ควรทดสอบก่อนใช้',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.45,
                  ),
                ),
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

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
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
