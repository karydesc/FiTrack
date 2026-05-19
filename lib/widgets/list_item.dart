import 'package:fitrack/models/Transaction.dart';
import 'package:fitrack/services/HiveService.dart';
import 'package:flutter/material.dart';

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

        leading: TransactionIcon(category: transaction.category),

        title: Text(
          transaction.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(
          'Account: ${HiveService().getAccount(transaction.accountId)!.name}',
        ),

        trailing: Text(
          "${transaction.amount.toStringAsFixed(2)}€",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: transaction.type == 'incoming'
                ? const Color.fromARGB(255, 2, 138, 7)
                : const Color.fromARGB(255, 245, 72, 59),
          ),
        ),
      ),
    );
  }
}

class TransactionIcon extends StatelessWidget {
  const TransactionIcon({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case 'Food':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.restaurant),
        );
      case 'Transport':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.directions_car),
        );
      case 'Entertainment':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.movie),
        );
      case 'Utilities':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.light_mode),
        );
      case 'Health':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.health_and_safety),
        );
      case 'Education':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.school),
        );
      case 'Shopping':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.shopping_cart),
        );
      case 'Salary':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.attach_money),
        );
      case 'Investment':
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.trending_up),
        );
      default:
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.shopping_bag),
        );
    }
  }
}
