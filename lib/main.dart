import 'dart:math';

import 'package:fitrack/models/Account.dart';
import 'package:fitrack/models/Transaction.dart';
import 'package:fitrack/screens/RootView.dart';
import 'package:fitrack/services/HiveService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(TransactionAdapter());

  await Hive.openBox<Account>('accountsBox');
  await Hive.openBox<Transaction>('transactionsBox');
  // injectDemoData(); // Comment out this line after the initial demo data injection to avoid creating duplicate demo accounts and transactions on every app launch.
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Finance Tracker",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: RootView(),
    );
  }
}

//Ai generated demo data injection function, creates a demo account and populates it with 40 random transactions of varying types, categories, amounts, and dates within the last 60 days. Can be called from a button in the UI for testing purposes.
void injectDemoData() {
  final demoAccount = Account(
    id: "demo_account_${DateTime.now().millisecondsSinceEpoch}",
    name: "Demo Bank Account",
  );
  HiveService().addAccount(demoAccount);

  final random = Random();
  final categories = [
    "Food",
    "Transport",
    "Entertainment",
    "Utilities",
    "Health",
    "Education",
    "Shopping",
    "Other",
  ];

  // Create 150 fake transactions
  for (int i = 0; i < 150; i++) {
    // Make 1 out of every 8 transactions an income (like a weekly salary)
    final isIncome = i % 8 == 0;
    final category = isIncome
        ? "Salary"
        : categories[random.nextInt(categories.length)];
    final type = isIncome ? "incoming" : "outgoing";

    // Random amount: Income between $500-$2000, Expenses between $5-$150
    final amount = isIncome
        ? 500.0 + random.nextInt(1500)
        : 5.0 + random.nextInt(145);

    // Random date within the last 60 days
    final randomDaysAgo = random.nextInt(60);
    final date = DateTime.now().subtract(Duration(days: randomDaysAgo));

    final transaction = Transaction(
      id: "demo_tx_$i${DateTime.now().millisecondsSinceEpoch}",
      text: "Demo $category",
      amount: amount,
      type: type,
      category: category,
      date: date,
      accountId: demoAccount.id,
    );

    HiveService().addTransaction(transaction);
  }
}
