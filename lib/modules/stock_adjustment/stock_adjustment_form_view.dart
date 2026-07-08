import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/product_model.dart';
import '../../data/models/stock_adjustment_model.dart';
import '../../widgets/common_widgets.dart';
import 'stock_adjustment_controller.dart';

class StockAdjustmentFormView extends GetView<StockAdjustmentController> {
  const StockAdjustmentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(title: const Text('New Stock Adjustment')),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
            children: [
              const SectionLabel(text: 'Product'),
              Obx(() => _productSelector(context)),
              Obx(() {
                final p = controller.selectedProduct.value;
                if (p == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2_rounded,
                          size: 16, color: AppColors.gold),
                      const SizedBox(width: 8),
                      Text('Current stock: ${p.currentStock} ${p.unit}',
                          style: AppTextStyles.caption),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              const SectionLabel(text: 'Adjustment Type'),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AdjustmentType.values.map((t) {
                    final selected = controller.adjustmentType.value == t;
                    return GestureDetector(
                      onTap: () => controller.adjustmentType.value = t,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: selected ? AppColors.goldGradient : null,
                          color: selected ? null : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          t.label,
                          style: AppTextStyles.bodyStrong.copyWith(
                            color: selected
                                ? AppColors.textOnGold
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel(text: 'Quantity'),
              TextField(
                controller: controller.quantityCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Enter quantity'),
              ),
              const SizedBox(height: 20),
              Obx(() => _dateTile(
                    date: controller.adjustmentDate.value,
                    df: df,
                    onTap: () => _pickDate(context),
                  )),
              const SizedBox(height: 20),
              const SectionLabel(text: 'Reason / Notes'),
              TextField(
                controller: controller.reasonCtrl,
                maxLines: 3,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g. Damaged during transit, purchase received...',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.save,
              child: const Text('Save Adjustment'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productSelector(BuildContext context) {
    final selected = controller.selectedProduct.value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openProductPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?.name ?? 'Select a product',
                style: AppTextStyles.body.copyWith(
                  color: selected != null
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _dateTile({
    required DateTime date,
    required DateFormat df,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 16, color: AppColors.gold),
            const SizedBox(width: 10),
            Text('Date: ${df.format(date)}', style: AppTextStyles.bodyStrong),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.adjustmentDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) controller.adjustmentDate.value = picked;
  }

  void _openProductPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(18),
        constraints: BoxConstraints(maxHeight: Get.height * 0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Product', style: AppTextStyles.h3),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.products.length,
                itemBuilder: (context, i) {
                  final ProductModel p = controller.products[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: p.needsAttention
                            ? AppColors.emberGradient
                            : AppColors.tealGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.celebration_rounded,
                          color: Colors.white, size: 18),
                    ),
                    title: Text(p.name, style: AppTextStyles.bodyStrong),
                    subtitle: Text('Stock: ${p.currentStock} ${p.unit}',
                        style: AppTextStyles.caption),
                    onTap: () {
                      controller.selectedProduct.value = p;
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
