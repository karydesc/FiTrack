import 'package:fitrack/services/HiveService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class pie_chart_widget_account extends StatelessWidget {
  const pie_chart_widget_account({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService().accountsListenable,
      builder: (context, value, child) {
        Map<String, double> accountSpendings = HiveService()
            .getSpendingByAccount();

        return Column(
          children: [
            SizedBox(
              height: 210,
              width: 190,
              child: PieChart(
                PieChartData(
                  sections: buildSections(accountSpendings).toList(),
                ),
              ),
            ),
            const SizedBox(width: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Accounts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                ...accountSpendings.entries.map((entry) {
                  int colorindex = 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color:
                                Colors.primaries[colorindex++ %
                                    Colors.primaries.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          HiveService()
                              .getAccount(entry.key)!
                              .name, // The category name!
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }

  Iterable<PieChartSectionData> buildSections(
    Map<String, double> accountSpendings,
  ) {
    List<PieChartSectionData> sections = [];
    int colorindex = 0;
    accountSpendings.forEach((account, amount) {
      Color color = Colors.primaries[colorindex++ % Colors.primaries.length];
      sections.add(
        PieChartSectionData(
          titlePositionPercentageOffset: 0.8,
          value: amount,
          title: HiveService().getAccount(account)!.name,
          titleStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,

            backgroundColor: Colors.white70,
          ),
          color: color,
          radius: 50,
        ),
      );
    });
    return sections;
  }
}
