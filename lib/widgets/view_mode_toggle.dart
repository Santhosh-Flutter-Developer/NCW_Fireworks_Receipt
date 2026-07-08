import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// A small segmented control letting the person switch a list screen
/// between the card "list view" (best for phones) and a scrollable
/// "table view" (mirrors the desktop web app).
class ViewModeToggle extends StatelessWidget {
  final bool isTableView;
  final ValueChanged<bool> onChanged;

  const ViewModeToggle({
    super.key,
    required this.isTableView,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment(
            icon: Icons.view_agenda_rounded,
            tooltip: 'List view',
            selected: !isTableView,
            onTap: () => onChanged(false),
          ),
          _segment(
            icon: Icons.table_rows_rounded,
            tooltip: 'Table view',
            selected: isTableView,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required IconData icon,
    required String tooltip,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.goldGradient : null,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 18,
            color: selected ? AppColors.textOnGold : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
