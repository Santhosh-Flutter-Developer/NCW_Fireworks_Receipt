import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/billing_item_model.dart';
import '../../data/models/estimation_model.dart';
import '../../data/models/party_model.dart';
import '../../data/models/product_model.dart';

class EstimationController extends GetxController {
  final estimations = <EstimationModel>[].obs;
  final parties = DummyData.parties();
  final products = DummyData.products();
  final searchQuery = ''.obs;
  final filterStatus = Rx<DocStatus?>(null);
  final isTableView = false.obs;

  // Form state
  EstimationModel? editingEstimation;
  final Rx<PartyModel?> selectedParty = Rx<PartyModel?>(null);
  final Rx<DateTime> estimationDate = Rx<DateTime>(DateTime.now());
  final formItems = <BillingItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    estimations.assignAll(DummyData.estimations());
  }

  List<EstimationModel> get filtered {
    return estimations.where((e) {
      final matchesQuery = searchQuery.value.isEmpty ||
          e.estimationNo
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          e.partyName.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesStatus =
          filterStatus.value == null || e.status == filterStatus.value;
      return matchesQuery && matchesStatus;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double get formSubTotal => formItems.fold(0, (sum, i) => sum + i.amount);
  double get formTax => formSubTotal * 0.05;
  double get formTotal => formSubTotal + formTax;

  void setSearch(String value) => searchQuery.value = value;
  void setStatusFilter(DocStatus? status) {
    filterStatus.value = filterStatus.value == status ? null : status;
  }
  void toggleViewMode(bool table) => isTableView.value = table;

  void startCreate() {
    editingEstimation = null;
    selectedParty.value = null;
    estimationDate.value = DateTime.now();
    formItems.clear();
  }

  void startEdit(EstimationModel estimation) {
    editingEstimation = estimation;
    selectedParty.value =
        parties.firstWhereOrNull((p) => p.id == estimation.partyId);
    estimationDate.value = estimation.date;
    formItems.assignAll(estimation.items
        .map((i) => BillingItemModel(
              productId: i.productId,
              productName: i.productName,
              quantity: i.quantity,
              rate: i.rate,
              discountPercent: i.discountPercent,
            ))
        .toList());
  }

  void addProductToForm(ProductModel product) {
    final existingIndex =
        formItems.indexWhere((i) => i.productId == product.id);
    if (existingIndex >= 0) {
      formItems[existingIndex].quantity += 1;
      formItems.refresh();
    } else {
      formItems.add(BillingItemModel(
        productId: product.id,
        productName: product.name,
        quantity: 1,
        rate: product.price,
      ));
    }
  }

  void updateQuantity(int index, int qty) {
    if (qty < 1) return;
    formItems[index].quantity = qty;
    formItems.refresh();
  }

  void removeItem(int index) {
    formItems.removeAt(index);
  }

  bool save() {
    if (selectedParty.value == null) {
      Get.snackbar('Missing party', 'Please select a party',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (formItems.isEmpty) {
      Get.snackbar('No items', 'Add at least one product',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (editingEstimation != null) {
      editingEstimation!
        ..partyId = selectedParty.value!.id
        ..partyName = selectedParty.value!.name
        ..date = estimationDate.value
        ..items = formItems.toList();
      estimations.refresh();
    } else {
      estimations.insert(
        0,
        EstimationModel(
          id: 'E${(estimations.length + 1).toString().padLeft(3, '0')}',
          estimationNo:
              'EST-2026-${(estimations.length + 1).toString().padLeft(3, '0')}',
          partyId: selectedParty.value!.id,
          partyName: selectedParty.value!.name,
          date: estimationDate.value,
          items: formItems.toList(),
        ),
      );
    }
    Get.back();
    Get.snackbar('Saved', 'Estimation saved successfully',
        snackPosition: SnackPosition.BOTTOM);
    return true;
  }

  void deleteEstimation(EstimationModel estimation) {
    estimations.remove(estimation);
    Get.snackbar('Deleted', '${estimation.estimationNo} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }
}
