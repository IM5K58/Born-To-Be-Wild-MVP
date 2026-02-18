import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0F14); // Dark Charcoal
  static const Color surface = Color(0xFF1A1F25); // Slightly lighter
  static const Color primary = Color(0xFFFF3B30); // Red (Failure/Core)
  static const Color secondary = Color(0xFF32D74B); // Green (Success/Pass)
  static const Color textMain = Color(0xFFFFFFFF);
  static const Color textSub = Color(0xFF8E8E93);
  static const Color locked = Color(0xFF64D2FF); // Blue (Locked Deposit)

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        onBackground: textMain,
        onSurface: textMain,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w900, // Brutal
          color: textMain,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textMain,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSub,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          // For numbers/timers
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textMain, // Text Color
          shape: const BeveledRectangleBorder(), // Sharp edges (Brutal)
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        shape: BeveledRectangleBorder(), // Sharp edges
        elevation: 0,
        margin: EdgeInsets.all(0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
      ),
    );
  }
}
