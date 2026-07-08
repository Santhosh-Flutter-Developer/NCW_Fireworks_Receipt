import 'billing_item_model.dart';

class EstimationModel {
  final String id;
  final String estimationNo;
  String partyId;
  String partyName;
  DateTime date;
  List<BillingItemModel> items;
  DocStatus status;
  String notes;

  EstimationModel({
    required this.id,
    required this.estimationNo,
    required this.partyId,
    required this.partyName,
    required this.date,
    required this.items,
    this.status = DocStatus.draft,
    this.notes = '',
  });

  double get subTotal => items.fold(0, (sum, i) => sum + i.amount);
  double get tax => subTotal * 0.05;
  double get total => subTotal + tax;
}
