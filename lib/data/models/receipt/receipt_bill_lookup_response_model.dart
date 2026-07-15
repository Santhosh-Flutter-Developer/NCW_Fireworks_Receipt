import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// Parses the `{"head": {...}}` envelope returned by `receipt.php` for a
/// `payment_bill_number` call.
///
/// Success shape:
/// ```json
/// {
///   "head": {
///     "code": 200,
///     "msg": "",
///     "estimate_number": "EST021/26-27",
///     "party": "GOBI - 9994265522",
///     "total_amount": 1092
///   }
/// }
/// ```
/// Failure shapes (`code: 400`): `"Empty Estimate"`, `"Invalid Estimate"`.
///
/// Note: the API doesn't return a paid/pending breakdown here — only the
/// bill's own grand total. [ReceiptRepository]/the form track how much
/// of that total has been allocated to payment rows *in this session*
/// client-side, rather than showing a server-sourced "already paid"
/// figure the endpoint doesn't provide.
class ReceiptBillLookupResponseModel {
  final int code;
  final String message;
  final String estimateNumber;
  final String party;
  final double totalAmount;

  const ReceiptBillLookupResponseModel({
    required this.code,
    required this.message,
    required this.estimateNumber,
    required this.party,
    required this.totalAmount,
  });

  bool get isSuccess => code == 200;

  factory ReceiptBillLookupResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    return ReceiptBillLookupResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
      estimateNumber: head['estimate_number']?.toString() ?? '',
      party: head['party']?.toString() ?? '',
      totalAmount: readNum(head['total_amount']),
    );
  }
}
