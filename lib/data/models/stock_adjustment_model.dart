enum AdjustmentType { addition, reduction, damage, correction }

extension AdjustmentTypeX on AdjustmentType {
  String get label {
    switch (this) {
      case AdjustmentType.addition:
        return 'Stock In';
      case AdjustmentType.reduction:
        return 'Stock Out';
      case AdjustmentType.damage:
        return 'Damage / Loss';
      case AdjustmentType.correction:
        return 'Correction';
    }
  }
}

class StockAdjustmentModel {
  final String id;
  final String refNo;
  String productId;
  String productName;
  DateTime date;
  AdjustmentType type;
  int quantity;
  int stockBefore;
  int stockAfter;
  String reason;

  StockAdjustmentModel({
    required this.id,
    required this.refNo,
    required this.productId,
    required this.productName,
    required this.date,
    required this.type,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    this.reason = '',
  });
}
