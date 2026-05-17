import 'package:FiTrack/services/HiveService.dart';
import 'package:FiTrack/widgets/pie_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Map<String, Color> categoryColors = {};

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String mode = "category";
  String selectedChartAccount = "none";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PageView(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Spending by ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 150,
                          maxHeight: 50,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PopupMenuButton(
                          onSelected: (value) {
                            setState(() {
                              mode = value.toString();
                            });
                          },

                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "category",
                              child: Text("Category"),
                            ),
                            const PopupMenuItem(
                              value: "account",
                              child: Text("Account"),
                            ),
                          ],
                          child: Chip(
                            label: Text(
                              mode.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            avatar: Icon(
                              mode == "category"
                                  ? Icons.category
                                  : Icons.account_balance,
                              size: 18,
                            ),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white54, height: 32, thickness: 1.5),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: pie_chart_widget(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Chart for account: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 150,
                          maxHeight: 50,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PopupMenuButton(
                          onSelected: (value) {
                            setState(() {
                              selectedChartAccount = value.toString();
                            });
                          },

                          itemBuilder: (context) {
                            final accounts = HiveService().getAllAccounts();
                            if (accounts.isEmpty) {
                              return [
                                const PopupMenuItem(
                                  value: "none",
                                  child: Text("No accounts"),
                                ),
                              ];
                            }
                            // final startingBalance = HiveService()
                            //     .getBalanceUptoDate(
                            //       DateTime.now(),
                            //       HiveService().getAccount(
                            //         selectedChartAccount,
                            //       )!,
                            //     );
                            return accounts
                                .map(
                                  (account) => PopupMenuItem(
                                    value: account.id,
                                    child: Text(account.name),
                                  ),
                                )
                                .toList();
                          },
                          child: Chip(
                            label: Text(
                              selectedChartAccount == "none"
                                  ? "Select account"
                                  : HiveService()
                                        .getAccount(selectedChartAccount)!
                                        .name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            avatar: Icon(Icons.account_balance, size: 18),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white54, height: 32, thickness: 1.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
