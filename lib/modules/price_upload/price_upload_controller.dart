import 'package:get/get.dart';
import '../../core/network/api_exception.dart';
import '../../data/models/product_price_list_model.dart';
import '../../data/respositories/product_price_repository.dart';

class PriceUploadController extends GetxController {
  PriceUploadController({ProductPriceRepository? repository})
      : _repository = repository ?? ProductPriceRepository();

  final ProductPriceRepository _repository;

  static const List<int> pageSizeOptions = [10, 25, 50, 100];

  // ---- List screen state ---------------------------------------------------
  final rows = <ProductPriceRow>[].obs;
  final pricelistOptions = <PricelistOption>[].obs;
  final productOptions = <ProductOption>[].obs;

  final RxnString filterPricelistId = RxnString();
  final RxnString filterProductId = RxnString();
  final isTableView = true.obs;
  final pageLimit = 10.obs;
  final pageNumber = 1.obs;

  final isLoading = false.obs;
  final RxnString errorText = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPriceList();
  }

  /// The API paginates but doesn't return a total row count, so "is there
  /// a next page" is inferred from whether this page came back full.
  bool get hasNextPage => rows.length >= pageLimit.value;

  bool get hasPrevPage => pageNumber.value > 1;

  Future<void> fetchPriceList() async {
    isLoading.value = true;
    errorText.value = null;
    try {
      final result = await _repository.fetchPriceList(
        pricelistId: filterPricelistId.value ?? '',
        productId: filterProductId.value ?? '',
        pageNumber: pageNumber.value,
        pageLimit: pageLimit.value,
      );
      rows.assignAll(result.rows);
      // The master dropdown lists come back on every call — only refresh
      // them when populated, so a filtered/edge-case response can't wipe
      // out dropdown options the person is actively using.
      if (result.pricelists.isNotEmpty) {
        pricelistOptions.assignAll(result.pricelists);
      }
      if (result.products.isNotEmpty) {
        productOptions.assignAll(result.products);
      }
    } on ApiException catch (e) {
      errorText.value = e.message;
    } catch (_) {
      errorText.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void setFilterPricelist(String? pricelistId) {
    filterPricelistId.value = pricelistId;
    pageNumber.value = 1;
    fetchPriceList();
  }

  void setFilterProduct(String? productId) {
    filterProductId.value = productId;
    pageNumber.value = 1;
    fetchPriceList();
  }

  void setPageLimit(int limit) {
    pageLimit.value = limit;
    pageNumber.value = 1;
    fetchPriceList();
  }

  void nextPage() {
    if (!hasNextPage || isLoading.value) return;
    pageNumber.value += 1;
    fetchPriceList();
  }

  void prevPage() {
    if (!hasPrevPage || isLoading.value) return;
    pageNumber.value -= 1;
    fetchPriceList();
  }

  void firstPage() {
    if (pageNumber.value == 1 || isLoading.value) return;
    pageNumber.value = 1;
    fetchPriceList();
  }

  void toggleViewMode(bool table) => isTableView.value = table;

  void retry() => fetchPriceList();

  /// Delete/Upload aren't backed by an API yet — surface that clearly
  /// instead of pretending to mutate server data that a refresh would
  /// just bring back.
  void deleteRow(ProductPriceRow row) {
    Get.snackbar(
      'Not available yet',
      'Deleting a price needs its own API endpoint from the backend team.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void submitUpload({
    required String? pricelistId,
    required String? productId,
    required double? price,
  }) {
    if (pricelistId == null) {
      Get.snackbar('Missing pricelist', 'Please select a pricelist',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (productId == null) {
      Get.snackbar('Missing product', 'Please select a product',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (price == null || price <= 0) {
      Get.snackbar('Invalid price', 'Enter a price greater than 0',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.back();
    Get.snackbar(
      'Not available yet',
      'Uploading a price needs its own API endpoint from the backend team.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
