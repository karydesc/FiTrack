import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.transaction, required this.action});
  final Function(Transaction, BuildContext context) action;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(96, 238, 238, 238),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () => action(transaction, context),

        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.shopping_bag, color: Colors.white),
        ),

        title: Text(
          transaction.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text('Category: ${transaction.category}'),

        trailing: Text(
          "\$${transaction.amount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
