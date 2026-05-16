import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
        child: Container(
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
                    child: DropdownMenu(
                      onSelected: (value) {
                        // Handle selection change
                      },
                      initialSelection: "Category",
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: "Category", label: "Category"),
                        DropdownMenuEntry(value: "Account", label: "Account"),
                        DropdownMenuEntry(value: "Month", label: "Month"),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white54, height: 32, thickness: 1.5),
              SizedBox(height: 32),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 40,
                        color: Colors.red,
                        title: "Food",
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Colors.blue,
                        title: "Transport",
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.green,
                        title: "Entertainment",
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.orange,
                        title: "Other",
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.orange,
                        title: "Other",
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.orange,
                        title: "Other",
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
