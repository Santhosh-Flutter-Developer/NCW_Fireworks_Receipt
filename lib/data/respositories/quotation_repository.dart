import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../models/quotation/quotation_delete_response_model.dart';
import '../models/quotation/quotation_init_response_model.dart';
import '../models/quotation/quotation_list_response_model.dart';
import '../models/quotation/quotation_product_list_response_model.dart';
import '../models/quotation/quotation_save_response_model.dart';
import '../models/quotation/quotation_selected_product_response_model.dart';

/// One product line as sent inside `product_data` on `quotation_update`.
class QuotationProductLine {
  final String productId;
  final String quantity;
  final String rate;

  const QuotationProductLine({
    required this.productId,
    required this.quantity,
    required this.rate,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_quantity': quantity,
        'product_rate': rate,
      };
}

/// Talks to `quotation.php`. Every method either returns a successful,
/// validated result or throws a typed [ApiException] — callers never need
/// to inspect raw response maps.
class QuotationRepository {
  QuotationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// Bootstraps the Add/Edit Quotation form: dropdown data (pricelist,
  /// party) plus — when [showQuotationId] is a real id — the existing
  /// quotation's own fields. Pass an empty string to get just the
  /// dropdown data for a brand-new quotation.
  Future<QuotationInitResponseModel> getFormInitData({
    String showQuotationId = '',
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.quotation,
      body: {'show_quotation_id': showQuotationId},
    );

    final result = QuotationInitResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }

  /// Fetches a page of the quotation list, with the same From/To/search/
  /// party filters as the web app's Quotation list screen.
  ///
  /// [drafted] and [cancelled] select which tab's rows come back — the
  /// server's WHERE clause is `drafted = '<drafted>' AND cancelled =
  /// '<cancelled>'`, so pass `'1'`/`'0'` explicitly for Active / Draft /
  /// Cancel rather than leaving them blank.
  Future<QuotationListResponseModel> listQuotations({
    String filterFromDate = '',
    String filterToDate = '',
    String searchText = '',
    String filterPartyId = '',
    int pageNumber = 1,
    int pageLimit = 10,
    String drafted = '0',
    String cancelled = '0',
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.quotation,
      body: {
        'quotation_listing': '1',
        'filter_from_date': filterFromDate,
        'filter_to_date': filterToDate,
        'search_text': searchText,
        'filter_party_id': filterPartyId,
        'page_number': pageNumber.toString(),
        'page_limit': pageLimit.toString(),
        'drafted': drafted,
        'cancelled': cancelled,
      },
    );

    final result = QuotationListResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }

  /// Products offered under a given pricelist, for the "Add Item" picker.
  Future<QuotationProductListResponseModel> getProductsForPricelist(
    String pricelistId,
  ) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.quotation,
      body: {'product_pricelist_id': pricelistId},
    );

    final result = QuotationProductListResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }

  /// Rate / unit / discount-section for one product under one pricelist —
  /// queried right after a product is picked, since
  /// `getProductsForPricelist` only returns id + name.
  Future<QuotationSelectedProductResponseModel> getSelectedProductDetail({
    required String productId,
    required String pricelistId,
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.quotation,
      body: {
        'selected_product_id': productId,
        'pricelist_id': pricelistId,
      },
    );

    final result = QuotationSelectedProductResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }

  /// Creates a new quotation, or updates an existing one when [editId] is
  /// supplied. [drafted] = `'1'` saves it as a draft (the server skips
  /// most validation and doesn't assign a bill number until it's
  /// confirmed); `'0'` is a normal create/update.
  Future<QuotationSaveResponseModel> saveQuotation({
    required String creator,
    String editId = '',
    required String drafted,
    required String quotationDate, // dd-MM-yyyy
    required String pricelistId,
    required String partyId,
    required List<QuotationProductLine> products,
    String section1AddValue = '',
    String section1Discount = '',
    String section2AddValue = '',
    String section2Discount = '',
  }) async {
    final body = <String, dynamic>{
      'quotation_update': '1',
      'creator': creator,
      'edit_id': editId,
      'drafted': drafted,
      'quotation_date': quotationDate,
      'pricelist_id': pricelistId,
      'agent_id': '',
      'party_id': partyId,
      'product_data': products.map((p) => p.toJson()).toList(),
      'section1_add_value': section1AddValue,
      'section1_discount': section1Discount,
      'section2_add_value': section2AddValue,
      'section2_discount': section2Discount,
    };

    final json = await _apiClient.postJson(ApiEndpoints.quotation, body: body);

    final result = QuotationSaveResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }

  /// Deletes/cancels a quotation. The server decides which based on its
  /// own `drafted` flag: a draft is permanently deleted, anything else is
  /// marked cancelled (soft-void).
  Future<QuotationDeleteResponseModel> deleteQuotation({
    required String quotationId,
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.quotation,
      body: {'delete_quotation_id': quotationId},
    );

    final result = QuotationDeleteResponseModel.fromJson(json);
    if (result.isSuccess) return result;

    throw ApiRequestException(result.message);
  }
}
