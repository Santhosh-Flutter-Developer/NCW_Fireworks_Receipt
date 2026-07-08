import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/billing_item_model.dart' show DocStatus;
import '../../data/models/stock_adjustment_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_data_table.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/view_mode_toggle.dart';
import 'stock_adjustment_controller.dart';

class StockAdjustmentListView extends GetView<StockAdjustmentController> {
  const StockAdjustmentListView({super.key});

  static final _df = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      routeName: AppRoutes.stockAdjustmentList,
      title: 'Stock Adjustment',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.startCreate();
          Get.toNamed(AppRoutes.stockAdjustmentForm);
        },
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.textOnGold,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterBar(controller: controller, df: _df),
            const SizedBox(height: 14),
            Obx(() => _TabBar(
                  active: controller.activeTab.value,
                  onChanged: controller.setTab,
                )),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PageSizeSelector(controller: controller),
                Obx(
                  () => ViewModeToggle(
                    isTableView: controller.isTableView.value,
                    onChanged: controller.toggleViewMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final list = controller.pagedFiltered;
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: EmptyState(
                    icon: Icons.tune_rounded,
                    title: 'No adjustments found',
                    subtitle: 'Record a stock adjustment to get started.',
                  ),
                );
              }
              return controller.isTableView.value
                  ? _AdjustmentTable(list: list, controller: controller)
                  : Column(
                      children: List.generate(list.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AdjustmentTile(
                            adjustment: list[i],
                            controller: controller,
                          ),
                        );
                      }),
                    );
            }),
            const SizedBox(height: 14),
            _Pager(controller: controller),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filters: From Date / To Date / Bill No. search
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  final StockAdjustmentController controller;
  final DateFormat df;
  const _FilterBar({required this.controller, required this.df});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 160,
          child: Obx(() => _DateField(
                label: 'From Date',
                date: controller.filterFrom.value,
                df: df,
                onTap: () => _pickDate(context, controller.filterFrom.value,
                    controller.setDateFrom),
              )),
        ),
        SizedBox(
          width: 160,
          child: Obx(() => _DateField(
                label: 'To Date',
                date: controller.filterTo.value,
                df: df,
                onTap: () => _pickDate(
                    context, controller.filterTo.value, controller.setDateTo),
              )),
        ),
        SizedBox(
          width: 220,
          child: SearchField(
            hint: 'Bill No. Search',
            onChanged: controller.setSearch,
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime? current,
      ValueChanged<DateTime?> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) onPicked(picked);
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final DateFormat df;
  final VoidCallback onTap;
  const _DateField(
      {required this.label,
      required this.date,
      required this.df,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 14, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? df.format(date!) : label,
                style: AppTextStyles.body.copyWith(
                  color: date != null
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active / Draft / Cancel tabs
// ---------------------------------------------------------------------------

class _TabBar extends StatelessWidget {
  final StockAdjustmentTab active;
  final ValueChanged<StockAdjustmentTab> onChanged;
  const _TabBar({required this.active, required this.onChanged});

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
        children: StockAdjustmentTab.values.map((tab) {
          final selected = tab == active;
          return InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: () => onChanged(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                gradient: selected ? AppColors.goldGradient : null,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      selected ? AppColors.textOnGold : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Entries-per-page selector
// ---------------------------------------------------------------------------

class _PageSizeSelector extends StatelessWidget {
  final StockAdjustmentController controller;
  const _PageSizeSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: controller.pageSize.value,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                dropdownColor: AppColors.surfaceElevated,
                items: const [10, 25, 50, 100]
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.setPageSize(v);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('entries per page', style: AppTextStyles.caption),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Table view
// ---------------------------------------------------------------------------

class _AdjustmentTable extends StatelessWidget {
  final List<StockAdjustmentModel> list;
  final StockAdjustmentController controller;
  const _AdjustmentTable({required this.list, required this.controller});

  @override
  Widget build(BuildContext context) {
    final df = StockAdjustmentListView._df;
    final startIndex =
        (controller.currentPage.value - 1) * controller.pageSize.value;
    return AppDataTable(
      columns: const [
        'S.No',
        'Bill Date',
        'Bill Number',
        'Total Qty',
        'Remarks',
        'Action',
      ],
      rows: List.generate(list.length, (i) {
        final a = list[i];
        return [
          Text('${startIndex + i + 1}', style: AppTextStyles.body),
          Text(df.format(a.date), style: AppTextStyles.body),
          Text(a.billNo.isEmpty ? 'NULL' : a.billNo,
              style: AppTextStyles.bodyStrong),
          Text(a.qtyLabel(), style: AppTextStyles.body),
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(a.remarks,
                    style: AppTextStyles.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('Creator : ${a.creator}', style: AppTextStyles.caption),
              ],
            ),
          ),
          _ActionIcons(adjustment: a, controller: controller),
        ];
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// List (card) view
// ---------------------------------------------------------------------------

class _AdjustmentTile extends StatelessWidget {
  final StockAdjustmentModel adjustment;
  final StockAdjustmentController controller;
  const _AdjustmentTile({required this.adjustment, required this.controller});

  @override
  Widget build(BuildContext context) {
    final df = StockAdjustmentListView._df;
    final isDraft = adjustment.status == DocStatus.draft;
    final canOpen = adjustment.status != DocStatus.cancelled;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: canOpen
            ? () {
                controller.startEdit(adjustment);
                Get.toNamed(AppRoutes.stockAdjustmentForm);
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isDraft) ...[
                    Icon(Icons.bookmark_rounded,
                        size: 16, color: AppColors.magenta),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      adjustment.billNo.isEmpty ? 'NULL' : adjustment.billNo,
                      style: AppTextStyles.bodyStrong,
                    ),
                  ),
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(df.format(adjustment.date), style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: 6),
              Text(adjustment.remarks, style: AppTextStyles.body),
              const SizedBox(height: 2),
              Text('Creator : ${adjustment.creator}',
                  style: AppTextStyles.caption),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text('Total Qty: ${adjustment.qtyLabel()}',
                      style: AppTextStyles.caption),
                ],
              ),
              const Divider(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: _ActionIcons(
                    adjustment: adjustment, controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row/card actions: print, download, edit, delete — vary by status,
// matching what's available for Active / Draft / Cancel bills on the web app.
// ---------------------------------------------------------------------------

class _ActionIcons extends StatelessWidget {
  final StockAdjustmentModel adjustment;
  final StockAdjustmentController controller;
  const _ActionIcons({required this.adjustment, required this.controller});

  void _notReady(String action) {
    Get.snackbar(action, 'Coming soon', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    final status = adjustment.status;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status != DocStatus.draft) ...[
          IconButton(
            tooltip: 'Print',
            visualDensity: VisualDensity.compact,
            onPressed: () => _notReady('Print'),
            icon: Icon(Icons.print_rounded, color: AppColors.ember, size: 18),
          ),
          IconButton(
            tooltip: 'Download',
            visualDensity: VisualDensity.compact,
            onPressed: () => _notReady('Download'),
            icon: Icon(Icons.file_download_rounded,
                color: AppColors.skyBlue, size: 18),
          ),
        ],
        if (status != DocStatus.cancelled)
          IconButton(
            tooltip: 'Edit',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              controller.startEdit(adjustment);
              Get.toNamed(AppRoutes.stockAdjustmentForm);
            },
            icon: Icon(Icons.edit_rounded, color: AppColors.teal, size: 18),
          ),
        IconButton(
          tooltip: 'Delete',
          visualDensity: VisualDensity.compact,
          onPressed: () => controller.deleteAdjustment(adjustment),
          icon: Icon(Icons.delete_outline_rounded,
              color: AppColors.danger, size: 18),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pagination footer
// ---------------------------------------------------------------------------

class _Pager extends StatelessWidget {
  final StockAdjustmentController controller;
  const _Pager({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.filtered.length;
      final pages = controller.totalPages(total);
      final page = controller.currentPage.value;
      final start =
          total == 0 ? 0 : (page - 1) * controller.pageSize.value + 1;
      final end = (start + controller.pageSize.value - 1).clamp(0, total);

      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          Text(
            total == 0
                ? 'Showing 0 entries'
                : 'Showing $start to $end of $total entries',
            style: AppTextStyles.caption,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: page > 1 ? () => controller.goToPage(1) : null,
                icon: const Icon(Icons.first_page_rounded, size: 18),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed:
                    page > 1 ? () => controller.goToPage(page - 1) : null,
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$page',
                    style: AppTextStyles.bodyStrong
                        .copyWith(color: AppColors.textOnGold)),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: page < pages
                    ? () => controller.goToPage(page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed:
                    page < pages ? () => controller.goToPage(pages) : null,
                icon: const Icon(Icons.last_page_rounded, size: 18),
              ),
            ],
          ),
        ],
      );
    });
  }
}
