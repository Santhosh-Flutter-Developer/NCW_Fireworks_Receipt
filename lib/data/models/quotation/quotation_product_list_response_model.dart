import '../../../core/network/api_exception.dart';

/// One product option offered for a given pricelist — id/name only.
/// Rate/unit aren't known until [selected_product_id] is queried for this
/// specific product + pricelist combination.
class QuotationProductOption {
  final String productId;
  final String productName;

  const QuotationProductOption({
    required this.productId,
    required this.productName,
  });

  factory QuotationProductOption.fromJson(Map<String, dynamic> json) {
    return QuotationProductOption(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
    );
  }
}

/// Parses the `{"head": {...}}` envelope returned for a
/// `product_pricelist_id` call.
class QuotationProductListResponseModel {
  final int code;
  final String message;
  final List<QuotationProductOption> products;

  const QuotationProductListResponseModel({
    required this.code,
    required this.message,
    required this.products,
  });

  bool get isSuccess => code == 200;

  factory QuotationProductListResponseModel.fromJson(
      Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    final rawCode = head['code'];
    final code = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '') ?? -1;

    final rawMsg = head['msg'];
    final message = (rawMsg is String && rawMsg.trim().isNotEmpty)
        ? rawMsg.trim()
        : 'Unexpected response from server.';

    final products = <QuotationProductOption>[];
    final rawList = head['product_list'];
    if (rawList is List) {
      for (final row in rawList) {
        if (row is Map) {
          products.add(QuotationProductOption.fromJson(
              Map<String, dynamic>.from(row)));
        }
      }
    }

    return QuotationProductListResponseModel(
      code: code,
      message: message,
      products: products,
    );
  }
}
