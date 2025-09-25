class CashTransaction {
  int? id;
  String title;
  double amount;
  DateTime date;
  String type; // "income" or "expense"
  String? note;

  CashTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'note': note,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory CashTransaction.fromMap(Map<String, dynamic> map) {
    return CashTransaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      type: map['type'] as String,
      note: map['note'] as String?,
    );
  }
}