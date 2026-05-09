import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Account {
  final String name;
  final String id;
  final Double balance;

  Account({
    required this.name,
    required this.balance,
    required this.id
});
}