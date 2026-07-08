enum BalanceType { credit, debit }

extension BalanceTypeX on BalanceType {
  String get label => this == BalanceType.credit ? 'Credit' : 'Debit';
}

class PartyModel {
  final String id;
  String agent;
  String name;
  String phone;
  String email;
  String address;
  String state;
  String district;
  String city;
  String pincode;
  String identification;
  String gstin;
  double openingBalance;
  BalanceType balanceType;
  bool isDraft;

  PartyModel({
    required this.id,
    this.agent = '',
    required this.name,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.state = 'Tamil Nadu',
    this.district = '',
    this.city = '',
    this.pincode = '',
    this.identification = '',
    this.gstin = '',
    this.openingBalance = 0,
    this.balanceType = BalanceType.credit,
    this.isDraft = false,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String get agentLabel => agent.isEmpty ? '-' : agent;
}
