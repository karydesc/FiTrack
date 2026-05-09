enum TransactionType { income, expense }
class Transaction {
  final String id;
  final String text;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? imagePath;


  Transaction({
    required this.id,
    required this.text,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.imagePath,
  });

}