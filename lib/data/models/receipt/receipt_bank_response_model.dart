import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for a
/// `selected_bank_payment_mode` call.
///
/// Success shape:
/// ```json
/// {
///   "head": {
///     "code": 200,
///     "msg": "",
///     "bank_list": [
///       {"bank_id": "...", "bank_name": "karur vysya bank - Niyaa Crackers World 407"}
///     ]
///   }
/// }
/// ```
///
/// An **empty** [banks] list (still `code == 200`) means the chosen
/// payment mode isn't linked to any bank — i.e. it's a cash-style mode
/// (Cash / Petty Cash / old-balance carry-forwards). The form should
/// hide the Bank picker and send `bank_id: ""` for that line.
class ReceiptBankResponseModel {
  final int code;
  final String message;
  final List<IdName> banks;

  const ReceiptBankResponseModel({
    required this.code,
    required this.message,
    required this.banks,
  });

  bool get isSuccess => code == 200;

  factory ReceiptBankResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    final banks = <IdName>[];
    final rawList = head['bank_list'];
    if (rawList is List) {
      for (final row in rawList) {
        if (row is Map) {
          final m = Map<String, dynamic>.from(row);
          banks.add(IdName(
            id: m['bank_id']?.toString() ?? '',
            name: m['bank_name']?.toString() ?? '',
          ));
        }
      }
    }

    return ReceiptBankResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
      banks: banks,
    );
  }
}
