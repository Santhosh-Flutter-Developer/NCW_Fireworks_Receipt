import '../../../core/network/api_exception.dart';

/// Parses the `{"head": {...}}` envelope returned by `quotation.php` for a
/// `quotation_update` (create or edit) call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "Quotation Successfully Created" } }
/// ```
/// Failure shape (validation rejection):
/// ```json
/// { "head": { "code": 400, "msg": "Select the products" } }
/// ```
class QuotationSaveResponseModel {
  final int code;
  final String message;

  const QuotationSaveResponseModel(
      {required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory QuotationSaveResponseModel.fromJson(Map<String, dynamic> json) {
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

    return QuotationSaveResponseModel(code: code, message: message);
  }
}
