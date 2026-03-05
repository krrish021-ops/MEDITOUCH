/// Nebula Dark Luxe Theme - Futuristic, Elegant, Immersive Design
/// No Pure White. Only Depth, Light, and Sophistication.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Core colors for Nebula Dark Luxe Theme
  static const Color bgDark1 = Color(0xFF0F0C29); // Deep Space
  static const Color bgDark2 = Color(0xFF302B63); // Cosmic Purple
  static const Color bgDark3 = Color(0xFF24243E); // Midnight Blue
  static const Color bgLight = Color(0xFF0F0C29); // Primary background
  static const Color bgCard = Color(0x990F0C29); // Frosted glass (60% opacity)
  static const Color bgCardLight = Color(
    0x660F0C29,
  ); // Lighter glass (40% opacity)
  static const Color primaryBlue = Color(0xFF00D1FF); // Electric Teal Glow
  static const Color secondaryBlue = Color(0xFFB388EB); // Soft Lavender Pulse
  static const Color textDark = Color(0xFFE0F7FA); // Crisp Light Cyan-White
  static const Color textLight = Color(0xCC80D0C7); // Dimmed Glow (80% opacity)
  static const Color chipBg = Color(0x4D00D1FF); // Teal with opacity
  static const Color errorRed = Color(0xFFFF6F61); // Neon Coral

  // Expose these for other parts of the app to use (backwards compatibility)
  static const Color bgDark = bgDark1;
  static const Color teal = primaryBlue;
  static const Color tealDark = Color(0xFF00A8CC);
  static const Color tealLight = Color(0xFF80E8FF);
  static const Color white = Color(0xFFE0F7FA); // No pure white - soft glow
  static const Color grey = textLight;
  static const Color greyLight = Color(0x8080D0C7);
  static const Color error = errorRed;

  // Additional theme colors
  static const Color accent = secondaryBlue; // Soft Lavender
  static const Color success = Color(0xFF00EFC4); // Emerald Pulse
  static const Color warning = Color(0xFFFF6F61); // Neon Coral

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark1,
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: bgCard,
        error: errorRed,
        onPrimary: bgDark1,
        onSecondary: textDark,
        onSurface: textDark,
        onError: textDark,
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme)
          .apply(bodyColor: textDark, displayColor: textDark)
          .copyWith(
            titleLarge: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textDark,
              letterSpacing: 1.5,
            ),
            titleMedium: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: textDark,
              letterSpacing: 1.5,
            ),
            bodyMedium: GoogleFonts.montserrat(fontSize: 14, color: textLight),
            bodyLarge: GoogleFonts.montserrat(fontSize: 16, color: textDark),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shadowColor: primaryBlue.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryBlue.withOpacity(0.2), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgCard,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: bgDark1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryBlue.withOpacity(0.2), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryBlue.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        hintStyle: GoogleFonts.montserrat(color: textLight, fontSize: 14),
        labelStyle: GoogleFonts.montserrat(color: textLight, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: bgDark1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          elevation: 0,
          shadowColor: primaryBlue.withOpacity(0.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBg,
        selectedColor: primaryBlue.withOpacity(0.3),
        labelStyle: GoogleFonts.montserrat(color: textDark, fontSize: 13),
        secondaryLabelStyle: GoogleFonts.montserrat(
          color: primaryBlue,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryBlue.withOpacity(0.2)),
        ),
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryBlue;
          return textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return primaryBlue.withOpacity(0.3);
          return chipBg;
        }),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: bgCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: primaryBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: primaryBlue.withOpacity(0.2), width: 1),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: bgCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  // Glassmorphic glow effect (for cards and surfaces)
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: primaryBlue.withOpacity(0.15),
          offset: const Offset(0, 0),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  // Floating FAB glow (pulsing effect)
  static List<BoxShadow> get fabGlow => [
        BoxShadow(
          color: primaryBlue.withOpacity(0.5),
          offset: const Offset(0, 0),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  // Gradient background for scaffold (deep space effect)
  static BoxDecoration get nebulaBackground => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgDark1, bgDark2, bgDark3],
          stops: const [0.0, 0.5, 1.0],
        ),
      );

  // Glassmorphic card decoration
  static BoxDecoration glassMorphicCard({
    double borderRadius = 20,
    double opacity = 0.6,
  }) =>
      BoxDecoration(
        color: Color.fromRGBO(15, 12, 41, opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: primaryBlue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: glassShadow,
      );

  // Text glow effect for active labels
  static Shadow get textGlow => Shadow(
        color: primaryBlue.withOpacity(0.13),
        blurRadius: 5,
      );
}
