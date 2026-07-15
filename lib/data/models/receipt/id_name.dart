/// A generic `{id, name}` pair — used for the payment mode / bank
/// dropdown options returned by `receipt.php`.
class IdName {
  final String id;
  final String name;
  const IdName({required this.id, required this.name});

  @override
  String toString() => name;
}

double readNum(dynamic raw) {
  if (raw == null) return 0;
  if (raw is num) return raw.toDouble();
  final cleaned = raw.toString().replaceAll(',', '').trim();
  return double.tryParse(cleaned) ?? 0;
}

int readCode(dynamic raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? -1;
}

String readMsg(dynamic raw) {
  return (raw is String && raw.trim().isNotEmpty)
      ? raw.trim()
      : 'Unexpected response from server.';
}
