import '../../../core/network/api_exception.dart';
import 'id_name.dart';

/// One row from `receipt_list` in a `receipt_listing` response.
class ReceiptListItem {
  final String receiptId;
  final String receiptNumber;
  final String receiptDate; // yyyy-MM-dd, as stored server-side
  final String agentName;
  final String partyName;
  final double totalAmount;

  const ReceiptListItem({
    required this.receiptId,
    required this.receiptNumber,
    required this.receiptDate,
    required this.agentName,
    required this.partyName,
    required this.totalAmount,
  });

  factory ReceiptListItem.fromJson(Map<String, dynamic> json) {
    return ReceiptListItem(
      receiptId: json['receipt_id']?.toString() ?? '',
      receiptNumber: json['receipt_number']?.toString() ?? '',
      receiptDate: json['receipt_date']?.toString() ?? '',
      agentName: json['agent_name']?.toString() ?? '',
      partyName: json['party_name']?.toString() ?? '',
      totalAmount: readNum(json['total_amount']),
    );
  }
}

/// Parses the `{"head": {...}}` envelope returned for a `receipt_listing`
/// call.
///
/// Note: unlike `estimate_listing`, this endpoint's WHERE clause is
/// hardcoded to `deleted = '0'` server-side — there's no drafted/cancelled
/// toggle to request a second page of void receipts, so the list view
/// only ever shows active rows.
class ReceiptListResponseModel {
  final int code;
  final String message;
  final List<ReceiptListItem> items;

  const ReceiptListResponseModel({
    required this.code,
    required this.message,
    required this.items,
  });

  bool get isSuccess => code == 200;

  factory ReceiptListResponseModel.fromJson(Map<String, dynamic> json) {
    final head = json['head'];
    if (head is! Map) {
      throw const InvalidResponseException(
        'Server response was missing the expected "head" field.',
      );
    }

    final items = <ReceiptListItem>[];
    final rawList = head['receipt_list'];
    if (rawList is List) {
      for (final row in rawList) {
        if (row is Map) {
          items.add(ReceiptListItem.fromJson(Map<String, dynamic>.from(row)));
        }
      }
    }

    return ReceiptListResponseModel(
      code: readCode(head['code']),
      message: readMsg(head['msg']),
      items: items,
    );
  }
}
