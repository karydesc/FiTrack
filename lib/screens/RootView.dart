import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:hive/hive.dart";
import "package:personalfinancetracker/models/Account.dart";
import "package:personalfinancetracker/models/Transaction.dart";
import "package:personalfinancetracker/screens/StatisticsScreen.dart";
import "TransactionsScreen.dart";
import "MainScreen.dart";

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int selectedPage = 0;

  void addTransactionModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String transactionType = '';
    String transactionCategory = '';
    String accountIDdest = '';

    final transactionBox = Hive.box<Transaction>("transactionsBox");
    final accountsBox = Hive.box<Account>("accountsBox");

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
                "New Transaction",
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
                maxLength: 5,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    onSelected: (value) => transactionType = value!,
                    label: Text("Type"),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "incoming", label: "Incoming"),
                      DropdownMenuEntry(value: "outgoing", label: "Outgoing"),
                    ],
                  ),
                  const SizedBox(width: 12),
                  DropdownMenu(
                    onSelected: (value) => transactionCategory = value!,
                    label: Text("Category"),
                    width: 165,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "income", label: "Income"),
                      DropdownMenuEntry(value: "housing", label: "Housing"),
                      DropdownMenuEntry(
                        value: "transportation",
                        label: "Transportation",
                      ),
                      DropdownMenuEntry(value: "lifestyle", label: "Lifestyle"),
                      DropdownMenuEntry(value: "transfer", label: "Transfer"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              DropdownMenu(
                onSelected: (value) => accountIDdest = value!,
                label: Text("Account"),
                dropdownMenuEntries: accountsBox.values
                    .map((x) => DropdownMenuEntry(value: x.id, label: x.name))
                    .toList(),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
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
                            id: DateTime.now().toString(),
                            text: nameController.text,
                            amount:
                                double.tryParse(amountController.text) ?? 0.0,
                            type: transactionType,
                            category: transactionCategory,
                            date: DateTime.now(),
                            accountId: accountIDdest,
                          );

                          transactionBox.put(
                            tempTransaction.id,
                            tempTransaction,
                          );
                          nameController.clear();
                          amountController.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Save Transaction"),
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
        addTransactionModal: addTransactionModal,
      ),
      TransactionsScreen(addTransactionModal: addTransactionModal),
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
