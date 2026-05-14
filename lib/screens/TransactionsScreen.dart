import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Account.dart';
import 'package:personalfinancetracker/models/Transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personalfinancetracker/screens/SingleTransactionScreen.dart';
import 'package:personalfinancetracker/widgets/list_item.dart';

class TransactionsScreen extends StatefulWidget {
  final Function(Transaction?) addOrEditTransactionModal;
  const TransactionsScreen({
    super.key,
    required this.addOrEditTransactionModal,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final Box<Account> accountsBox = Hive.box<Account>('accountsBox');
  final Box<Transaction> transactionsBox = Hive.box<Transaction>(
    'transactionsBox',
  );

  String? selectedAccountID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        titleTextStyle: const TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: accountsBox.listenable(),
        builder: (context, Box<Account> accBox, _) {
          if (accBox.values.isEmpty) {
            return const Center(child: Text("No accounts created"));
          }

          final currentSelection = selectedAccountID ?? accBox.values.first.id;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Theme.of(context).primaryColor, Colors.white],
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  spacing: 18,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Account:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: DropdownMenu<String>(
                        initialSelection: currentSelection,
                        onSelected: (String? newId) {
                          if (newId != null) {
                            setState(() {
                              selectedAccountID = newId;
                            });
                          }
                        },
                        dropdownMenuEntries: accBox.values
                            .map(
                              (account) => DropdownMenuEntry<String>(
                                value: account.id,
                                label: account.name,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: transactionsBox.listenable(),
                    builder: (context, Box<Transaction> transactBox, _) {
                      final accountTransactions = transactBox.values
                          .where((t) => t.accountId == currentSelection)
                          .toList();

                      if (accountTransactions.isEmpty) {
                        return const Center(
                          child: Text(
                            "No recorded transactions for this account.",
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: accountTransactions.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            final transaction = accountTransactions[index];
                            return ListItem(
                              transaction: transaction,
                              action:
                                  (
                                    Transaction transaction,
                                    BuildContext context,
                                  ) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (context) =>
                                            SingleTransactionScreen(
                                              context: context,
                                              transaction: transaction,
                                              addOrEditTransactionModal:
                                                  widget.addOrEditTransactionModal,
                                            ),
                                      ),
                                    );
                                  },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.addOrEditTransactionModal(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
