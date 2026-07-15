import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for a
/// `show_receipt_id` call.
///
/// Success shape:
/// ```json
/// {
///   "head": {
///     "code": 200,
///     "msg": "",
///     "receipt_date": "15-07-2026",
///     "payment_mode_list": [
///       {"payment_mode_id": "...", "payment_mode_name": "Cash"},
///       {"payment_mode_id": "...", "payment_mode_name": "Gpay"}
///     ]
///   }
/// }
/// ```
///
/// Note: `receipt.php` reads this key's *value* (`show_receipt_id`) but
/// only ever uses it to decide whether the block runs — an empty string
/// is enough to bootstrap a brand-new Add Receipt form. There's no
/// "load an existing receipt for editing" support server-side (Receipts
/// can only be created or deleted/cancelled, never edited).
class ReceiptFormInitResponseModel {
  final int code;
  final String message;
  final String receiptDate; // dd-MM-yyyy
  final List<IdName> paymentModes;

  const ReceiptFormInitResponseModel({
    required this.code,
    required this.message,
    required this.receiptDate,
    required this.paymentModes,
  });

  bool get isSuccess => code == 200;

  factory ReceiptFormInitResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    final paymentModes = <IdName>[];
    final rawList = head['payment_mode_list'];
    if (rawList is List) {
      for (final row in rawList) {
        if (row is Map) {
          final m = Map<String, dynamic>.from(row);
          paymentModes.add(IdName(
            id: m['payment_mode_id']?.toString() ?? '',
            name: m['payment_mode_name']?.toString() ?? '',
          ));
        }
      }
    }

    return ReceiptFormInitResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
      receiptDate: head['receipt_date']?.toString() ?? '',
      paymentModes: paymentModes,
    );
  }
}
