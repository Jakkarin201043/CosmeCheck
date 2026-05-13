import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF10A7A7);
  static const primaryDark = Color(0xFF007878);
  static const secondary = Color(0xFF2F80ED);
  static const background = Color(0xFFF6FBFF);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0B2545);
  static const textSecondary = Color(0xFF607080);
  static const warning = Color(0xFFFF6B6B);
  static const warningDark = Color(0xFFC62828);
  static const safe = Color(0xFF27AE60);
  static const softBlue = Color(0xFFEAF6FF);
  static const softTeal = Color(0xFFE8FAF8);
  static const border = Color(0xFFDCE8EA);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primaryDark,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.warningDark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
    );

    final textTheme = GoogleFonts.notoSansThaiTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
