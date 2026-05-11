import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Transaction.dart';
import 'package:personalfinancetracker/widgets/recent_transactions_widget.dart';

class HistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;
  const HistoryScreen({super.key, required this.transactions});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
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
            ],
          ),
        ),
      ),
    );
  }
}
