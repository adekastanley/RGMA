import 'package:flutter/material.dart';

/// Official Rhema Go color palette combining the Rhema Nigeria Web Portal
/// brand identity (Deep Navy, Warm Gold, Active Coral, Clean Slate) with
/// modern mobile UI contrast.
class AppColors {
  AppColors._();

  // Core Light Canvas & Card Surfaces (matching Rhema Web Portal main canvas)
  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFEEF2F8);
  static const Color surfaceGlass = Color(0xF2FFFFFF);

  // Rhema Deep Navy Surfaces (used for Hero cards, Onboarding base, Player & Floating Docks)
  static const Color rhemaNavy = Color(0xFF132238);
  static const Color rhemaNavyDark = Color(0xFF0B1524);
  static const Color rhemaNavyElevated = Color(0xFF1D314F);
  static const Color rhemaNavyBorder = Color(0xFF2A4368);

  // Primary Brand Accent — Rhema Warm Gold / Amber
  static const Color rhemaGold = Color(0xFFE5A93C);
  static const Color rhemaGoldDark = Color(0xFFC68B22);
  static const Color rhemaGoldMuted = Color(0x24E5A93C);

  // Backward-compatible alias used by accent widgets
  static const Color accentLime = rhemaGold;
  static const Color accentLimeDark = rhemaGoldDark;
  static const Color accentLimeMuted = rhemaGoldMuted;

  // Web Portal Active Session Coral / Crimson Accent
  static const Color activeCoral = Color(0xFFE05344);
  static const Color activeCoralSurface = Color(0xFFFFF1F0);
  static const Color activeCoralBorder = Color(0xFFFFCCC7);

  // Typography Colors (on Light Canvas)
  static const Color textPrimary = Color(0xFF132238);
  static const Color textSecondary = Color(0xFF5A6B82);
  static const Color textMuted = Color(0xFF8C9BAE);

  // Typography Colors (on Deep Navy & Gold Surfaces)
  static const Color textOnNavy = Color(0xFFF8FAFC);
  static const Color textOnNavyMuted = Color(0xFFB4C2D4);
  static const Color textOnLime = Color(0xFF132238);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFEDF2F7);

  // Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
}
