import 'package:fitrack/models/Transaction.dart';
import 'package:fitrack/screens/AccountsScreen.dart';
import 'package:fitrack/screens/SingleTransactionScreen.dart';
import 'package:fitrack/services/HiveService.dart';
import 'package:fitrack/widgets/recent_transactions_widget.dart';
import 'package:fitrack/widgets/total_balance_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainScreen extends StatefulWidget {
  final Function allTransactionsTap;
  final Function(Transaction?) addTransactionModal;
  const MainScreen({
    super.key,
    required this.allTransactionsTap,
    required this.addTransactionModal,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double money = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("fitrack", style: TextStyle(fontWeight: FontWeight.bold)),
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService().accountsListenable,
        builder: (context, value, child) {
          return ValueListenableBuilder(
            valueListenable: HiveService().transactionsListenable,
            builder: (context, Box<Transaction> box, child) {
              double currentMoney = HiveService().getTotalBalance();

              return Container(
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
                      TotalBalanceWidget(money: currentMoney),
                      ElevatedButton(
                        child: Text("Accounts", textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AccountsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      RecentTransactionsWidget(
                        transactions: HiveService()
                            .getAllTransactions()
                            .toList(),
                        onItemTap:
                            (Transaction transaction, BuildContext context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => SingleTransactionScreen(
                                    context: context,
                                    transaction: transaction,
                                    addOrEditTransactionModal:
                                        widget.addTransactionModal,
                                  ),
                                ),
                              );
                            },
                        goToHistory: widget.allTransactionsTap,
                      ),
                      Spacer(flex: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
