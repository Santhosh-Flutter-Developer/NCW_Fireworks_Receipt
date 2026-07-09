import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/billing_item_model.dart';
import '../../data/models/estimation_model.dart';
import '../../data/models/party_model.dart';
import '../../data/models/product_model.dart';

/// The 3 tabs shown above the Estimate list on the web app.
enum EstimationTab { active, draft, cancel }

extension EstimationTabX on EstimationTab {
  String get label {
    switch (this) {
      case EstimationTab.active:
        return 'Active';
      case EstimationTab.draft:
        return 'Draft';
      case EstimationTab.cancel:
        return 'Cancel';
    }
  }
}

class EstimationController extends GetxController {
  final estimations = <EstimationModel>[].obs;
  final parties = DummyData.parties();
  final products = DummyData.products();
  final agents = DummyData.agents;

  /// Charge types offered in the "Charges: Select / Value / +" row —
  /// mirrors the PACKING CHARGES / CASH DISCOUNT / TAX AMOUNT options
  /// on the web app. Discount-style charges are stored as negative values.
  static const chargeTypes = [
    'Packing Charges',
    'Cash Discount',
    'Tax Amount',
    'Transport Charges',
    'Other Charges',
  ];

  // ---- List screen state -------------------------------------------------
  final searchQuery = ''.obs;
  final activeTab = EstimationTab.active.obs;
  final isTableView = false.obs;
  final Rx<DateTime?> filterFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> filterTo = Rx<DateTime?>(null);
  final Rx<String?> filterAgent = Rx<String?>(null);
  final Rx<String?> filterParty = Rx<String?>(null);
  final pageSize = 10.obs;
  final currentPage = 1.obs;

  List<String> get pricelistNames {
    final names = <String>{};
    for (final p in products) {
      for (final entry in p.prices) {
        names.add(entry.pricelistName);
      }
    }
    return names.toList()..sort();
  }

  /// Current stock for a product, as shown by the "Stock : n" label on the
  /// web app's Add Estimate screen.
  int stockFor(String productId) =>
      products.firstWhereOrNull((p) => p.id == productId)?.currentStock ?? 0;

  // ---- Form state ---------------------------------------------------------
  EstimationModel? editingEstimation;
  final Rx<PartyModel?> selectedParty = Rx<PartyModel?>(null);
  final Rx<String?> selectedAgent = Rx<String?>(null);
  final Rx<String?> selectedPricelist = Rx<String?>(null);
  final Rx<DateTime> estimationDate = Rx<DateTime>(DateTime.now());
  final formItems = <BillingItemModel>[].obs;
  final section1Add = 0.0.obs;
  final section1Discount = 0.0.obs;
  final section2Add = 0.0.obs;
  final section2Discount = 0.0.obs;
  final charges = <ChargeLine>[].obs;
  final Rx<String?> selectedChargeType = Rx<String?>(null);
  final roundOff = 0.0.obs;

  // Persistent controllers so typing doesn't lose focus/cursor position
  // when the totals card rebuilds on every keystroke.
  final section1AddCtrl = TextEditingController();
  final section1DiscountCtrl = TextEditingController();
  final section2AddCtrl = TextEditingController();
  final section2DiscountCtrl = TextEditingController();
  final chargeValueCtrl = TextEditingController();
  final roundOffCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    estimations.assignAll(DummyData.estimations());
  }

  @override
  void onClose() {
    section1AddCtrl.dispose();
    section1DiscountCtrl.dispose();
    section2AddCtrl.dispose();
    section2DiscountCtrl.dispose();
    chargeValueCtrl.dispose();
    roundOffCtrl.dispose();
    super.onClose();
  }

  /// Pushes the current rx money values into their text controllers.
  /// Called only when the form is reset/loaded — never on every keystroke —
  /// so typing doesn't fight the controller or lose cursor position.
  void _syncMoneyControllers() {
    String fmt(double v) => v == 0 ? '' : v.toStringAsFixed(2);
    section1AddCtrl.text = fmt(section1Add.value);
    section1DiscountCtrl.text = fmt(section1Discount.value);
    section2AddCtrl.text = fmt(section2Add.value);
    section2DiscountCtrl.text = fmt(section2Discount.value);
    roundOffCtrl.text = fmt(roundOff.value);
  }

  // ---- List filtering / pagination ----------------------------------------

  DocStatus get _tabStatus {
    switch (activeTab.value) {
      case EstimationTab.active:
        return DocStatus.active;
      case EstimationTab.draft:
        return DocStatus.draft;
      case EstimationTab.cancel:
        return DocStatus.cancelled;
    }
  }

  List<EstimationModel> get filtered {
    final list = estimations.where((e) {
      final matchesTab = e.status == _tabStatus;
      final matchesQuery = searchQuery.value.isEmpty ||
          e.estimationNo
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
      final matchesAgent =
          filterAgent.value == null || e.agentName == filterAgent.value;
      final matchesParty =
          filterParty.value == null || e.partyName == filterParty.value;
      final matchesFrom = filterFrom.value == null ||
          !e.date.isBefore(DateTime(filterFrom.value!.year,
              filterFrom.value!.month, filterFrom.value!.day));
      final matchesTo = filterTo.value == null ||
          !e.date.isAfter(DateTime(filterTo.value!.year, filterTo.value!.month,
              filterTo.value!.day, 23, 59, 59));
      return matchesTab &&
          matchesQuery &&
          matchesAgent &&
          matchesParty &&
          matchesFrom &&
          matchesTo;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// The current page slice of [filtered], matching the "entries per page"
  /// selector + pager on the web app's Estimate list.
  List<EstimationModel> get pagedFiltered {
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

  void setTab(EstimationTab tab) {
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

  void setAgentFilter(String? agent) {
    filterAgent.value = agent;
    currentPage.value = 1;
  }

  void setPartyFilter(String? party) {
    filterParty.value = party;
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

  void cancelEstimation(EstimationModel estimation) {
    estimation.status = DocStatus.cancelled;
    estimations.refresh();
    Get.snackbar('Cancelled', '${estimation.estimationNo} was cancelled',
        snackPosition: SnackPosition.BOTTOM);
  }

  // ---- Form ----------------------------------------------------------------

  double get formSection1Total => formItems
      .where((i) => i.section == 1)
      .fold(0.0, (sum, i) => sum + i.amount);
  double get formSection2Total => formItems
      .where((i) => i.section == 2)
      .fold(0.0, (sum, i) => sum + i.amount);
  double get formSubTotal => formSection1Total + formSection2Total;
  double get formAdjustments =>
      (section1Add.value - section1Discount.value) +
      (section2Add.value - section2Discount.value);
  double get formChargesTotal =>
      charges.fold(0.0, (sum, c) => sum + c.value);
  double get formTotal =>
      formSubTotal + formAdjustments + formChargesTotal + roundOff.value;

  /// Adds a charge line from the currently selected charge type and typed
  /// value. "Cash Discount" is treated as a deduction (stored negative);
  /// everything else adds on top of the subtotal.
  void addCharge(double rawValue) {
    final type = selectedChargeType.value;
    if (type == null || rawValue == 0) {
      Get.snackbar('Select a charge', 'Choose a charge type and value',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final signedValue =
        type == 'Cash Discount' ? -rawValue.abs() : rawValue.abs();
    charges.add(ChargeLine(name: type, value: signedValue));
    selectedChargeType.value = null;
    chargeValueCtrl.clear();
  }

  void removeCharge(int index) => charges.removeAt(index);

  void startCreate() {
    editingEstimation = null;
    selectedParty.value = null;
    selectedAgent.value = null;
    selectedPricelist.value =
        pricelistNames.isNotEmpty ? pricelistNames.first : null;
    estimationDate.value = DateTime.now();
    formItems.clear();
    section1Add.value = 0;
    section1Discount.value = 0;
    section2Add.value = 0;
    section2Discount.value = 0;
    charges.clear();
    selectedChargeType.value = null;
    roundOff.value = 0;
    _syncMoneyControllers();
  }

  void startEdit(EstimationModel estimation) {
    editingEstimation = estimation;
    selectedParty.value = parties.firstWhereOrNull(
      (p) => p.id == estimation.partyId,
    );
    selectedAgent.value =
        estimation.agentName.isEmpty ? null : estimation.agentName;
    selectedPricelist.value = estimation.pricelistName.isEmpty
        ? (pricelistNames.isNotEmpty ? pricelistNames.first : null)
        : estimation.pricelistName;
    estimationDate.value = estimation.date;
    formItems.assignAll(estimation.items
        .map((i) => BillingItemModel(
              productId: i.productId,
              productName: i.productName,
              quantity: i.quantity,
              rate: i.rate,
              discountPercent: i.discountPercent,
              unit: i.unit,
              section: i.section,
            ))
        .toList());
    section1Add.value = estimation.section1Add;
    section1Discount.value = estimation.section1Discount;
    section2Add.value = estimation.section2Add;
    section2Discount.value = estimation.section2Discount;
    charges.assignAll(estimation.charges
        .map((c) => ChargeLine(name: c.name, value: c.value))
        .toList());
    selectedChargeType.value = null;
    roundOff.value = estimation.roundOff;
    _syncMoneyControllers();
  }

  void addProductToForm(ProductModel product, {int qty = 1, int section = 1}) {
    final existingIndex = formItems
        .indexWhere((i) => i.productId == product.id && i.section == section);
    if (existingIndex >= 0) {
      formItems[existingIndex].quantity += qty;
      formItems.refresh();
    } else {
      final rate = selectedPricelist.value != null
          ? (product.prices
                  .firstWhereOrNull(
                      (p) => p.pricelistName == selectedPricelist.value)
                  ?.price ??
              product.price)
          : product.price;
      formItems.add(BillingItemModel(
        productId: product.id,
        productName: product.name,
        quantity: qty,
        rate: rate,
        unit: product.unit,
        section: section,
      ));
    }
  }

  void updateQuantity(int index, int qty) {
    if (qty < 1) return;
    formItems[index].quantity = qty;
    formItems.refresh();
  }

  void updateRate(int index, double rate) {
    if (rate < 0) return;
    formItems[index].rate = rate;
    formItems.refresh();
  }

  void moveToSection(int index, int section) {
    formItems[index].section = section;
    formItems.refresh();
  }

  void removeItem(int index) {
    formItems.removeAt(index);
  }

  void clearForm() {
    formItems.clear();
    selectedParty.value = null;
    selectedAgent.value = null;
    section1Add.value = 0;
    section1Discount.value = 0;
    section2Add.value = 0;
    section2Discount.value = 0;
    charges.clear();
    selectedChargeType.value = null;
    roundOff.value = 0;
    _syncMoneyControllers();
  }

  bool save({required bool asDraft}) {
    if (!asDraft && selectedParty.value == null) {
      Get.snackbar('Missing party', 'Please select a party',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (formItems.isEmpty) {
      Get.snackbar('No items', 'Add at least one product',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final status = asDraft ? DocStatus.draft : DocStatus.active;

    if (editingEstimation != null) {
      editingEstimation!
        ..partyId = selectedParty.value?.id ?? editingEstimation!.partyId
        ..partyName = selectedParty.value?.name ?? editingEstimation!.partyName
        ..agentName = selectedAgent.value ?? 'Direct'
        ..pricelistName = selectedPricelist.value ?? ''
        ..date = estimationDate.value
        ..items = formItems.toList()
        ..status = status
        ..section1Add = section1Add.value
        ..section1Discount = section1Discount.value
        ..section2Add = section2Add.value
        ..section2Discount = section2Discount.value
        ..charges = charges
            .map((c) => ChargeLine(name: c.name, value: c.value))
            .toList()
        ..roundOff = roundOff.value;
      estimations.refresh();
    } else {
      estimations.insert(
        0,
        EstimationModel(
          id: 'E${(estimations.length + 1).toString().padLeft(3, '0')}',
          estimationNo:
              'EST${(estimations.length + 37).toString().padLeft(3, '0')}/26-27',
          partyId: selectedParty.value?.id ?? '',
          partyName: selectedParty.value?.name ?? 'Direct',
          agentName: selectedAgent.value ?? 'Direct',
          pricelistName: selectedPricelist.value ?? '',
          date: estimationDate.value,
          items: formItems.toList(),
          status: status,
          section1Add: section1Add.value,
          section1Discount: section1Discount.value,
          section2Add: section2Add.value,
          section2Discount: section2Discount.value,
          charges: charges
              .map((c) => ChargeLine(name: c.name, value: c.value))
              .toList(),
          roundOff: roundOff.value,
        ),
      );
    }
    Get.back();
    Get.snackbar(
      asDraft ? 'Saved as draft' : 'Confirmed',
      asDraft
          ? 'Estimate saved as a draft'
          : 'Estimate confirmed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    return true;
  }

  void deleteEstimation(EstimationModel estimation) {
    estimations.remove(estimation);
    Get.snackbar('Deleted', '${estimation.estimationNo} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }
}
