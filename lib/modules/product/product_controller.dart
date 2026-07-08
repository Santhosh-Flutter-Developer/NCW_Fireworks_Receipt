import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/product_model.dart';

class ProductController extends GetxController {
  final products = <ProductModel>[].obs;
  final searchQuery = ''.obs;
  final filterCategory = RxnString();
  final isTableView = false.obs;

  // Pagination
  final pageLimit = 10.obs;
  final pageNo = 1.obs;
  static const List<int> pageLimitOptions = [10, 25, 50, 100];

  List<String> get categoryOptions => DummyData.productCategories;
  List<String> get unitOptions => DummyData.productUnits;
  List<String> get pricelistOptions => DummyData.pricelists;

  // Form fields (used by ProductFormView)
  ProductModel? editingProduct;
  final formCategory = RxnString();
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final formUnit = RxnString();
  final stockMaintain = true.obs;
  final negativeStock = false.obs;
  final stockCtrl = TextEditingController();

  // Product Price dialog state
  ProductModel? pricingProduct;
  final priceEntries = <PricelistEntry>[].obs;
  final newPricelist = RxnString();
  final newPriceCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    products.assignAll(DummyData.products());
  }

  List<ProductModel> get filtered {
    return products.where((p) {
      final q = searchQuery.value.toLowerCase();
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q);
      final matchesCategory =
          filterCategory.value == null || p.category == filterCategory.value;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  int get totalPages {
    final count = filtered.length;
    if (count == 0) return 1;
    return (count / pageLimit.value).ceil();
  }

  List<ProductModel> get paginated {
    final list = filtered;
    if (pageNo.value > totalPages) pageNo.value = totalPages;
    final start = (pageNo.value - 1) * pageLimit.value;
    if (start >= list.length) return [];
    final end = (start + pageLimit.value).clamp(0, list.length);
    return list.sublist(start, end);
  }

  void setSearch(String value) {
    searchQuery.value = value;
    pageNo.value = 1;
  }

  void setCategoryFilter(String? category) {
    filterCategory.value = filterCategory.value == category ? null : category;
    pageNo.value = 1;
  }

  void setPageLimit(int limit) {
    pageLimit.value = limit;
    pageNo.value = 1;
  }

  void setPageNo(int page) => pageNo.value = page;
  void toggleViewMode(bool table) => isTableView.value = table;

  void startCreate() {
    editingProduct = null;
    formCategory.value = null;
    codeCtrl.clear();
    nameCtrl.clear();
    formUnit.value = null;
    stockMaintain.value = true;
    negativeStock.value = false;
    stockCtrl.clear();
  }

  void startEdit(ProductModel product) {
    editingProduct = product;
    formCategory.value = product.category;
    codeCtrl.text = product.code;
    nameCtrl.text = product.name;
    formUnit.value = product.unit;
    stockMaintain.value = product.stockMaintain;
    negativeStock.value = product.negativeStock;
    stockCtrl.text = product.currentStock.toString();
  }

  String? _validate({required bool isDraft}) {
    if (isDraft) return null;
    if (formCategory.value == null) return 'Please select a category';
    if (nameCtrl.text.trim().isEmpty) return 'Product name is required';
    if (nameCtrl.text.trim().length > 50) {
      return 'Product name must be 50 characters or fewer';
    }
    if (codeCtrl.text.length > 5) {
      return 'Product code must be 5 characters or fewer';
    }
    if (formUnit.value == null) return 'Please select a unit';
    return null;
  }

  bool save({bool asDraft = false}) {
    final error = _validate(isDraft: asDraft);
    if (error != null) {
      Get.snackbar('Check the form', error,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final stock = int.tryParse(stockCtrl.text) ?? 0;

    if (editingProduct != null) {
      editingProduct!
        ..category = formCategory.value ?? editingProduct!.category
        ..code = codeCtrl.text.trim()
        ..name = nameCtrl.text.trim().isEmpty
            ? editingProduct!.name
            : nameCtrl.text.trim()
        ..unit = formUnit.value ?? editingProduct!.unit
        ..stockMaintain = stockMaintain.value
        ..negativeStock = negativeStock.value
        ..currentStock = stock
        ..isDraft = asDraft;
      products.refresh();
    } else {
      products.insert(
        0,
        ProductModel(
          id: 'PR${(products.length + 1).toString().padLeft(3, '0')}',
          category: formCategory.value ?? 'General',
          code: codeCtrl.text.trim(),
          name: nameCtrl.text.trim().isEmpty
              ? 'Untitled Product'
              : nameCtrl.text.trim(),
          unit: formUnit.value ?? DummyData.productUnits.first,
          stockMaintain: stockMaintain.value,
          negativeStock: negativeStock.value,
          currentStock: stock,
          isDraft: asDraft,
        ),
      );
    }
    Get.back();
    Get.snackbar(
      asDraft ? 'Saved as draft' : 'Saved',
      asDraft ? 'Product saved as a draft' : 'Product saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    return true;
  }

  void deleteProduct(ProductModel product) {
    products.remove(product);
    Get.snackbar('Deleted', '${product.name} was removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  // --- Product Price dialog ---

  void startPricing(ProductModel product) {
    pricingProduct = product;
    priceEntries.assignAll(
      product.prices
          .map((p) => PricelistEntry(
                pricelistName: p.pricelistName,
                price: p.price,
                discountEnabled: p.discountEnabled,
              ))
          .toList(),
    );
    newPricelist.value = null;
    newPriceCtrl.clear();
  }

  void addPriceEntry() {
    final pricelist = newPricelist.value;
    final price = double.tryParse(newPriceCtrl.text);
    if (pricelist == null) {
      Get.snackbar('Missing pricelist', 'Please select a pricelist',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (price == null || price <= 0) {
      Get.snackbar('Invalid price', 'Enter a price greater than 0',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final existingIndex =
        priceEntries.indexWhere((p) => p.pricelistName == pricelist);
    if (existingIndex >= 0) {
      priceEntries[existingIndex].price = price;
      priceEntries.refresh();
    } else {
      priceEntries.add(PricelistEntry(pricelistName: pricelist, price: price));
    }
    newPricelist.value = null;
    newPriceCtrl.clear();
  }

  void toggleDiscount(int index) {
    priceEntries[index].discountEnabled = !priceEntries[index].discountEnabled;
    priceEntries.refresh();
  }

  void removePriceEntry(int index) => priceEntries.removeAt(index);

  void savePrices() {
    if (pricingProduct == null) return;
    pricingProduct!.prices = priceEntries.toList();
    products.refresh();
    Get.back();
    Get.snackbar('Saved', 'Product prices updated',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
    stockCtrl.dispose();
    newPriceCtrl.dispose();
    super.onClose();
  }
}
