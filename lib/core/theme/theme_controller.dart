import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'app_theme.dart';

/// Drives the light/dark switch for the whole app.
///
/// Widgets read colors from the mutable `AppColors` singleton rather than
/// `Theme.of(context)`, so a simple ThemeMode change isn't enough — we flip
/// `AppColors.isDark` and then force GetX to rebuild the entire navigator
/// stack via `Get.forceAppUpdate()` so every screen picks up the new palette.
class ThemeController extends GetxController {
  final isDarkMode = true.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _apply();
  }

  void setDarkMode(bool value) {
    if (isDarkMode.value == value) return;
    isDarkMode.value = value;
    _apply();
  }

  void _apply() {
    AppColors.isDark = isDarkMode.value;
    Get.changeTheme(AppTheme.current);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode.value ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            isDarkMode.value ? Brightness.dark : Brightness.light,
      ),
    );
    // Screens read AppColors directly (not via Theme.of(context)), so a
    // plain theme change doesn't repaint them — force a full rebuild.
    Get.forceAppUpdate();
  }
}
