import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/billing_item_model.dart';
import '../../data/models/estimation_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_data_table.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/view_mode_toggle.dart';
import 'estimation_controller.dart';

class EstimationListView extends GetView<EstimationController> {
  const EstimationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      routeName: AppRoutes.estimationList,
      title: 'Estimation',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.startCreate();
          Get.toNamed(AppRoutes.estimationForm);
        },
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.textOnGold,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Estimation'),
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
              hint: 'Search by number or party',
              onChanged: controller.setSearch,
            ),
            const SizedBox(height: 14),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: DocStatus.values.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChipToggle(
                        label: s.label,
                        selected: controller.filterStatus.value == s,
                        onTap: () => controller.setStatusFilter(s),
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
                    icon: Icons.article_rounded,
                    title: 'No estimations found',
                    subtitle: 'Create a new estimation to get started.',
                  );
                }
                final df = DateFormat('dd MMM yyyy');
                if (controller.isTableView.value) {
                  return SingleChildScrollView(
                    child: AppDataTable(
                      columns: const [
                        'S.No',
                        'Estimation No',
                        'Party',
                        'Date',
                        'Status',
                        'Total',
                        'Action',
                      ],
                      rows: List.generate(list.length, (i) {
                        final e = list[i];
                        return [
                          Text('${i + 1}', style: AppTextStyles.body),
                          Text(e.estimationNo, style: AppTextStyles.bodyStrong),
                          SizedBox(
                            width: 160,
                            child: Text(e.partyName,
                                style: AppTextStyles.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(df.format(e.date), style: AppTextStyles.body),
                          StatusBadge(status: e.status),
                          Text('₹${e.total.toStringAsFixed(0)}',
                              style: AppTextStyles.bodyStrong
                                  .copyWith(color: AppColors.gold)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  controller.startEdit(e);
                                  Get.toNamed(AppRoutes.estimationForm);
                                },
                                icon: Icon(Icons.edit_rounded,
                                    color: AppColors.teal, size: 18),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => controller.deleteEstimation(e),
                                icon: Icon(Icons.delete_outline_rounded,
                                    color: AppColors.danger, size: 18),
                              ),
                            ],
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
                    final e = list[index];
                    return _EstimationTile(
                      estimation: e,
                      onTap: () {
                        controller.startEdit(e);
                        Get.toNamed(AppRoutes.estimationForm);
                      },
                      onDelete: () => controller.deleteEstimation(e),
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

class _EstimationTile extends StatelessWidget {
  final EstimationModel estimation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EstimationTile({
    required this.estimation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
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
                  Expanded(
                    child: Text(estimation.estimationNo,
                        style: AppTextStyles.bodyStrong),
                  ),
                  StatusBadge(status: estimation.status),
                  IconButton(
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.delete_outline_rounded,
                        color: AppColors.textMuted, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(estimation.partyName, style: AppTextStyles.body),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(df.format(estimation.date), style: AppTextStyles.caption),
                  const Spacer(),
                  Text('₹${estimation.total.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyStrong
                          .copyWith(color: AppColors.gold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
