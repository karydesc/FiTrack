import 'package:hive/hive.dart';

part 'Account.g.dart';

@HiveType(typeId: 1)
class Account {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final double balance;

  Account({required this.name, required this.balance, required this.id});
}
