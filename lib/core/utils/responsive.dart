import 'package:flutter/material.dart';

/// Simple responsive breakpoint helpers so the same screens adapt
/// gracefully from a small phone up to a tablet.
class Responsive {
  Responsive._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700;

  static bool isLargePhone(BuildContext context) =>
      MediaQuery.of(context).size.width >= 400;

  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Number of grid columns for stat cards / grids based on width.
  static int gridColumns(BuildContext context) {
    final w = width(context);
    if (w >= 900) return 4;
    if (w >= 700) return 3;
    if (w >= 420) return 2;
    return 2;
  }

  static double horizontalPadding(BuildContext context) {
    return isTablet(context) ? 32 : 18;
  }

  static double maxContentWidth(BuildContext context) {
    return isTablet(context) ? 960 : double.infinity;
  }
}
