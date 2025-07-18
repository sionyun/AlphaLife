import 'package:flutter/material.dart';

class AppColors {
  static const scaffoldBg = Color(0xFF0B0E11);
  static const cardBg = Color(0xFFFFFFFF);
  static const quickActIconBg =
      Color(0xFFE7F2F3); // Quick Action icon background
  static const primaryText = Color(0xFFFFFFFF);
  static const accent = Color(0xFF1E91A3);
  static const darkText = Color.fromARGB(255, 20, 20, 20);
  static const lightGrayText = Color(0xFF777777);
  static const searchBg = Color(0xFF191E25);
  static const resourceBg = Color(0xFFC2E4E7); // resource icon bg
  static const buttonBg = Color(0xFF0B0F12); // dark button background
}

class AppTextStyles {
  static const title = TextStyle(
    color: AppColors.primaryText,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Afacad',
    height: 1.4,
  );

  static const header = TextStyle(
    color: AppColors.accent,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'Afacad',
    height: 1.4,
  );

  static const sectionTitle = TextStyle(
      color: AppColors.darkText,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: 'Afacad',
      height: 1.4);

  // Body text large (e.g., card item titles)
  static const bodyLarge = TextStyle(
      color: AppColors.darkText,
      fontSize: 19,
      fontFamily: 'Afacad',
      height: 1.3);

  // Body text medium (e.g., list subtitles, descriptions)
  static const bodyMedium = TextStyle(
      color: AppColors.darkText,
      fontSize: 16,
      fontFamily: 'Afacad',
      height: 1.2);

  // Body text small (e.g., timestamps, captions)
  static const bodySmall = TextStyle(
      color: AppColors.lightGrayText,
      fontSize: 13,
      fontFamily: 'Afacad',
      height: 1.2);

  // Black button text
  static const button1 = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      fontFamily: 'Afacad');

  // White button text
  static const button2 = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      fontFamily: 'Afacad');

  // Label text (e.g., Quick Action labels)
  static const label = TextStyle(
      color: AppColors.darkText,
      fontSize: 14,
      fontFamily: 'Afacad',
      height: 1.2);
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.scaffoldBg,
  cardColor: AppColors.cardBg,

  textTheme: const TextTheme(
    titleLarge: AppTextStyles.title,
    headlineMedium: AppTextStyles.header,
    titleSmall: AppTextStyles.sectionTitle,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.button1,
    labelSmall: AppTextStyles.label,
  ),

  // Dark color scheme matching the design
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.accent,
    surface: AppColors.cardBg,
    error: Colors.red,
  ).copyWith(
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.darkText,
    onError: Colors.white,
  ),

  // Button themes matching the Figma styles
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonBg,
      foregroundColor: Colors.white,
      textStyle: AppTextStyles.button1,
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white),
      textStyle: AppTextStyles.button1,
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),

  // Card theme for consistent cards
  cardTheme: CardTheme(
    color: AppColors.cardBg,
    elevation: 5,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
