import 'package:flutter/material.dart';

/// Centralized color palette ported from the web app's `tailwind.config.js`.
///
/// Keeping every hard-coded color here (rather than scattered through widgets)
/// is what lets the light/dark [AppTheme] stay consistent and tweakable.
abstract final class AppColors {
  AppColors._();

  // ---- Brand: Primary (Cobalt blue) ----
  static const Color primary = Color(0xFF0047AB);
  static const Color primaryDark = Color(0xFF003380);
  static const Color primaryLight = Color(0xFF3373E0);

  // ---- Brand: Accent (Sky blue) ----
  static const Color accent = Color(0xFF0EA5E9);
  static const Color accentHover = Color(0xFF0284C7);

  // ---- Neutral (Slate) scale ----
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // ---- Semantic ----
  static const Color success = Color(0xFF10B981); // emerald (FAQ badge)
  static const Color warning = Color(0xFFEAB308); // amber (banners)
  static const Color danger = Color(0xFFDC2626); // red (errors)
  static const Color linkedIn = Color(0xFF0A66C2);

  // ---- Probability badge colors ----
  static const Color probHigh = primary;
  static const Color probMedium = Color(0xFFDBEAFE); // blue-100
  static const Color probMediumText = Color(0xFF1E40AF); // blue-800
  static const Color probLow = Color(0xFFFEF2F2); // red-50
  static const Color probLowText = Color(0xFFB91C1C); // red-700

  // ---- Light scheme surfaces ----
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = gray50;
  static const Color lightBorder = gray200;
  static const Color lightTextPrimary = gray900;
  static const Color lightTextSecondary = gray600;
  static const Color lightTextMuted = gray500;

  // ---- Dark scheme surfaces ----
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111A2B);
  static const Color darkSurfaceVariant = Color(0xFF1B273B);
  static const Color darkBorder = Color(0xFF2A3850);
  static const Color darkTextPrimary = Color(0xFFE6ECF5);
  static const Color darkTextSecondary = Color(0xFFB6C2D6);
  static const Color darkTextMuted = Color(0xFF8896AE);
  // On dark surfaces a slightly brighter blue reads better than the deep cobalt.
  static const Color darkPrimary = Color(0xFF4D8DF0);
}
