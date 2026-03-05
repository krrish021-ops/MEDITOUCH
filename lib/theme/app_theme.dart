/// MEDITOUCH – Vivid Dark Health-Tech Theme
/// Deep space background with pops of Electric Blue, Neon Green,
/// Vivid Orange, Radiant Pink. Glassmorphism, glowing accents, gradients.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Color Palette (from README) ───────────────────────────────────
  static const Color bgPrimary = Color(0xFF181A20); // Charcoal Black
  static const Color bgSecondary = Color(0xFF23243A); // Deep Slate
  static const Color electricBlue = Color(0xFF00B4FF);
  static const Color neonGreen = Color(0xFF00FFB0);
  static const Color vividOrange = Color(0xFFFF8C42);
  static const Color radiantPink = Color(0xFFFF4F8B);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3C6);
  static const Color glassWhite = Color(0x14FFFFFF); // ~8 % white
  static const Color glassBorder = Color(0x30FFFFFF); // subtle border

  // Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [electricBlue, radiantPink],
  );
  static const LinearGradient greenBlueGradient = LinearGradient(
    colors: [neonGreen, electricBlue],
  );
  static const LinearGradient orangePinkGradient = LinearGradient(
    colors: [vividOrange, radiantPink],
  );

  // ─── Backwards-Compat Aliases ──────────────────────────────────────
  static const Color bgDark = bgPrimary;
  static const Color bgDark1 = bgPrimary;
  static const Color bgDark2 = bgSecondary;
  static const Color bgDark3 = Color(0xFF1E1F30);
  static const Color bgLight = bgPrimary;
  static const Color bgCard = Color(0x14FFFFFF);
  static const Color bgCardLight = Color(0x0CFFFFFF);
  static const Color primaryBlue = electricBlue;
  static const Color teal = electricBlue;
  static const Color tealDark = Color(0xFF0090D0);
  static const Color tealLight = Color(0xFF66CFFF);
  static const Color white = textPrimary;
  static const Color grey = textSecondary;
  static const Color greyLight = Color(0x99B0B3C6);
  static const Color textDark = textPrimary;
  static const Color textLight = textSecondary;
  static const Color chipBg = Color(0x3300B4FF);
  static const Color errorRed = Color(0xFFFF4F8B);
  static const Color error = errorRed;
  static const Color accent = radiantPink;
  static const Color success = neonGreen;
  static const Color warning = vividOrange;
  static const Color secondaryBlue = Color(0xFF6C63FF);

  // ─── ThemeData ─────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: radiantPink,
        surface: bgSecondary,
        error: errorRed,
        onPrimary: bgPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
          .apply(bodyColor: textPrimary, displayColor: textPrimary)
          .copyWith(
            headlineLarge: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
            titleLarge: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            titleMedium: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
            bodyLarge: GoogleFonts.inter(fontSize: 16, color: textPrimary),
            bodyMedium: GoogleFonts.inter(fontSize: 14, color: textSecondary),
            labelLarge: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgPrimary,
        selectedItemColor: electricBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: electricBlue,
        foregroundColor: bgPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: glassBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: electricBlue, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricBlue,
          foregroundColor: bgPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBg,
        selectedColor: electricBlue.withValues(alpha: 0.3),
        labelStyle: GoogleFonts.inter(color: textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: glassBorder),
        ),
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return electricBlue;
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return electricBlue.withValues(alpha: 0.35);
          }
          return glassWhite;
        }),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: glassWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: glassBorder, width: 1),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  // ─── Decorations & Helpers ─────────────────────────────────────────

  /// Glassmorphic card decoration with blur-ready styling.
  static BoxDecoration glassCard({
    double borderRadius = 20,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: glassWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor ?? glassBorder, width: 1),
    );
  }

  /// Glowing box-shadow for accent-coloured elements.
  static List<BoxShadow> glow(Color c, {double blur = 20, double spread = 0}) {
    return [
      BoxShadow(
        color: c.withValues(alpha: 0.45),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  static List<BoxShadow> get fabGlow => glow(electricBlue, blur: 24, spread: 2);

  /// Full-screen gradient background.
  static BoxDecoration get scaffoldGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [bgPrimary, bgSecondary, bgPrimary],
      stops: [0.0, 0.5, 1.0],
    ),
  );
}
