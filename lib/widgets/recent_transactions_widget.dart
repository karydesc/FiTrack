import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';

import 'list_item.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final Function goToHistory;
  final Function(Transaction transaction, BuildContext context) onItemTap;
  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.onItemTap,
    required this.goToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length > 4 ? 4 : transactions.length,
            itemBuilder: (context, index) {
              return ListItem(
                transaction: transactions[index],
                action: onItemTap,
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(96, 238, 238, 238),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("View All Transactions", textAlign: TextAlign.center),
              onTap: () {
                goToHistory();
              },
            ),
          ),
        ],
      ),
    );
  }
}
