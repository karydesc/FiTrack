import "package:flutter/material.dart";
import "package:personalfinancetracker/models/Transaction.dart";
import "package:personalfinancetracker/screens/StatisticsScreen.dart";
import "HistoryScreen.dart";
import "MainScreen.dart";

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int selectedPage = 0;
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
    final pages = [
      MainScreen(transactions: transactions),
      HistoryScreen(transactions: transactions),
      StatisticsScreen(),
    ];
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            selectedPage = index;
          }),
        },
        currentIndex: selectedPage,
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
