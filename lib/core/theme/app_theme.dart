import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'Inter';

  // Seed colors for theme generation
  static const Color seedColorLight = Color(0xFF0F4C81); // Azul clásico premium
  static const Color seedColorDark = Color(0xFF1E88E5); // Azul más brillante para dark mode

  // Base background colors
  static const Color backgroundLight = Color(0xFFF8F9FA); // Fondo gris muy claro
  static const Color backgroundDark = Color(0xFF0A1628); // Fondo oscuro original del home

  // Surface colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF0F2442); // Tarjetas en modo oscuro

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColorLight,
        brightness: Brightness.light,
        surface: surfaceLight,
        background: backgroundLight,
      ),
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: seedColorLight,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColorDark,
        brightness: Brightness.dark,
        surface: surfaceDark,
        background: backgroundDark,
      ),
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
