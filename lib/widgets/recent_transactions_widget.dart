import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactionsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return listItem(transaction: transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class listItem extends StatelessWidget {
  const listItem({super.key, required this.transaction});

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
            const Text(":3"),

            const SizedBox(width: 12),

            Text(transaction.text, style: TextStyle(fontSize: 16)),

            const Spacer(),

            Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        onTap: () => {
          //TODO: open transaction view
        },
      ),
    );
  }
}
