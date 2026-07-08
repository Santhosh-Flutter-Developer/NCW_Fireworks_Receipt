import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/party_model.dart';
import '../../data/models/product_model.dart';
import '../../widgets/common_widgets.dart';
import 'quotation_controller.dart';

class QuotationFormView extends GetView<QuotationController> {
  const QuotationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingQuotation != null;
    final df = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Quotation' : 'New Quotation'),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
            children: [
              const SectionLabel(text: 'Party'),
              Obx(() => _partySelector(context)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => _dateTile(
                          label: 'Quotation Date',
                          date: controller.quotationDate.value,
                          onTap: () => _pickDate(
                              context, controller.quotationDate, df),
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => _dateTile(
                          label: 'Valid Till',
                          date: controller.validTill.value,
                          onTap: () =>
                              _pickDate(context, controller.validTill, df),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: AppTextStyles.h3),
                  TextButton.icon(
                    onPressed: () => _openProductPicker(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.formItems.isEmpty) {
                  return const EmptyState(
                    icon: Icons.shopping_basket_outlined,
                    title: 'No items added',
                    subtitle: 'Tap "Add Item" to add products to this quotation.',
                  );
                }
                return Column(
                  children: List.generate(controller.formItems.length, (i) {
                    final item = controller.formItems[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    style: AppTextStyles.bodyStrong),
                                const SizedBox(height: 4),
                                Text('₹${item.rate.toStringAsFixed(0)} each',
                                    style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          _qtyStepper(
                            qty: item.quantity,
                            onDecrement: () => controller.updateQuantity(
                                i, item.quantity - 1),
                            onIncrement: () => controller.updateQuantity(
                                i, item.quantity + 1),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 64,
                            child: Text(
                              '₹${item.amount.toStringAsFixed(0)}',
                              textAlign: TextAlign.end,
                              style: AppTextStyles.bodyStrong,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.removeItem(i),
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.close_rounded,
                                size: 18, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 10),
              Obx(() => _summaryCard()),
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
              child: Text(isEditing ? 'Update Quotation' : 'Save Quotation'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _partySelector(BuildContext context) {
    final selected = controller.selectedParty.value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openPartyPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?.name ?? 'Select a party',
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
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final df = DateFormat('dd MMM yyyy');
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 14, color: AppColors.gold),
                const SizedBox(width: 6),
                Text(df.format(date), style: AppTextStyles.bodyStrong),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyStepper({
    required int qty,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded, size: 16),
          ),
          Text('$qty', style: AppTextStyles.bodyStrong),
          IconButton(
            onPressed: onIncrement,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _summaryRow('Sub Total', controller.formSubTotal),
          _summaryRow('Tax (5%)', controller.formTax),
          const Divider(color: Colors.white38, height: 20),
          _summaryRow('Total', controller.formTotal, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    final style = isBold
        ? AppTextStyles.h3.copyWith(color: AppColors.textOnGold)
        : AppTextStyles.body.copyWith(color: AppColors.textOnGold);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('₹${value.toStringAsFixed(0)}', style: style),
        ],
      ),
    );
  }

  Future<void> _pickDate(
      BuildContext context, Rx<DateTime> target, DateFormat df) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: target.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) target.value = picked;
  }

  void _openPartyPicker(BuildContext context) {
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
            Text('Select Party', style: AppTextStyles.h3),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.parties.length,
                itemBuilder: (context, i) {
                  final PartyModel p = controller.parties[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.surfaceHigh,
                      child: Text(p.initials,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textPrimary)),
                    ),
                    title: Text(p.name, style: AppTextStyles.bodyStrong),
                    subtitle: Text(p.phone, style: AppTextStyles.caption),
                    onTap: () {
                      controller.selectedParty.value = p;
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
                        gradient: AppColors.tealGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.celebration_rounded,
                          color: Colors.white, size: 18),
                    ),
                    title: Text(p.name, style: AppTextStyles.bodyStrong),
                    subtitle: Text('₹${p.price.toStringAsFixed(0)} / ${p.unit}',
                        style: AppTextStyles.caption),
                    onTap: () {
                      controller.addProductToForm(p);
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
