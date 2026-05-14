import 'dart:ffi';

import 'package:flutter/foundation.dart';

@HiveType(typeId: 1)
class Account {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;
  final Double balance;

  Account({required this.name, required this.balance, required this.id});
}
