import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design system for the Emergency Alert Routing System.
///
/// All colors, text styles, spacings, and decorations are defined here
/// to ensure consistent UI across every screen and widget.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Color Palette
  // ---------------------------------------------------------------------------

  static const Color background   = Color(0xFF0A0D14); // Deep dark background
  static const Color surface      = Color(0xFF111827); // Card/container surface
  static const Color surfaceAlt   = Color(0xFF1A2235); // Slightly lighter surface
  static const Color borderColor  = Color(0xFF1E2D45); // Subtle borders

  // Emergency red palette
  static const Color alertRed     = Color(0xFFFF2D2D); // Primary alert red
  static const Color alertRedDark = Color(0xFFB71C1C); // Darker red
  static const Color alertRedGlow = Color(0x33FF2D2D); // Translucent red glow

  // Status colors
  static const Color safeGreen    = Color(0xFF00E676); // Safe / success green
  static const Color warningAmber = Color(0xFFFFAB00); // Warning amber
  static const Color infoBlue     = Color(0xFF2979FF); // Info / processing blue
  static const Color mutedGray    = Color(0xFF546E7A); // Muted / inactive

  // Text colors
  static const Color textPrimary   = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8899BB);
  static const Color textMuted     = Color(0xFF4A5568);

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static TextTheme get textTheme => GoogleFonts.interTextTheme(
    const TextTheme(
      displayLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
      headlineMedium:TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleMedium:   TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      titleSmall:    TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
      bodyLarge:     TextStyle(color: textPrimary),
      bodyMedium:    TextStyle(color: textSecondary),
      bodySmall:     TextStyle(color: textMuted),
      labelLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      labelMedium:   TextStyle(color: textSecondary, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall:    TextStyle(color: textMuted, letterSpacing: 0.5),
    ),
  );

  // ---------------------------------------------------------------------------
  // Material 3 Theme Data
  // ---------------------------------------------------------------------------

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary:      alertRed,
      secondary:    safeGreen,
      surface:      surface,
      error:        alertRed,
      onPrimary:    Colors.white,
      onSurface:    textPrimary,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderColor, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: alertRed,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: borderColor,
      thickness: 1,
    ),
  );

  // ---------------------------------------------------------------------------
  // Reusable Decorations
  // ---------------------------------------------------------------------------

  /// Standard card decoration with border.
  static BoxDecoration cardDecoration({Color? borderColor}) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: borderColor ?? AppTheme.borderColor,
      width: 1,
    ),
  );

  /// Alert/emergency glowing card with red glow.
  static BoxDecoration alertDecoration({double glowRadius = 12}) => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: alertRed.withOpacity(0.6), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: alertRed.withOpacity(0.15),
        blurRadius: glowRadius,
        spreadRadius: 1,
      ),
    ],
  );

  /// Safe/success card decoration with green glow.
  static BoxDecoration safeDecoration() => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: safeGreen.withOpacity(0.5), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: safeGreen.withOpacity(0.1),
        blurRadius: 12,
        spreadRadius: 1,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  static const double spacingXS  = 4.0;
  static const double spacingSM  = 8.0;
  static const double spacingMD  = 16.0;
  static const double spacingLG  = 24.0;
  static const double spacingXL  = 32.0;
  static const double spacingXXL = 48.0;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
}
