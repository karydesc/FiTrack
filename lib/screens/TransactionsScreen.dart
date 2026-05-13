import 'package:flutter/material.dart';
import 'package:personalfinancetracker/models/Account.dart';
import 'package:personalfinancetracker/models/Transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personalfinancetracker/widgets/list_item.dart';

class TransactionsScreen extends StatefulWidget {
  final Function addTransactionModal;
  const TransactionsScreen({super.key, required this.addTransactionModal});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final Box<Account> accountsBox = Hive.box<Account>('accountsBox');
  final Box<Transaction> transactionsBox = Hive.box<Transaction>(
    'transactionsBox',
  );

  String? selectedAccountID;

  void openTransactionDetailsModal(
    Transaction transaction,
    BuildContext context,
  ) {
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
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_horiz),
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
                              action: openTransactionDetailsModal,
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
          widget.addTransactionModal();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
