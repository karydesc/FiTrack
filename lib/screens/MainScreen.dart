import 'package:FiTrack/models/Transaction.dart';
import 'package:FiTrack/screens/AccountsScreen.dart';
import 'package:FiTrack/screens/SingleTransactionScreen.dart';
import 'package:FiTrack/services/HiveService.dart';
import 'package:FiTrack/widgets/recent_transactions_widget.dart';
import 'package:FiTrack/widgets/remaining_funds_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        title: Text("FiTrack"),
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Transaction>('transactionsBox').listenable(),
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
                  TotalFundsWidget(money: currentMoney),
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
                    transactions: HiveService().getAllTransactions().reversed.toList(),
                    onItemTap: (Transaction transaction, BuildContext context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => SingleTransactionScreen(context: context, transaction: transaction, addOrEditTransactionModal: widget.addTransactionModal),
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
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.addTransactionModal(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
