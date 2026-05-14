import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personalfinancetracker/models/Account.dart';
import 'package:personalfinancetracker/services/HiveService.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  void showAddAccountModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,

      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom, // Keyboard padding
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "New Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              
              const SizedBox(height: 24),
              SizedBox(

                child: ElevatedButton(
                  onPressed: () {
                    final newAccount = Account(
                      id: DateTime.now().millisecondsSinceEpoch
                          .toString(), // random ID
                      name: nameController.text,
                    );
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account name cannot be empty."),
                        ),
                      );
                      return;
                    }
                    HiveService().addAccount(newAccount);
                
                    nameController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white),
                  child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void showAccountDetailsModal(Account account) {
    nameController.text = account.name;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: Hive.box<Account>('accountsBox').listenable(),
          builder: (context, value, child) {
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
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Account Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.fingerprint,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Account ID",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  account.id,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "\$${HiveService().getAccountBalance(account).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Account Name",
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final newAccount = Account(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                      );
                      HiveService().addAccount(newAccount); 
                      nameController.clear();
                      Navigator.pop(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () {
                        HiveService().deleteAccount(account);
                        nameController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        );
      },
    );
  }

  final Box<Account> accountsBox = Hive.box<Account>('accountsBox');

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Accounts"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColor, Colors.white],
            )
          ),
        child: ValueListenableBuilder(
          valueListenable: accountsBox.listenable(),
          builder: (context, Box<Account> box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text("No accounts created"));
            }
        
            final accounts = box.values.toList();
        
            return ListView.builder(
              itemCount: accounts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  color: Color.fromARGB(190, 238, 238, 238),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      showAccountDetailsModal(account);
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.account_balance_wallet),
                    ),
                    title: Text(
                      account.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "\$${HiveService().getAccountBalance(account).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, color:  HiveService().getAccountBalance(account) >= 0 ? const Color.fromARGB(255, 2, 138, 7) : const Color.fromARGB(255, 245, 72, 59), fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddAccountModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
