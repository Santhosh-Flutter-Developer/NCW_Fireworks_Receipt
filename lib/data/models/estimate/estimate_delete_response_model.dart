import '../../../core/network/api_exception.dart';

/// Parses the `{"head": {...}}` envelope returned by `estimate.php` for a
/// `delete_estimate_id` call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "Estimate Cancelled" } }
/// ```
/// or, for a drafted estimate:
/// ```json
/// { "head": { "code": 200, "msg": "Estimate Draft Deleted" } }
/// ```
/// Failure shape:
/// ```json
/// { "head": { "code": 400, "msg": "Invalid Estimate" } }
/// ```
class EstimateDeleteResponseModel {
  final int code;
  final String message;

  const EstimateDeleteResponseModel(
      {required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory EstimateDeleteResponseModel.fromJson(Map<String, dynamic> json) {
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

    return EstimateDeleteResponseModel(code: code, message: message);
  }
}
