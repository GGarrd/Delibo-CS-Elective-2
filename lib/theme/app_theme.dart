import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const bananaYellow = Color(0xFFFFD600);
  static const monkeyBrown  = Color(0xFF5D4037);
  static const darkBrown    = Color(0xFF3E2000);
  static const creamBg      = Color(0xFFFFFDE7);
  static const darkBg       = Color(0xFF1C1000);
  static const darkSurface  = Color(0xFF2C1A00);
  static const darkText     = Color(0xFFFFF9C4);

  // ── Light Theme ───────────────────────────────────────────────────────────
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: bananaYellow,
      brightness: Brightness.light,
    ).copyWith(
      primary: bananaYellow,
      onPrimary: darkBrown,
      secondary: monkeyBrown,
      onSecondary: Colors.white,
      // tertiary = accent text color (price, highlights) in light mode
      tertiary: darkBrown,
      surface: Colors.white,
      onSurface: darkBrown,
    ),
    scaffoldBackgroundColor: creamBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: bananaYellow,
      foregroundColor: darkBrown,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: darkBrown,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkBrown),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bananaYellow,
        foregroundColor: darkBrown,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge:  TextStyle(fontWeight: FontWeight.bold, color: darkBrown),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: darkBrown),
      bodyLarge:   TextStyle(color: darkBrown),
      bodyMedium:  TextStyle(color: monkeyBrown),
      labelLarge:  TextStyle(fontWeight: FontWeight.bold, color: darkBrown),
    ),
  );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: bananaYellow,
      brightness: Brightness.dark,
    ).copyWith(
      primary: bananaYellow,
      onPrimary: darkBrown,
      secondary: const Color(0xFFFFE57F),
      // tertiary = accent text color (price, highlights) in dark mode
      tertiary: bananaYellow,
      surface: darkSurface,
      onSurface: darkText,
    ),
    scaffoldBackgroundColor: darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: bananaYellow,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: bananaYellow,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: bananaYellow),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bananaYellow,
        foregroundColor: darkBrown,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge:  TextStyle(fontWeight: FontWeight.bold, color: darkText),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: darkText),
      bodyLarge:   TextStyle(color: darkText),
      bodyMedium:  TextStyle(color: Color(0xFFFFE57F)),
      labelLarge:  TextStyle(fontWeight: FontWeight.bold, color: darkText),
    ),
  );
}