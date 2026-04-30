import 'package:flutter/material.dart';
import '../../../constants/color_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(ColorConstants.primaryYellow),
        secondary: Color(ColorConstants.primaryOrange),
        surface: Color(ColorConstants.cardBackground),
        background: Color(ColorConstants.darkBackground),
        error: Color(ColorConstants.accentRed),
        onPrimary: Color(ColorConstants.darkBackground),
        onSecondary: Color(ColorConstants.darkBackground),
        onSurface: Color(ColorConstants.primaryText),
        onBackground: Color(ColorConstants.primaryText),
        onError: Color(ColorConstants.primaryText),
      ),
      scaffoldBackgroundColor: const Color(ColorConstants.darkBackground),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(ColorConstants.darkerBackground),
        foregroundColor: Color(ColorConstants.primaryText),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(ColorConstants.darkerBackground),
        selectedItemColor: Color(ColorConstants.primaryYellow),
        unselectedItemColor: Color(ColorConstants.secondaryText),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(ColorConstants.cardBackground),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(ColorConstants.primaryYellow),
          foregroundColor: const Color(ColorConstants.darkBackground),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(ColorConstants.primaryText)),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(ColorConstants.primaryText),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(ColorConstants.primaryText),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(ColorConstants.primaryText),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(ColorConstants.secondaryText),
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: Color(ColorConstants.primaryText),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(ColorConstants.primaryYellow),
        secondary: Color(ColorConstants.primaryOrange),
        surface: Color(0xFFFFFFFF),
        background: Color(0xFFFFFFFF),
        error: Color(ColorConstants.accentRed),
        onPrimary: Color(0xFF121212),
        onSecondary: Color(0xFF121212),
        onSurface: Color(0xFF121212),
        onBackground: Color(0xFF121212),
        onError: Color(0xFF121212),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        selectedItemColor: Color(ColorConstants.primaryYellow),
        unselectedItemColor: Color(0xFF757575),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Color(0xFF000000).withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(ColorConstants.primaryYellow),
          foregroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF121212)),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF121212),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF121212),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF121212),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF424242),
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: Color(0xFF121212),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

