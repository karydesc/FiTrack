import 'package:hive/hive.dart';

part 'Transaction.g.dart';

@HiveType(typeId: 2)
class Transaction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? imagePath;

  @HiveField(7)
  final String accountId;

  String getId(){
    return id;
  }

  String? getImagePath(){
    return imagePath;
  }

  DateTime getDate(){
    return date;
    }

  String getText() {
    return text;
  }

  double getAmount() {
    return amount;
  }

  String getType() {
    return type;
  }

  String getCategory() {
    return category;
  }

  String getAccountId() {
    return accountId;
  }


  void setAmount(double amount) {
    amount = amount;
  }

  void setText(String text) {
    text = text;
  }

  void setType(String type) {
    type = type;
  }

  void setCategory(String category) {
    category = category;
  } 
  
  void setImagePath(String imagePath) {
    imagePath = imagePath;
  }

  
  Transaction({
    required this.id,
    required this.text,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.accountId,
    this.imagePath,
  });
}
