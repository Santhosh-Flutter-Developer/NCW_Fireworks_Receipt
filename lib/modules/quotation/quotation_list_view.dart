import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/billing_item_model.dart';
import '../../data/models/quotation_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_data_table.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/view_mode_toggle.dart';
import 'quotation_controller.dart';

class QuotationListView extends GetView<QuotationController> {
  const QuotationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      routeName: AppRoutes.quotationList,
      title: 'Quotation',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.startCreate();
          Get.toNamed(AppRoutes.quotationForm);
        },
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.textOnGold,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Quotation'),
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
                    icon: Icons.request_quote_rounded,
                    title: 'No quotations found',
                    subtitle: 'Create a new quotation to get started.',
                  );
                }
                final df = DateFormat('dd MMM yyyy');
                if (controller.isTableView.value) {
                  return SingleChildScrollView(
                    child: AppDataTable(
                      columns: const [
                        'S.No',
                        'Quotation No',
                        'Party',
                        'Date',
                        'Valid Till',
                        'Status',
                        'Total',
                        'Action',
                      ],
                      rows: List.generate(list.length, (i) {
                        final q = list[i];
                        return [
                          Text('${i + 1}', style: AppTextStyles.body),
                          Text(q.quotationNo, style: AppTextStyles.bodyStrong),
                          SizedBox(
                            width: 160,
                            child: Text(q.partyName,
                                style: AppTextStyles.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(df.format(q.date), style: AppTextStyles.body),
                          Text(df.format(q.validTill), style: AppTextStyles.body),
                          StatusBadge(status: q.status),
                          Text('₹${q.total.toStringAsFixed(0)}',
                              style: AppTextStyles.bodyStrong
                                  .copyWith(color: AppColors.gold)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  controller.startEdit(q);
                                  Get.toNamed(AppRoutes.quotationForm);
                                },
                                icon: Icon(Icons.edit_rounded,
                                    color: AppColors.teal, size: 18),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => controller.deleteQuotation(q),
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
                    final q = list[index];
                    return _QuotationTile(
                      quotation: q,
                      onTap: () {
                        controller.startEdit(q);
                        Get.toNamed(AppRoutes.quotationForm);
                      },
                      onDelete: () => controller.deleteQuotation(q),
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

class _QuotationTile extends StatelessWidget {
  final QuotationModel quotation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _QuotationTile({
    required this.quotation,
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
                    child: Text(quotation.quotationNo,
                        style: AppTextStyles.bodyStrong),
                  ),
                  StatusBadge(status: quotation.status),
                  IconButton(
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.delete_outline_rounded,
                        color: AppColors.textMuted, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(quotation.partyName, style: AppTextStyles.body),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(df.format(quotation.date), style: AppTextStyles.caption),
                  const SizedBox(width: 14),
                  Icon(Icons.event_busy_rounded,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text('Valid till ${df.format(quotation.validTill)}',
                      style: AppTextStyles.caption),
                  const Spacer(),
                  Text('₹${quotation.total.toStringAsFixed(0)}',
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
