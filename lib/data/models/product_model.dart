/// A single price entry for a product against a specific pricelist,
/// matching the "Product Price" modal on the web app.
class PricelistEntry {
  String pricelistName;
  double price;
  bool discountEnabled;

  PricelistEntry({
    required this.pricelistName,
    required this.price,
    this.discountEnabled = false,
  });
}

class ProductModel {
  final String id;
  String category;
  String code;
  String name;
  String unit;
  bool stockMaintain;
  bool negativeStock;
  int currentStock;
  String? imagePath;
  List<PricelistEntry> prices;
  bool isDraft;

  ProductModel({
    required this.id,
    this.category = 'General',
    this.code = '',
    required this.name,
    this.unit = 'BOX',
    this.stockMaintain = true,
    this.negativeStock = false,
    this.currentStock = 0,
    this.imagePath,
    List<PricelistEntry>? prices,
    this.isDraft = false,
  }) : prices = prices ?? [];

  /// Convenience price used by Quotation/Estimation as the default rate —
  /// the first pricelist entry, or 0 if none has been set yet.
  double get price => prices.isNotEmpty ? prices.first.price : 0;

  /// A stock-maintained product sitting at zero or below needs attention,
  /// even though negative stock itself may be explicitly allowed.
  bool get needsAttention => stockMaintain && currentStock <= 0;

  String get stockLabel =>
      stockMaintain ? '$currentStock $unit' : 'Not tracked';
}
