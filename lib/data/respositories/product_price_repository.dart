import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../models/product_price_list_model.dart';

/// Talks to `product.php` for the Product Price screen. Every method
/// either returns a successful, fully-validated [ProductPriceListResponse]
/// or throws a typed [ApiException] — callers never need to check for
/// nulls or guess at error shapes.
class ProductPriceRepository {
  ProductPriceRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<ProductPriceListResponse> fetchPriceList({
    String pricelistId = '',
    String productId = '',
    int pageNumber = 1,
    int pageLimit = 10,
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.productPrice,
      body: {
        'product_view': '1',
        'filter_pricelist_id': pricelistId,
        'filter_product_id': productId,
        'page_number': '$pageNumber',
        'page_limit': '$pageLimit',
      },
    );

    final result = ProductPriceListResponse.fromJson(json);

    if (result.code != 200) {
      throw InvalidResponseException(
        'Server returned an unexpected status (${result.code}).',
      );
    }

    return result;
  }
}
