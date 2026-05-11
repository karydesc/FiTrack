import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';

class listItem extends StatelessWidget {
  const listItem({super.key, required this.transaction, required this.action});
  final Function(Transaction, BuildContext context) action;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(96, 238, 238, 238),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        child: Row(
          children: [

            const SizedBox(width: 12),

            Text(transaction.text, style: TextStyle(fontSize: 16)),

            const Spacer(),

            Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        onTap: () => {action(transaction, context)},
      ),
    );
  }
}
