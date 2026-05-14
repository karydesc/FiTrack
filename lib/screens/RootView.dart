import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:personalfinancetracker/models/Account.dart";

import "package:personalfinancetracker/models/Transaction.dart";
import "package:personalfinancetracker/screens/StatisticsScreen.dart";
import "package:personalfinancetracker/services/HiveService.dart";
import "TransactionsScreen.dart";
import "MainScreen.dart";

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int selectedPage = 0;

  

  void addOrEditTransactionModal(Transaction? transaction) {
    if (HiveService().getAllAccounts().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("To add a transaction, you need to create an account."),
        ),
      );
      return;
    }
    final TextEditingController nameController = TextEditingController(); //if we pass a transaction, we want to prefill the text fields with the transaction's data, otherwise they should be empty for a new transaction
    final TextEditingController amountController = TextEditingController();
    nameController.text = transaction?.text ?? '';
    amountController.text = transaction?.amount.toString() ?? '';
    String transactionType = transaction?.type ?? '';
    String transactionCategory = transaction?.category ?? '';
    String accountIDdest = transaction?.accountId ?? '';
    DateTime date = transaction?.date ?? DateTime.now();

    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Transaction",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Label"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    onSelected: (value) => transactionType = value!,
                    initialSelection: transactionType.isNotEmpty ? transactionType : null,
                    label: Text("Type"),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "incoming", label: "Incoming"),
                      DropdownMenuEntry(value: "outgoing", label: "Outgoing"),
                    ],
                  ),
                  const SizedBox(width: 12),
                  DropdownMenu(
                    onSelected: (value) => transactionCategory = value!,
                    initialSelection: transactionCategory.isNotEmpty ? transactionCategory : null,
                    label: Text("Category"),
                    width: 165,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "food", label: "Food"),
                      DropdownMenuEntry(value: "transport", label: "Transport"),
                      DropdownMenuEntry(value: "entertainment", label: "Entertainment"),
                      DropdownMenuEntry(value: "utilities", label: "Utilities"),
                      DropdownMenuEntry(value: "health", label: "Health"),
                      DropdownMenuEntry(value: "education", label: "Education"),
                      DropdownMenuEntry(value: "shopping", label: "Shopping"),
                      DropdownMenuEntry(value: "salary", label: "Salary"),
                      DropdownMenuEntry(value: "investment", label: "Investment"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              DropdownMenu(
                onSelected: (value) => accountIDdest = value!,
                initialSelection: accountIDdest.isNotEmpty ? accountIDdest : null,
                label: Text("Account"),
                dropdownMenuEntries: HiveService().getAllAccounts()
                    .map((x) => DropdownMenuEntry(value: x.id, label: x.name))
                    .toList(),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 90,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Image"),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (accountIDdest.isEmpty ||
                              transactionType.isEmpty ||
                              transactionCategory.isEmpty ||
                              nameController.text.isEmpty ||
                              amountController.text.isEmpty) {
                            return;
                          }

                          Transaction tempTransaction = Transaction(
                            id: transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), 
                            text: nameController.text,
                            amount: double.tryParse(amountController.text) ?? 0.0,
                            type: transactionType,
                            category: "${transactionCategory[0].toUpperCase()}${transactionCategory.substring(1)}",
                            date: date,
                            accountId: accountIDdest,
);
                      
                          nameController.clear();
                          amountController.clear();
                          HiveService().addTransaction(tempTransaction);
                          Navigator.pop(context);
                        },
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    final pages = [
      MainScreen(
        allTransactionsTap: () {
          setState(() {
            selectedPage = 1;
          });
        },
        addTransactionModal: addOrEditTransactionModal,
      ),
      TransactionsScreen(
        addOrEditTransactionModal: addOrEditTransactionModal,
      ),
      StatisticsScreen(),
    ];
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Transaction>('transactionsBox').listenable(),
        builder: (context, value, child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<Account>('accountsBox').listenable(),
            builder: (context, value, child) {
              return pages[selectedPage];
            }
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            selectedPage = index;
          }),
        },
        currentIndex: selectedPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
          ),
        ],
      ),
    );
  }
}
