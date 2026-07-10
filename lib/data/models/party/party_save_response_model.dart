import '../../../core/network/api_exception.dart';

/// Parses the `{"head": {...}}` envelope returned by
/// `retail_mobile_app/API/party.php` for a create/update (`party_update`)
/// call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "Party Successfully Created" } }
/// ```
///
/// Failure shape (validation / duplicate name, etc.):
/// ```json
/// { "head": { "code": 400, "msg": "This party name is already exist" } }
/// ```
class PartySaveResponseModel {
  final int code;
  final String message;

  const PartySaveResponseModel({required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory PartySaveResponseModel.fromJson(Map<String, dynamic> json) {
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

    return PartySaveResponseModel(code: code, message: message);
  }
}
