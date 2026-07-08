class BillingItemModel {
  String productId;
  String productName;
  int quantity;
  double rate;
  double discountPercent;

  BillingItemModel({
    required this.productId,
    required this.productName,
    this.quantity = 1,
    required this.rate,
    this.discountPercent = 0,
  });

  double get amount {
    final gross = quantity * rate;
    return gross - (gross * discountPercent / 100);
  }
}

enum DocStatus { draft, sent, approved, rejected, expired, converted }

extension DocStatusX on DocStatus {
  String get label {
    switch (this) {
      case DocStatus.draft:
        return 'Draft';
      case DocStatus.sent:
        return 'Sent';
      case DocStatus.approved:
        return 'Approved';
      case DocStatus.rejected:
        return 'Rejected';
      case DocStatus.expired:
        return 'Expired';
      case DocStatus.converted:
        return 'Converted';
    }
  }
}
