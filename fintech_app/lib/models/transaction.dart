/// Modèle représentant une transaction financière.
class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? recipientName;
  final String? recipientAccount;
  final String? reference;
  final String? category;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.status = TransactionStatus.completed,
    this.recipientName,
    this.recipientAccount,
    this.reference,
    this.category,
  });

  /// Indique si la transaction est un débit (sortie d'argent).
  bool get isDebit =>
      type == TransactionType.transferOut ||
      type == TransactionType.payment ||
      type == TransactionType.fee;

  /// Retourne le montant formaté avec signe.
  String get formattedAmount {
    final sign = isDebit ? '-' : '+';
    return '$sign ${amount.toStringAsFixed(0)} FCFA';
  }

  /// Convertit en Map pour stockage SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'status': status.name,
      'recipientName': recipientName,
      'recipientAccount': recipientAccount,
      'reference': reference,
      'category': category,
    };
  }

  /// Crée une Transaction depuis un Map SQLite.
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: TransactionType.values.byName(map['type']),
      status: TransactionStatus.values.byName(map['status']),
      recipientName: map['recipientName'],
      recipientAccount: map['recipientAccount'],
      reference: map['reference'],
      category: map['category'],
    );
  }
}

enum TransactionType {
  transferIn,
  transferOut,
  payment,
  invoice,
  fee,
  deposit,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}
