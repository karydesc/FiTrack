import 'package:fitrack/services/HiveService.dart';
import 'package:fitrack/widgets/pie_chart_widget%20_account.dart';
import 'package:fitrack/widgets/pie_chart_widget_category.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedPieChartIndex = 0;
  String selectedChartAccount = "none";
  int _mainPageIndex = 0;

  final PageController _pieChartPageController = PageController();

  @override
  void dispose() {
    _pieChartPageController.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    _mainPageIndex = index;
                  });
                },
                children: [buildPieChartView(), buildBarChartView()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildDot(0), const SizedBox(width: 8), buildDot(1)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: _mainPageIndex == index ? 24 : 10,
      decoration: BoxDecoration(
        color: _mainPageIndex == index
            ? Theme.of(context).primaryColor
            : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Container buildBarChartView() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Chart for Account: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                constraints: BoxConstraints(maxWidth: 150, maxHeight: 50),
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
          const SizedBox(height: 32),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            height: 380,
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
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: buildBarGroupsForAccount(selectedChartAccount),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildPieChartView() {
    return Container(
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
                constraints: BoxConstraints(maxWidth: 150, maxHeight: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton(
                  onSelected: (value) {
                    _pieChartPageController.animateToPage(
                      value,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );

                    setState(() {
                      selectedPieChartIndex = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 0, child: Text("Category")),
                    const PopupMenuItem(value: 1, child: Text("Account")),
                  ],
                  child: Chip(
                    label: Text(
                      selectedPieChartIndex == 0 ? "CATEGORY" : "ACCOUNT",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    avatar: Icon(
                      selectedPieChartIndex == 0
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
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            height: 500,
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
            child: PageView(
              controller: _pieChartPageController,
              onPageChanged: (value) => setState(() {
                selectedPieChartIndex = value;
              }),
              children: [
                pie_chart_widget_category(),
                pie_chart_widget_account(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> buildBarGroupsForAccount(
    String selectedChartAccount,
  ) {
    if (selectedChartAccount == "none") {
      return [];
    }

    double previousBalance = HiveService().getBalanceUptoDate(
      DateTime.now().subtract(Duration(days: 60)),
      selectedChartAccount,
    );

    final spendingMap = HiveService().getAccountSpendingInRange(
      selectedChartAccount,
      DateTime.now().subtract(Duration(days: 60)),
      DateTime.now(),
      previousBalance,
    );

    List<BarChartGroupData> barGroups = [];
    int index = 0;
    spendingMap.forEach((date, amount) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: amount >= 0 ? Colors.green : Colors.red,
              width: 10,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      index++;
    });
    return barGroups;
  }
}
