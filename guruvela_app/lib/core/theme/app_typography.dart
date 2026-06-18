import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography ported from the web app: Montserrat for body/UI, Oswald for
/// display headings. We build a [TextTheme] from Google Fonts so the look
/// matches the website without bundling font files.
abstract final class AppTypography {
  AppTypography._();

  /// Display font (Oswald) — used for hero headlines.
  static TextStyle display({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double? height,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.oswald(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextTheme textTheme(Color textPrimary, Color textSecondary) {
    final base = GoogleFonts.montserratTextTheme();
    return base.copyWith(
      displayLarge: GoogleFonts.oswald(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -1,
        height: 1.05,
      ),
      displayMedium: GoogleFonts.oswald(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.oswald(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: textSecondary,
      ),
    );
  }
}
