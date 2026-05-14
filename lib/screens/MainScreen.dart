import 'package:flutter/material.dart';

import 'package:personalfinancetracker/models/Transaction.dart';
import 'package:personalfinancetracker/screens/AccountsScreen.dart';
import 'package:personalfinancetracker/widgets/recent_transactions_widget.dart';
import 'package:personalfinancetracker/widgets/total_funds_widget.dart';

class MainScreen extends StatefulWidget {
  final Function allTransactionsTap;
  final Function addTransactionModal;
  const MainScreen({
    super.key,
    required this.allTransactionsTap,
    required this.addTransactionModal,
  });

  void openTransactionOverlay(Transaction transaction, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.more_horiz),
                        onSelected: (String value) {
                          if (value == 'edit') {
                            // TODO: Open edit screen
                          } else if (value == 'delete') {
                            Navigator.pop(context);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double money = 0;
  // void sumTransactionCost() {
  //   double sum = 0;
  //   for (var transaction in widget.transactions) {
  //     sum += transaction.amount;
  //   }
  //   money = sum;
  // }

  @override
  Widget build(BuildContext context) {
    // sumTransactionCost();
    return Scaffold(
      appBar: AppBar(
        title: Text("FiTrack"),
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Spacer(flex: 1),
              TotalFundsWidget(money: money),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AccountsScreen(),
                    ),
                  );
                },
                child: Text(
                  "Accounts",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 18),
              RecentTransactionsWidget(
                transactions: [],
                onItemTap: widget.openTransactionOverlay,
                goToHistory: widget.allTransactionsTap,
              ),
              Spacer(flex: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.addTransactionModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
