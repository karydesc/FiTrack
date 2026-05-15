import 'package:FiTrack/models/Account.dart';
import 'package:FiTrack/models/Transaction.dart';
import 'package:FiTrack/screens/RootView.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(TransactionAdapter());

  await Hive.openBox<Account>('accountsBox');
  await Hive.openBox<Transaction>('transactionsBox');

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
