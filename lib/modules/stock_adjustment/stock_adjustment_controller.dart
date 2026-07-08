import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/billing_item_model.dart' show DocStatus;
import '../../data/models/product_model.dart';
import '../../data/models/stock_adjustment_model.dart';

/// The 3 tabs shown above the Stock Adjustment list on the web app.
enum StockAdjustmentTab { active, draft, cancel }

extension StockAdjustmentTabX on StockAdjustmentTab {
  String get label {
    switch (this) {
      case StockAdjustmentTab.active:
        return 'Active';
      case StockAdjustmentTab.draft:
        return 'Draft';
      case StockAdjustmentTab.cancel:
        return 'Cancel';
    }
  }
}

class StockAdjustmentController extends GetxController {
  final adjustments = <StockAdjustmentModel>[].obs;
  final products = DummyData.products();

  // ---- List screen state ---------------------------------------------------
  final searchQuery = ''.obs;
  final activeTab = StockAdjustmentTab.active.obs;
  final isTableView = false.obs;
  final Rx<DateTime?> filterFrom =
      Rx<DateTime?>(DateTime.now().subtract(const Duration(days: 1)));
  final Rx<DateTime?> filterTo = Rx<DateTime?>(DateTime.now());
  final pageSize = 10.obs;
  final currentPage = 1.obs;

  // ---- Form state -----------------------------------------------------------
  StockAdjustmentModel? editingAdjustment;
  final Rx<DateTime> entryDate = Rx<DateTime>(DateTime.now());
  final remarksCtrl = TextEditingController();
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  final Rx<String?> selectedUnit = Rx<String?>(null);
  final qtyCtrl = TextEditingController();
  final Rx<StockAction?> selectedAction = Rx<StockAction?>(null);
  final formItems = <StockAdjustmentItem>[].obs;

  /// Number shown in the "Add Stock Adjustment - STA0XX/26-27" header the
  /// moment the form opens, before Submit actually reserves it.
  final previewBillNo = ''.obs;
  int _billCounter = 12; // continues on from the seeded STA011.

  @override
  void onInit() {
    super.onInit();
    adjustments.assignAll(DummyData.stockAdjustments());
  }

  @override
  void onClose() {
    remarksCtrl.dispose();
    qtyCtrl.dispose();
    super.onClose();
  }

  // ---- List filtering / pagination ------------------------------------------

  DocStatus get _tabStatus {
    switch (activeTab.value) {
      case StockAdjustmentTab.active:
        return DocStatus.active;
      case StockAdjustmentTab.draft:
        return DocStatus.draft;
      case StockAdjustmentTab.cancel:
        return DocStatus.cancelled;
    }
  }

  List<StockAdjustmentModel> get filtered {
    final list = adjustments.where((a) {
      final matchesTab = a.status == _tabStatus;
      final query = searchQuery.value.toLowerCase();
      final matchesQuery = query.isEmpty ||
          a.billNo.toLowerCase().contains(query) ||
          a.remarks.toLowerCase().contains(query);
      final matchesFrom = filterFrom.value == null ||
          !a.date.isBefore(DateTime(filterFrom.value!.year,
              filterFrom.value!.month, filterFrom.value!.day));
      final matchesTo = filterTo.value == null ||
          !a.date.isAfter(DateTime(filterTo.value!.year, filterTo.value!.month,
              filterTo.value!.day, 23, 59, 59));
      return matchesTab && matchesQuery && matchesFrom && matchesTo;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// The current page slice of [filtered], matching the "entries per page"
  /// selector + pager on the web app's Stock Adjustment list.
  List<StockAdjustmentModel> get pagedFiltered {
    final list = filtered;
    if (currentPage.value > totalPages(list.length)) {
      currentPage.value = 1;
    }
    final start = (currentPage.value - 1) * pageSize.value;
    if (start >= list.length) return [];
    final end = (start + pageSize.value).clamp(0, list.length);
    return list.sublist(start, end);
  }

  int totalPages(int count) =>
      count == 0 ? 1 : (count / pageSize.value).ceil();

  void setSearch(String value) {
    searchQuery.value = value;
    currentPage.value = 1;
  }

  void setTab(StockAdjustmentTab tab) {
    activeTab.value = tab;
    currentPage.value = 1;
  }

  void setDateFrom(DateTime? date) {
    filterFrom.value = date;
    currentPage.value = 1;
  }

  void setDateTo(DateTime? date) {
    filterTo.value = date;
    currentPage.value = 1;
  }

  void setPageSize(int size) {
    pageSize.value = size;
    currentPage.value = 1;
  }

  void goToPage(int page) {
    currentPage.value = page.clamp(1, totalPages(filtered.length));
  }

  void toggleViewMode(bool table) => isTableView.value = table;

  void cancelAdjustment(StockAdjustmentModel adjustment) {
    adjustment.status = DocStatus.cancelled;
    adjustments.refresh();
    Get.snackbar('Cancelled',
        '${adjustment.billNo.isEmpty ? 'Draft entry' : adjustment.billNo} was cancelled',
        snackPosition: SnackPosition.BOTTOM);
  }

  void deleteAdjustment(StockAdjustmentModel adjustment) {
    adjustments.remove(adjustment);
    Get.snackbar('Deleted',
        '${adjustment.billNo.isEmpty ? 'Draft entry' : adjustment.billNo} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  // ---- Form -------------------------------------------------------------

  double get formTotalQty =>
      formItems.fold(0.0, (sum, i) => sum + i.qty);

  void startCreate() {
    editingAdjustment = null;
    entryDate.value = DateTime.now();
    remarksCtrl.clear();
    selectedProduct.value = null;
    selectedUnit.value = null;
    qtyCtrl.clear();
    selectedAction.value = null;
    formItems.clear();
    previewBillNo.value = 'STA${_billCounter.toString().padLeft(3, '0')}/26-27';
  }

  void startEdit(StockAdjustmentModel adjustment) {
    editingAdjustment = adjustment;
    entryDate.value = adjustment.date;
    remarksCtrl.text = adjustment.remarks;
    selectedProduct.value = null;
    selectedUnit.value = null;
    qtyCtrl.clear();
    selectedAction.value = null;
    formItems.assignAll(adjustment.items.map((i) => StockAdjustmentItem(
          productId: i.productId,
          productName: i.productName,
          unit: i.unit,
          qty: i.qty,
          action: i.action,
        )));
    previewBillNo.value = adjustment.billNo.isNotEmpty
        ? adjustment.billNo
        : 'STA${_billCounter.toString().padLeft(3, '0')}/26-27';
  }

  /// The bill number shown in the form header right now, whichever mode
  /// the form is in.
  String get displayBillNo {
    final existing = editingAdjustment?.billNo;
    if (existing != null && existing.isNotEmpty) return existing;
    return previewBillNo.value;
  }

  void onProductSelected(ProductModel? product) {
    selectedProduct.value = product;
    selectedUnit.value = product?.unit;
  }

  void addItemToBill() {
    final product = selectedProduct.value;
    final unit = selectedUnit.value;
    final qty = double.tryParse(qtyCtrl.text.trim()) ?? 0;
    final action = selectedAction.value;

    if (product == null) {
      Get.snackbar('Missing product', 'Please select a product',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (unit == null) {
      Get.snackbar('Missing unit', 'Please select a unit',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (qty <= 0) {
      Get.snackbar('Invalid quantity', 'Enter a quantity greater than 0',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (action == null) {
      Get.snackbar('Missing action', 'Choose Add or Remove',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    formItems.insert(
      0,
      StockAdjustmentItem(
        productId: product.id,
        productName: product.name,
        unit: unit,
        qty: qty,
        action: action,
      ),
    );

    // Reset the entry row for the next product, keeping remarks/date as-is.
    selectedProduct.value = null;
    selectedUnit.value = null;
    qtyCtrl.clear();
    selectedAction.value = null;
  }

  void updateItemQty(int index, double qty) {
    if (qty <= 0) return;
    formItems[index].qty = qty;
    formItems.refresh();
  }

  void removeFormItem(int index) => formItems.removeAt(index);

  bool save({required bool asDraft}) {
    if (remarksCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing remarks', 'Please enter a remark',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (formItems.isEmpty) {
      Get.snackbar('No items', 'Add at least one product to the bill',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final status = asDraft ? DocStatus.draft : DocStatus.active;
    String assignedBillNo(String? current) {
      if (asDraft) return current ?? '';
      if (current != null && current.isNotEmpty) return current;
      final n = _billCounter++;
      return 'STA${n.toString().padLeft(3, '0')}/26-27';
    }

    if (editingAdjustment != null) {
      editingAdjustment!
        ..date = entryDate.value
        ..remarks = remarksCtrl.text.trim()
        ..items = formItems.toList()
        ..billNo = assignedBillNo(editingAdjustment!.billNo)
        ..status = status;
      adjustments.refresh();
    } else {
      adjustments.insert(
        0,
        StockAdjustmentModel(
          id: 'SA${(adjustments.length + 1).toString().padLeft(3, '0')}',
          billNo: assignedBillNo(null),
          date: entryDate.value,
          remarks: remarksCtrl.text.trim(),
          items: formItems.toList(),
          status: status,
        ),
      );
    }

    Get.back();
    Get.snackbar(
      asDraft ? 'Saved as draft' : 'Submitted',
      asDraft
          ? 'Stock adjustment saved as a draft'
          : 'Stock adjustment submitted successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    return true;
  }
}
