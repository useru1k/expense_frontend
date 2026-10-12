import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF0C1422);
  static const navySurface = Color(0xFF151F2E);
  static const navyCard = Color(0xFF1A2738);
  static const border = Color(0xFF2B394B);
  static const muted = Color(0xFF91A0B4);
  static const text = Color(0xFFF4F7FB);
  static const green = Color(0xFF6EE7B7);
  static const greenDeep = Color(0xFF2F8F71);
  static const red = Color(0xFFFF7C9B);
  static const blue = Color(0xFF8B9CFF);
}

class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.dark,
      surface: AppColors.navySurface,
    );
    return _buildTheme(
      scheme,
      scaffoldBackgroundColor: AppColors.navy,
      cardColor: AppColors.navyCard,
      textColor: AppColors.text,
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.greenDeep,
      brightness: Brightness.light,
    );
    return _buildTheme(
      scheme,
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      cardColor: Colors.white,
      textColor: const Color(0xFF142033),
    );
  }

  static ThemeData _buildTheme(
    ColorScheme scheme, {
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color textColor,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      brightness: scheme.brightness,
      cardColor: cardColor,
      fontFamily: 'sans',
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.dark
            ? AppColors.navySurface
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: scheme.brightness == Brightness.dark
                ? AppColors.border
                : const Color(0xFFE3E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: scheme.brightness == Brightness.dark
            ? const Color(0xFF29423D)
            : const Color(0xFFDDF8EC),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      dividerColor: scheme.brightness == Brightness.dark
          ? AppColors.border
          : const Color(0xFFE3E8F0),
    );
  }
}
