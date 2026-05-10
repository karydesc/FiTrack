import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:personalfinancetracker/models/Transaction.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class TotalFundsWidget extends StatelessWidget {
  final double money;
  const TotalFundsWidget({super.key, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Total Funds",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 2,
            ),
          ),
          Text(
            "$money\$",
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactionsWidget({super.key, required this.transactions});

  Widget listItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(96, 238, 238, 238),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(":3"),

          const SizedBox(width: 12),

          Text(transaction.text),

          const Spacer(),

          Text("\$${transaction.amount}"),
        ],
      ),
    );
  }

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
                return listItem(transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  double money = 0;
  List<Transaction> transactions = [
    Transaction(
      id: '1',
      text: 'Salary',
      amount: 3000.0,
      type: TransactionType.income,
      category: 'Salary',
      date: DateTime.now(),
      imagePath: null,
    ),
    Transaction(
      id: '2',
      text: 'Groceries',
      amount: -150.0,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now().subtract(Duration(days: 1)),
      imagePath: null,
    ),
    Transaction(
      id: '3',
      text: 'Gas',
      amount: -50.0,
      type: TransactionType.expense,
      category: 'Transport',
      date: DateTime.now().subtract(Duration(days: 2)),
      imagePath: null,
    ),
    Transaction(
      id: '4',
      text: 'Freelance',
      amount: 500.0,
      type: TransactionType.income,
      category: 'Freelance',
      date: DateTime.now().subtract(Duration(days: 3)),
      imagePath: null,
    ),
    Transaction(
      id: '5',
      text: 'Rent',
      amount: -1000.0,
      type: TransactionType.expense,
      category: 'Housing',
      date: DateTime.now().subtract(Duration(days: 30)),
      imagePath: null,
    ),
    Transaction(
      id: '6',
      text: 'Coffee',
      amount: -5.0,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
      imagePath: null,
    ),
    Transaction(
      id: '7',
      text: 'Bonus',
      amount: 200.0,
      type: TransactionType.income,
      category: 'Salary',
      date: DateTime.now().subtract(Duration(days: 7)),
      imagePath: null,
    ),
    Transaction(
      id: '8',
      text: 'Movie',
      amount: -20.0,
      type: TransactionType.expense,
      category: 'Entertainment',
      date: DateTime.now().subtract(Duration(days: 4)),
      imagePath: null,
    ),
    Transaction(
      id: '9',
      text: 'Phone Bill',
      amount: -30.0,
      type: TransactionType.expense,
      category: 'Utilities',
      date: DateTime.now().subtract(Duration(days: 5)),
      imagePath: null,
    ),
    Transaction(
      id: '10',
      text: 'Gift',
      amount: 100.0,
      type: TransactionType.income,
      category: 'Other',
      date: DateTime.now().subtract(Duration(days: 6)),
      imagePath: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.transparent],
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
              RecentTransactionsWidget(transactions: transactions),
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
          ),
        ],
      ),
    );
  }
}
