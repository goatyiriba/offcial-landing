import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF06D432);
  static const Color secondary = Color(0xFFA991F3);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFFE7E7E7);
  static const Color darkGrey = Color(0xFF333333);
}

class AppTheme {
  static const String fontFamily = 'Athletics';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 68,
          fontWeight: FontWeight.w700,
          height: 1.15,
          color: AppColors.black,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.black,
          fontFamily: fontFamily,
        ),
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.8,
          fontWeight: FontWeight.w500,
          color: Color(0xFF121212),
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF121212),
          fontFamily: fontFamily,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }
}