import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// A themed, horizontally-scrollable data table used by every list screen's
/// "table view" — mirrors the desktop web app's tables while staying usable
/// on narrow screens via horizontal scroll.
class AppDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final double columnSpacing;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              MaterialStateProperty.all(AppColors.surfaceElevated),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columnSpacing: columnSpacing,
          horizontalMargin: 16,
          columns: columns
              .map(
                (c) => DataColumn(
                  label: Text(
                    c,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
          rows: rows
              .map(
                (cells) => DataRow(
                  cells: cells.map((w) => DataCell(w)).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// A small YES/NO or status-style pill used inside table cells,
/// matching the green "YES" pills on the web app.
class TablePill extends StatelessWidget {
  final String label;
  final Color color;

  const TablePill({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
