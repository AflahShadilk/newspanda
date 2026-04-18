// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color bgPrimary    = Color(0xFF0A0A0F);
  static const Color bgSecondary  = Color(0xFF13131A);
  static const Color bgCard       = Color(0xFF1C1C27);
  static const Color bgCardHover  = Color(0xFF242433);
  static const Color accentPrimary  = Color(0xFF6C63FF);
  static const Color accentSecondary = Color(0xFF03DAC6);
  static const Color textPrimary   = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF9090A8);
  static const Color textMuted     = Color(0xFF555568);
  static const Color divider       = Color(0xFF2A2A3D);
  static const Color chipSelected  = Color(0xFF6C63FF);
  static const Color chipUnselected = Color(0xFF1C1C27);
  static const Color errorColor    = Color(0xFFFF5370);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      colorScheme: const ColorScheme.dark(
        background: bgPrimary,
        surface: bgSecondary,
        primary: accentPrimary,
        secondary: accentSecondary,
        error: errorColor,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 13, height: 1.5),
        labelSmall: TextStyle(color: textMuted, fontSize: 11),
      ),
      dividerColor: divider,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentPrimary,
      ),
    );
  }
}