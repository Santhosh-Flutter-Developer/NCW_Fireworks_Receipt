import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/product_model.dart';
import '../../data/models/stock_adjustment_model.dart';
import '../../widgets/app_data_table.dart';
import '../../widgets/common_widgets.dart';
import 'stock_adjustment_controller.dart';

/// Characters blocked in the Remarks field, matching the web app's
/// "Restricted char" note under Remarks.
final _restrictedCharsPattern = RegExp(r'[?!<>$+=`~|:^*(){}]');

class StockAdjustmentFormView extends GetView<StockAdjustmentController> {
  const StockAdjustmentFormView({super.key});

  static final _df = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingAdjustment != null;

    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        title: Text(
          '${isEditing ? 'Edit' : 'Add'} Stock Adjustment - '
          '${controller.displayBillNo}',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'The bill number is finalized once you Submit — '
                'drafts keep it reserved but unassigned.',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => Get.snackbar(
              'About the bill number',
              'The number shown is reserved for this entry. '
                  'It only becomes final once you tap Submit.',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 700;
              return ListView(
                padding: EdgeInsets.fromLTRB(
                  Responsive.horizontalPadding(context),
                  18,
                  Responsive.horizontalPadding(context),
                  140,
                ),
                children: [
                  wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _entryDateField(context)),
                            const SizedBox(width: 14),
                            Expanded(flex: 2, child: _remarksField()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _entryDateField(context),
                            const SizedBox(height: 16),
                            _remarksField(),
                          ],
                        ),
                  const SizedBox(height: 22),
                  const SectionLabel(text: 'Add Product to Bill'),
                  _AddItemRow(wide: wide),
                  const SizedBox(height: 22),
                  Center(
                    child: Obx(() => Text(
                          'Total Quantity : ${controller.formTotalQty == controller.formTotalQty.roundToDouble() ? controller.formTotalQty.toInt() : controller.formTotalQty.toStringAsFixed(2)}',
                          style: AppTextStyles.h2,
                        )),
                  ),
                  const SizedBox(height: 14),
                  Obx(() {
                    if (controller.formItems.isEmpty) {
                      return const EmptyState(
                        icon: Icons.playlist_add_rounded,
                        title: 'No products added yet',
                        subtitle:
                            'Select a product above and tap "Add To Bill".',
                      );
                    }
                    return _ItemsTable();
                  }),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.magenta,
                    side: BorderSide(color: AppColors.magenta),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => controller.save(asDraft: true),
                  child: const Text('DRAFT',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.save(asDraft: false),
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryDateField(BuildContext context) {
    return Obx(() {
      return _labeledTile(
        label: 'Entry Date *',
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                Text(_df.format(controller.entryDate.value),
                    style: AppTextStyles.bodyStrong),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _remarksField() {
    return _labeledTile(
      label: 'Remarks *',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.remarksCtrl,
            maxLines: 2,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              FilteringTextInputFormatter.deny(_restrictedCharsPattern),
            ],
            style:
                AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'e.g. checking'),
          ),
          const SizedBox(height: 4),
          Text(
            "Max Char : 50 (Restricted char : ? ! < > \$ + = ` ~ | : ^ * ( ) { })",
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.entryDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) controller.entryDate.value = picked;
  }

  static Widget _labeledTile({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Product / Unit / Qty / Stock Action row + "Add To Bill"
// ---------------------------------------------------------------------------

class _AddItemRow extends GetView<StockAdjustmentController> {
  final bool wide;
  const _AddItemRow({required this.wide});

  @override
  Widget build(BuildContext context) {
    final productField = Obx(() => _pickerTile(
          label: 'Product *',
          value: controller.selectedProduct.value?.name,
          onTap: () => _openProductPicker(context),
        ));
    final unitField = Obx(() => _pickerTile(
          label: 'Unit *',
          value: controller.selectedUnit.value,
          enabled: controller.selectedProduct.value != null,
          onTap: controller.selectedProduct.value == null
              ? null
              : () {
                  // A product currently only carries a single packing
                  // unit, so selecting it just confirms that unit.
                  controller.selectedUnit.value =
                      controller.selectedProduct.value!.unit;
                },
        ));
    final qtyField = TextField(
      controller: controller.qtyCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Qty *',
        hintText: 'Enter quantity',
        filled: true,
        fillColor: AppColors.surfaceElevated,
      ),
    );
    final actionField = Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<StockAction>(
              isExpanded: true,
              value: controller.selectedAction.value,
              hint: Text('Select',
                  style:
                      AppTextStyles.body.copyWith(color: AppColors.textMuted)),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted),
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              dropdownColor: AppColors.surfaceElevated,
              items: StockAction.values
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.label)))
                  .toList(),
              onChanged: (v) => controller.selectedAction.value = v,
            ),
          ),
        ));
    final addButton = SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
        ),
        onPressed: controller.addItemToBill,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Add To Bill'),
      ),
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Product *'),
          productField,
          const SizedBox(height: 12),
          _FieldLabel('Unit *'),
          unitField,
          const SizedBox(height: 12),
          qtyField,
          const SizedBox(height: 12),
          _FieldLabel('Action *'),
          actionField,
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: addButton),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_FieldLabel('Product *'), productField],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_FieldLabel('Unit *'), unitField],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: qtyField),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_FieldLabel('Action *'), actionField],
          ),
        ),
        const SizedBox(width: 10),
        addButton,
      ],
    );
  }

  Widget _pickerTile({
    required String label,
    required String? value,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? 'Select',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: value != null
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: enabled ? AppColors.textMuted : AppColors.divider),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      controller.onProductSelected(p);
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTextStyles.caption),
    );
  }
}

// ---------------------------------------------------------------------------
// Items already added to this bill — Product / Unit / QTY (editable) /
// Stock Action / delete, matching the web app's Edit Stock Adjustment table.
// ---------------------------------------------------------------------------

class _ItemsTable extends GetView<StockAdjustmentController> {
  const _ItemsTable();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.formItems;
      return AppDataTable(
        columns: const ['Product', 'Unit', 'QTY', 'Stock Action', 'Action'],
        rows: List.generate(items.length, (i) {
          final item = items[i];
          return [
            SizedBox(
              width: 180,
              child: Text(item.productName,
                  style: AppTextStyles.bodyStrong,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(item.unit, style: AppTextStyles.body),
            SizedBox(
              width: 70,
              child: TextFormField(
                initialValue: item.qty == item.qty.roundToDouble()
                    ? item.qty.toInt().toString()
                    : item.qty.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(isDense: true),
                onChanged: (v) {
                  final qty = double.tryParse(v);
                  if (qty != null) controller.updateItemQty(i, qty);
                },
              ),
            ),
            TablePill(
              label: item.action.label,
              color:
                  item.action.isAdd ? AppColors.teal : AppColors.ember,
            ),
            IconButton(
              tooltip: 'Remove',
              visualDensity: VisualDensity.compact,
              onPressed: () => controller.removeFormItem(i),
              icon: Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger, size: 18),
            ),
          ];
        }),
      );
    });
  }
}
