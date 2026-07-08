import 'billing_item_model.dart' show DocStatus;

/// Whether a product line inside a Stock Adjustment bill increases or
/// decreases stock — mirrors the "Stock Action" column (Add / Remove) on
/// the web app's Add/Edit Stock Adjustment screen.
enum StockAction { add, remove }

extension StockActionX on StockAction {
  String get label {
    switch (this) {
      case StockAction.add:
        return 'Add';
      case StockAction.remove:
        return 'Remove';
    }
  }

  bool get isAdd => this == StockAction.add;
}

/// A single product line inside a Stock Adjustment bill — one row of the
/// "Product / Unit / Qty / Stock Action" table on the web app.
class StockAdjustmentItem {
  String productId;
  String productName;
  String unit;
  double qty;
  StockAction action;

  StockAdjustmentItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.qty,
    required this.action,
  });
}

/// A Stock Adjustment bill (e.g. "STA011/26-27") made up of one or more
/// product lines recorded together, matching the web app's
/// Stock Adjustment module.
class StockAdjustmentModel {
  final String id;

  /// Empty until the bill is Submitted — Draft bills show "NULL" for this
  /// on the web app, exactly like on the list screen.
  String billNo;
  DateTime date;
  String remarks;
  List<StockAdjustmentItem> items;
  DocStatus status;
  String creator;

  StockAdjustmentModel({
    required this.id,
    this.billNo = '',
    required this.date,
    this.remarks = '',
    List<StockAdjustmentItem>? items,
    this.status = DocStatus.active,
    this.creator = 'NCW Fireworks Retail',
  }) : items = items ?? [];

  double get totalQty => items.fold(0.0, (sum, i) => sum + i.qty);

  /// Matches the "2 Pcs" / "2.00" style totals shown across the list and
  /// bill preview on the web app.
  String qtyLabel({int decimals = 0}) {
    final total = totalQty;
    final isWhole = total == total.roundToDouble();
    final value = isWhole && decimals == 0
        ? total.toInt().toString()
        : total.toStringAsFixed(decimals == 0 ? 2 : decimals);
    return '$value Pcs';
  }
}
