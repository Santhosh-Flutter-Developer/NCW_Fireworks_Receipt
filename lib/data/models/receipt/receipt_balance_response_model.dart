import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for an
/// `account_balance_id` call — the "Account Balance : ..." line shown
/// once a payment mode (and bank, if any) is picked.
///
/// Success shape:
/// ```json
/// { "head": { "code": 200, "msg": "", "balance_amount": 11801256 } }
/// ```
/// Failure shapes (`code: 400`): `"Empty Account"`, `"Invalid Account"`.
class ReceiptBalanceResponseModel {
  final int code;
  final String message;
  final double balanceAmount;

  const ReceiptBalanceResponseModel({
    required this.code,
    required this.message,
    required this.balanceAmount,
  });

  bool get isSuccess => code == 200;

  factory ReceiptBalanceResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    return ReceiptBalanceResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
      balanceAmount: readNum(head['balance_amount']),
    );
  }
}
