import 'package:flutter/material.dart';

import 'package:personalfinancetracker/models/Transaction.dart';
import 'package:personalfinancetracker/widgets/recent_transactions_widget.dart';
import 'package:personalfinancetracker/widgets/total_funds_widget.dart';

class MainScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const MainScreen({super.key, required this.transactions});

  void openTransactionOverlay(Transaction transaction, BuildContext context){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Icon(Icons.more_horiz),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        }
        );
  }

@override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  double money = 0;
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                child: Text(
                  "Accounts",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 18),
              RecentTransactionsWidget(transactions: widget.transactions, onItemTap: widget.openTransactionOverlay),
              Spacer(flex: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            money++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
