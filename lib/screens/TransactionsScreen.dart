import 'package:FiTrack/models/Account.dart';
import 'package:FiTrack/models/Transaction.dart';
import 'package:FiTrack/screens/SingleTransactionScreen.dart';
import 'package:FiTrack/services/HiveService.dart';
import 'package:FiTrack/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  String? selectedAccountID;
  String selectedTypeFilter = "all";
  bool dateFilterEnabled = false;
  DateTimeRange? selectedDateRange;
  bool sortEnable = false;
  bool sortAscending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        titleTextStyle: const TextStyle(fontSize: 30),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.white],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: HiveService().accountsListenable,
          builder: (context, Box<Account> accBox, _) {
            if (HiveService().getAllAccounts().isEmpty) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                    color: const Color.fromARGB(114, 238, 238, 238),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Text(
                    "No accounts created",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            final currentSelection = selectedAccountID ?? "all";

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).primaryColor, Colors.white],
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  accountSelector(currentSelection, accBox),
                  const SizedBox(height: 12),

                  // Added horizontal scrolling here so the chips don't overflow!
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          initialValue: selectedTypeFilter,
                          onSelected: (String value) {
                            setState(() {
                              selectedTypeFilter = value;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'all',
                                  child: Text('All Types'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'incoming',
                                  child: Text('Incoming'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'outgoing',
                                  child: Text('Outgoing'),
                                ),
                              ],
                          child: Chip(
                            label: Text(
                              selectedTypeFilter == "all"
                                  ? "All Types"
                                  : (selectedTypeFilter == "incoming"
                                        ? "Incoming"
                                        : "Outgoing"),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            avatar: const Icon(Icons.filter_list, size: 18),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(
                            selectedDateRange == null
                                ? "Date Filter"
                                : "${selectedDateRange!.start.day}/${selectedDateRange!.start.month} - ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          selected: dateFilterEnabled,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          showCheckmark: true,
                          onSelected: (bool selected) async {
                            if (selected) {
                              final dateRange = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (dateRange != null) {
                                setState(() {
                                  selectedDateRange = dateRange;
                                  dateFilterEnabled = true;
                                });
                              }
                            } else {
                              setState(() {
                                dateFilterEnabled = false;
                                selectedDateRange = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text(
                            "Sort by Date",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          selected: sortEnable,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          showCheckmark: true,
                          onSelected: (bool selected) {
                            setState(() => sortEnable = selected);
                          },
                        ),
                        if (sortEnable)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                sortAscending = !sortAscending;
                              });
                            },
                            icon: Icon(
                              sortAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.grey[800],
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  transactions_list(
                    currentSelection: currentSelection,
                    widget: widget,
                    selectedTypeFilter: selectedTypeFilter,
                    selectedDateRange: dateFilterEnabled
                        ? selectedDateRange
                        : null,
                    sortEnable: sortEnable,
                    sortAscending: sortAscending,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Row accountSelector(String currentSelection, Box<Account> accBox) {
    return Row(
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
            dropdownMenuEntries: [
              const DropdownMenuEntry<String>(
                value: "all",
                label: "All Accounts",
              ),
              ...accBox.values.map(
                (account) => DropdownMenuEntry<String>(
                  value: account.id,
                  label: account.name,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class transactions_list extends StatelessWidget {
  const transactions_list({
    super.key,
    required this.currentSelection,
    required this.widget,
    required this.selectedTypeFilter,
    required this.selectedDateRange,
    required this.sortEnable,
    required this.sortAscending,
  });

  final String currentSelection;
  final TransactionsScreen widget;
  final String selectedTypeFilter;
  final DateTimeRange? selectedDateRange;
  final bool sortEnable;
  final bool sortAscending;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: HiveService().transactionsListenable,
        builder: (context, Box<Transaction> transactBox, _) {
          List<Transaction> accountTransactions = transactBox.values.where((t) {
            if (currentSelection != "all" && t.accountId != currentSelection) {
              return false;
            }
            if (selectedTypeFilter != "all" && t.type != selectedTypeFilter) {
              return false;
            }
            if (selectedDateRange != null) {
              final txDate = DateTime(t.date.year, t.date.month, t.date.day);
              final start = DateTime(
                selectedDateRange!.start.year,
                selectedDateRange!.start.month,
                selectedDateRange!.start.day,
              );
              final end = DateTime(
                selectedDateRange!.end.year,
                selectedDateRange!.end.month,
                selectedDateRange!.end.day,
              );
              if (txDate.isBefore(start) || txDate.isAfter(end)) {
                return false;
              }
            }
            return true;
          }).toList();

          if (sortEnable) {
            accountTransactions.sort((a, b) {
              return sortAscending
                  ? a.date.compareTo(b.date)
                  : b.date.compareTo(a.date);
            });
          } else {
            accountTransactions = accountTransactions.reversed.toList();
          }

          if (accountTransactions.isEmpty) {
            return const Center(child: Text("No recorded transactions found."));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: accountTransactions.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final transaction = accountTransactions[index];
                return ListItem(
                  transaction: transaction,
                  action: (Transaction transaction, BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => SingleTransactionScreen(
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
    );
  }
}
