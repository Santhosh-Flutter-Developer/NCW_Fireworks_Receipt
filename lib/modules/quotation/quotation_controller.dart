import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/billing_item_model.dart';
import '../../data/models/party_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/quotation_model.dart';

class QuotationController extends GetxController {
  final quotations = <QuotationModel>[].obs;
  final parties = DummyData.parties();
  final products = DummyData.products();
  final searchQuery = ''.obs;
  final filterStatus = Rx<DocStatus?>(null);
  final isTableView = false.obs;

  // Form state
  QuotationModel? editingQuotation;
  final Rx<PartyModel?> selectedParty = Rx<PartyModel?>(null);
  final Rx<DateTime> quotationDate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> validTill =
      Rx<DateTime>(DateTime.now().add(const Duration(days: 14)));
  final formItems = <BillingItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    quotations.assignAll(DummyData.quotations());
  }

  List<QuotationModel> get filtered {
    return quotations.where((q) {
      final matchesQuery = searchQuery.value.isEmpty ||
          q.quotationNo.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          q.partyName.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesStatus =
          filterStatus.value == null || q.status == filterStatus.value;
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
    editingQuotation = null;
    selectedParty.value = null;
    quotationDate.value = DateTime.now();
    validTill.value = DateTime.now().add(const Duration(days: 14));
    formItems.clear();
  }

  void startEdit(QuotationModel quotation) {
    editingQuotation = quotation;
    selectedParty.value = parties.firstWhereOrNull(
      (p) => p.id == quotation.partyId,
    );
    quotationDate.value = quotation.date;
    validTill.value = quotation.validTill;
    formItems.assignAll(quotation.items
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

    if (editingQuotation != null) {
      editingQuotation!
        ..partyId = selectedParty.value!.id
        ..partyName = selectedParty.value!.name
        ..date = quotationDate.value
        ..validTill = validTill.value
        ..items = formItems.toList();
      quotations.refresh();
    } else {
      quotations.insert(
        0,
        QuotationModel(
          id: 'Q${(quotations.length + 1).toString().padLeft(3, '0')}',
          quotationNo:
              'QUO-2026-${(quotations.length + 1).toString().padLeft(3, '0')}',
          partyId: selectedParty.value!.id,
          partyName: selectedParty.value!.name,
          date: quotationDate.value,
          validTill: validTill.value,
          items: formItems.toList(),
        ),
      );
    }
    Get.back();
    Get.snackbar('Saved', 'Quotation saved successfully',
        snackPosition: SnackPosition.BOTTOM);
    return true;
  }

  void deleteQuotation(QuotationModel quotation) {
    quotations.remove(quotation);
    Get.snackbar('Deleted', '${quotation.quotationNo} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }
}
