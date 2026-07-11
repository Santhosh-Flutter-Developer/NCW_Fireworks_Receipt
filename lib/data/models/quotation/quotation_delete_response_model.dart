import '../../../core/network/api_exception.dart';

/// Parses the `{"head": {...}}` envelope returned by `quotation.php` for a
/// `delete_quotation_id` call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "quotation Cancelled" } }
/// ```
/// or, for a drafted quotation:
/// ```json
/// { "head": { "code": 200, "msg": "quotation Draft Deleted" } }
/// ```
/// Failure shape:
/// ```json
/// { "head": { "code": 400, "msg": "Invalid quotation" } }
/// ```
class QuotationDeleteResponseModel {
  final int code;
  final String message;

  const QuotationDeleteResponseModel(
      {required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory QuotationDeleteResponseModel.fromJson(Map<String, dynamic> json) {
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

    return QuotationDeleteResponseModel(code: code, message: message);
  }
}
