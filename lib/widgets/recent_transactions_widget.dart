import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';

import 'list_item.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction transaction, BuildContext context) onItemTap;
  const RecentTransactionsWidget({super.key, required this.transactions, required this.onItemTap});

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
                return listItem(transaction: transactions[index], action: onItemTap);
              },
            ),
          ),
        ],
      ),
    );
  }
}


