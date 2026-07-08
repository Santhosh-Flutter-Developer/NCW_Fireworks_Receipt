import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import 'product_controller.dart';

class ProductFormView extends GetView<ProductController> {
  const ProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingProduct != null;
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
            children: [
              Text('Category *', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Obx(() => _dropdown(
                    value: controller.formCategory.value,
                    options: controller.categoryOptions,
                    onChanged: (v) => controller.formCategory.value = v,
                  )),
              const SizedBox(height: 16),
              _field(
                'Product Code',
                controller.codeCtrl,
                hint: 'e.g. SKU01',
                helper: 'Max Char: 5',
                maxLength: 5,
              ),
              _field(
                'Product Name *',
                controller.nameCtrl,
                hint: 'e.g. 6" Single Super Heroes Series',
                helper: 'Max Char: 50',
                maxLength: 50,
              ),
              Text('Unit *', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Obx(() => _dropdown(
                    value: controller.formUnit.value,
                    options: controller.unitOptions,
                    onChanged: (v) => controller.formUnit.value = v,
                  )),
              const SizedBox(height: 20),
              Obx(
                () => _toggleRow(
                  label: 'Stock Maintain',
                  value: controller.stockMaintain.value,
                  onChanged: (v) => controller.stockMaintain.value = v,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _toggleRow(
                  label: 'Negative Stock',
                  value: controller.negativeStock.value,
                  onChanged: (v) => controller.negativeStock.value = v,
                ),
              ),
              Obx(() {
                if (!controller.stockMaintain.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _field(
                    'Opening Stock',
                    controller.stockCtrl,
                    hint: '0',
                    helper: 'Starting stock quantity for this product',
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Text('Product Image (500 x 500)', style: AppTextStyles.h3),
                    const SizedBox(height: 14),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Get.snackbar(
                        'Image upload',
                        'Image upload will be available once the backend is connected.',
                        snackPosition: SnackPosition.BOTTOM,
                      ),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: AppColors.tealGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.cloud_upload_rounded,
                            color: Colors.white, size: 44),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload Size - 2 MB Only jpg & png',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
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
                  onPressed: () => controller.save(asDraft: true),
                  child: const Text('Draft'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.save(),
                  child: Text(isEditing ? 'Update' : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    String? helper,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(hintText: hint, counterText: ''),
          ),
          if (helper != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 2),
              child: Text(helper,
                  style: AppTextStyles.caption.copyWith(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Select',
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textMuted)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          dropdownColor: AppColors.surfaceElevated,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyStrong),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.gold,
          ),
        ],
      ),
    );
  }
}
