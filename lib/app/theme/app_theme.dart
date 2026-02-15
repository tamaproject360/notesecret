import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.parchmentWhite,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.sageGreen,
        onPrimary: Colors.white,
        secondary: AppColors.warmGray,
        onSecondary: AppColors.deepCharcoal,
        error: AppColors.terracotta,
        onError: Colors.white,
        surface: AppColors.parchmentWhite,
        onSurface: AppColors.deepCharcoal,
        background: AppColors.parchmentWhite,
        onBackground: AppColors.deepCharcoal,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.headingLarge.copyWith(color: AppColors.deepCharcoal),
        titleMedium: AppTypography.headingMedium.copyWith(color: AppColors.deepCharcoal),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.deepCharcoal),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.deepCharcoal),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.deepCharcoal),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.deepCharcoal),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.deepCharcoal),
      ),
      cardTheme: const CardTheme(
        color: AppColors.softCream,
        elevation: 2,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.06),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.parchmentWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.deepCharcoal),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.warmGray,
        thickness: 0.5,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.deepCharcoal,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.warmBlack,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.mutedSage,
        onPrimary: Colors.white,
        secondary: AppColors.ashGray,
        onSecondary: AppColors.darkTextCream,
        error: AppColors.softTerracotta,
        onError: Colors.white,
        surface: AppColors.warmBlack,
        onSurface: AppColors.darkTextCream,
        background: AppColors.warmBlack,
        onBackground: AppColors.darkTextCream,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.headingLarge.copyWith(color: AppColors.darkTextCream),
        titleMedium: AppTypography.headingMedium.copyWith(color: AppColors.darkTextCream),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextCream),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextCream),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.darkTextCream),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.darkTextCream),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.darkTextCream),
      ),
      cardTheme: const CardTheme(
        color: AppColors.darkWarm,
        elevation: 2,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextCream),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.ashGray,
        thickness: 0.5,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkTextCream,
      ),
    );
  }
}
