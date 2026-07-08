import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/stock_adjustment_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_data_table.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/view_mode_toggle.dart';
import 'stock_adjustment_controller.dart';

class StockAdjustmentListView extends GetView<StockAdjustmentController> {
  const StockAdjustmentListView({super.key});

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
        label: const Text('New Adjustment'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              hint: 'Search by product or ref number',
              onChanged: controller.setSearch,
            ),
            const SizedBox(height: 14),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AdjustmentType.values.map((t) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChipToggle(
                        label: t.label,
                        selected: controller.filterType.value == t,
                        onTap: () => controller.setTypeFilter(t),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => ViewModeToggle(
                  isTableView: controller.isTableView.value,
                  onChanged: controller.toggleViewMode,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final list = controller.filtered;
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.tune_rounded,
                    title: 'No adjustments found',
                    subtitle: 'Record a stock adjustment to get started.',
                  );
                }
                final df = DateFormat('dd MMM yyyy');
                if (controller.isTableView.value) {
                  return SingleChildScrollView(
                    child: AppDataTable(
                      columns: const [
                        'S.No',
                        'Ref No',
                        'Product',
                        'Type',
                        'Qty',
                        'Before → After',
                        'Date',
                        'Action',
                      ],
                      rows: List.generate(list.length, (i) {
                        final a = list[i];
                        final isPositive = a.type == AdjustmentType.addition ||
                            a.type == AdjustmentType.correction;
                        return [
                          Text('${i + 1}', style: AppTextStyles.body),
                          Text(a.refNo, style: AppTextStyles.bodyStrong),
                          SizedBox(
                            width: 160,
                            child: Text(a.productName,
                                style: AppTextStyles.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          TablePill(
                            label: a.type.label,
                            color: isPositive
                                ? AppColors.teal
                                : AppColors.ember,
                          ),
                          Text(
                            '${isPositive ? '+' : '-'}${a.quantity}',
                            style: AppTextStyles.bodyStrong.copyWith(
                              color: isPositive
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                          Text('${a.stockBefore} → ${a.stockAfter}',
                              style: AppTextStyles.body),
                          Text(df.format(a.date), style: AppTextStyles.body),
                          IconButton(
                            tooltip: 'Delete',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => controller.deleteAdjustment(a),
                            icon: Icon(Icons.delete_outline_rounded,
                                color: AppColors.danger, size: 18),
                          ),
                        ];
                      }),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _AdjustmentTile(
                      adjustment: list[index],
                      onDelete: () =>
                          controller.deleteAdjustment(list[index]),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdjustmentTile extends StatelessWidget {
  final StockAdjustmentModel adjustment;
  final VoidCallback onDelete;

  const _AdjustmentTile({required this.adjustment, required this.onDelete});

  bool get _isPositive =>
      adjustment.type == AdjustmentType.addition ||
      adjustment.type == AdjustmentType.correction;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: _isPositive
                  ? AppColors.tealGradient
                  : AppColors.emberGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              _isPositive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(adjustment.productName, style: AppTextStyles.bodyStrong),
                const SizedBox(height: 3),
                Text(
                  '${adjustment.refNo} • ${df.format(adjustment.date)}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (_isPositive ? AppColors.teal : AppColors.ember)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    adjustment.type.label,
                    style: AppTextStyles.caption.copyWith(
                      color: _isPositive ? AppColors.teal : AppColors.ember,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_isPositive ? '+' : '-'}${adjustment.quantity}',
                style: AppTextStyles.bodyStrong.copyWith(
                  color: _isPositive ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${adjustment.stockBefore} → ${adjustment.stockAfter}',
                style: AppTextStyles.caption,
              ),
              IconButton(
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.delete_outline_rounded,
                    color: AppColors.textMuted, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
