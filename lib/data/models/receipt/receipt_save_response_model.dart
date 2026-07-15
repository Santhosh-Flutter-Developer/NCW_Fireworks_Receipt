import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for a
/// `receipt_update` call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "Receipt Successfully Created" } }
/// ```
/// Failure shapes (`code: 400`) include validation messages such as
/// `"Add Payment"`, `"Total amount not equal to bill amount"`,
/// `"Bank payment mode ... already exist"`, etc. — surfaced verbatim.
class ReceiptSaveResponseModel {
  final int code;
  final String message;

  const ReceiptSaveResponseModel({required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory ReceiptSaveResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    return ReceiptSaveResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
    );
  }
}

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for a
/// `delete_receipt_id` call.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "Receipt Cancelled" } }
/// ```
/// Failure shapes (`code: 400`): `"Empty Receipt"`, `"Invalid Receipt"`.
class ReceiptDeleteResponseModel {
  final int code;
  final String message;

  const ReceiptDeleteResponseModel(
      {required this.code, required this.message});

  bool get isSuccess => code == 200;

  factory ReceiptDeleteResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    return ReceiptDeleteResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
    );
  }
}
