import 'package:flutter/material.dart';

/// NCW Fireworks color palette — inspired by a night sky lit up
/// with fireworks: gold, ember-orange, magenta, and teal burst accents
/// over either a deep midnight background (dark mode) or a soft warm
/// off-white background (light mode).
///
/// All members are runtime getters (not `const`) so the whole app can
/// flip between palettes by toggling [AppColors.isDark] and calling
/// `Get.forceAppUpdate()` — see `ThemeController`.
class AppColors {
  AppColors._();

  /// Current active palette. Defaults to dark. Toggled by ThemeController.
  static bool isDark = true;

  // Base / background
  static Color get midnight =>
      isDark ? const Color(0xFF0B0F1F) : const Color(0xFFF7F6FB);
  static Color get midnightDeep =>
      isDark ? const Color(0xFF060812) : const Color(0xFFFFFFFF);
  static Color get surface =>
      isDark ? const Color(0xFF141B2E) : const Color(0xFFFFFFFF);
  static Color get surfaceElevated =>
      isDark ? const Color(0xFF1C2440) : const Color(0xFFF1F1F8);
  static Color get surfaceHigh =>
      isDark ? const Color(0xFF232C4D) : const Color(0xFFE7E8F3);
  static Color get divider =>
      isDark ? const Color(0xFF2A3358) : const Color(0xFFE3E4EF);

  // Accents — firework bursts (kept close across themes for brand cohesion)
  static Color get gold =>
      isDark ? const Color(0xFFFFC24B) : const Color(0xFFE6A400);
  static Color get goldDeep =>
      isDark ? const Color(0xFFE6A400) : const Color(0xFFC98700);
  static Color get ember =>
      isDark ? const Color(0xFFFF6A3D) : const Color(0xFFF25A2C);
  static Color get emberDeep =>
      isDark ? const Color(0xFFFF4438) : const Color(0xFFE23327);
  static Color get magenta =>
      isDark ? const Color(0xFFC24BFF) : const Color(0xFFA632E0);
  static Color get teal =>
      isDark ? const Color(0xFF3DD9C6) : const Color(0xFF1FB3A0);
  static Color get skyBlue =>
      isDark ? const Color(0xFF4B9CFF) : const Color(0xFF2E7CE0);

  // Status
  static Color get success =>
      isDark ? const Color(0xFF39D98A) : const Color(0xFF1E9E63);
  static Color get warning => gold;
  static Color get danger =>
      isDark ? const Color(0xFFFF5A6E) : const Color(0xFFE0374D);
  static Color get info => skyBlue;

  // Text
  static Color get textPrimary =>
      isDark ? const Color(0xFFF5F7FF) : const Color(0xFF1A1F36);
  static Color get textSecondary =>
      isDark ? const Color(0xFFAEB6D6) : const Color(0xFF5B6178);
  static Color get textMuted =>
      isDark ? const Color(0xFF7783AD) : const Color(0xFF9199B5);
  static Color get textOnGold => const Color(0xFF201200);

  // Gradients
  static LinearGradient get goldGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gold, emberDeep],
      );

  static LinearGradient get emberGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ember, emberDeep],
      );

  static LinearGradient get magentaGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [magenta, isDark ? const Color(0xFF6A2FE0) : const Color(0xFF7E22C7)],
      );

  static LinearGradient get tealGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [teal, isDark ? const Color(0xFF1F9E9E) : const Color(0xFF157F7F)],
      );

  static LinearGradient get skyGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [skyBlue, isDark ? const Color(0xFF2A63C7) : const Color(0xFF1F51A8)],
      );

  static LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [midnightDeep, midnight],
      );

  static RadialGradient get burstGlow => RadialGradient(
        colors: [gold.withOpacity(0.2), gold.withOpacity(0)],
        radius: 0.9,
      );
}
