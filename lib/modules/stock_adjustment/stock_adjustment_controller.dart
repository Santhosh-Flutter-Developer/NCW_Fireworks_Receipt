import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/product_model.dart';
import '../../data/models/stock_adjustment_model.dart';

class StockAdjustmentController extends GetxController {
  final adjustments = <StockAdjustmentModel>[].obs;
  final products = DummyData.products();
  final searchQuery = ''.obs;
  final filterType = Rx<AdjustmentType?>(null);
  final isTableView = false.obs;

  // Form state
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  final Rx<AdjustmentType> adjustmentType = Rx<AdjustmentType>(
    AdjustmentType.addition,
  );
  final quantityCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();
  final Rx<DateTime> adjustmentDate = Rx<DateTime>(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    adjustments.assignAll(DummyData.stockAdjustments());
  }

  List<StockAdjustmentModel> get filtered {
    return adjustments.where((a) {
      final matchesQuery = searchQuery.value.isEmpty ||
          a.productName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          a.refNo.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesType =
          filterType.value == null || a.type == filterType.value;
      return matchesQuery && matchesType;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void setSearch(String value) => searchQuery.value = value;
  void setTypeFilter(AdjustmentType? type) {
    filterType.value = filterType.value == type ? null : type;
  }
  void toggleViewMode(bool table) => isTableView.value = table;

  void startCreate() {
    selectedProduct.value = null;
    adjustmentType.value = AdjustmentType.addition;
    quantityCtrl.clear();
    reasonCtrl.clear();
    adjustmentDate.value = DateTime.now();
  }

  bool save() {
    final product = selectedProduct.value;
    final qty = int.tryParse(quantityCtrl.text) ?? 0;

    if (product == null) {
      Get.snackbar('Missing product', 'Please select a product',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (qty <= 0) {
      Get.snackbar('Invalid quantity', 'Enter a quantity greater than 0',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final before = product.currentStock;
    int after;
    switch (adjustmentType.value) {
      case AdjustmentType.addition:
      case AdjustmentType.correction:
        after = before + qty;
        break;
      case AdjustmentType.reduction:
      case AdjustmentType.damage:
        after = before - qty;
        break;
    }
    if (after < 0) after = 0;
    product.currentStock = after;

    adjustments.insert(
      0,
      StockAdjustmentModel(
        id: 'SA${(adjustments.length + 1).toString().padLeft(3, '0')}',
        refNo: 'ADJ-2026-${(adjustments.length + 1).toString().padLeft(3, '0')}',
        productId: product.id,
        productName: product.name,
        date: adjustmentDate.value,
        type: adjustmentType.value,
        quantity: qty,
        stockBefore: before,
        stockAfter: after,
        reason: reasonCtrl.text.trim(),
      ),
    );

    Get.back();
    Get.snackbar('Saved', 'Stock adjustment recorded successfully',
        snackPosition: SnackPosition.BOTTOM);
    return true;
  }

  void deleteAdjustment(StockAdjustmentModel adjustment) {
    adjustments.remove(adjustment);
    Get.snackbar('Deleted', '${adjustment.refNo} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    quantityCtrl.dispose();
    reasonCtrl.dispose();
    super.onClose();
  }
}
