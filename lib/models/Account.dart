import 'package:hive/hive.dart';

part 'Account.g.dart';

@HiveType(typeId: 1)
class Account  {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  String getId(){
    return id;
  }
  
  Account({required this.name, required this.id});
}