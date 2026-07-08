import 'billing_item_model.dart';

class QuotationModel {
  final String id;
  final String quotationNo;
  String partyId;
  String partyName;
  DateTime date;
  DateTime validTill;
  List<BillingItemModel> items;
  DocStatus status;
  String notes;

  QuotationModel({
    required this.id,
    required this.quotationNo,
    required this.partyId,
    required this.partyName,
    required this.date,
    required this.validTill,
    required this.items,
    this.status = DocStatus.draft,
    this.notes = '',
  });

  double get subTotal => items.fold(0, (sum, i) => sum + i.amount);
  double get tax => subTotal * 0.05;
  double get total => subTotal + tax;
}
