import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instakarm/features/home/domain/models/category.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF4F9DDE);
  static const Color _secondaryColor = Color(0xFFA76DFF);
  static const Color _backgroundColorLight = Color(0xFFF7F8FB);
  static const Color _errorColor = Color(0xFFF25F5C);

  // Centralized Category Colors
  static final Map<Category, Color> categoryColors = {
    Category.grounding: const Color(0xFFE53935),
    Category.creativity: const Color(0xFFFB8C00),
    Category.confidence: const Color(0xFFFDD835),
    Category.compassion: const Color(0xFF43A047),
    Category.expression: const Color(0xFF1E88E5),
    Category.intuition: const Color(0xFF5E35B1),
    Category.awareness: const Color(0xFF8E24AA),
  };

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _backgroundColorLight,
        error: _errorColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      scaffoldBackgroundColor: _backgroundColorLight,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  // Glassmorphism Card Decoration
  static BoxDecoration glassCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withAlpha(150), // Adjusted for a better glass effect
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Theme.of(context).colorScheme.surface.withAlpha(200),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}