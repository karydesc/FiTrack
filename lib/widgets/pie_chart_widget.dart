import 'package:FiTrack/screens/StatisticsScreen.dart';
import 'package:FiTrack/services/HiveService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class pie_chart_widget extends StatelessWidget {
  const pie_chart_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 190,
          width: 190,
          child: PieChart(PieChartData(sections: buildSections().toList())),
        ),
        const SizedBox(width: 32),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Spending",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...categoryColors.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key, // The category name!
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }), // Note: Removed the curly braces after the arrow!
          ],
        ),
      ],
    );
  }

  Iterable<PieChartSectionData> buildSections() {
    final spendingPerCategoryMap = HiveService().getTotalSpendingByCategory();
    final categories = spendingPerCategoryMap.keys.toList();

    return categories.map((category) {
      final spending = spendingPerCategoryMap[category] ?? 0;
      categoryColors[category] = Colors
          .primaries[categories.indexOf(category) % Colors.primaries.length];

      return PieChartSectionData(
        title: "${spending.toStringAsFixed(2)}€",
        value: spending,
        titleStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          backgroundColor: Colors.white70,
        ),
        color: Colors
            .primaries[categories.indexOf(category) % Colors.primaries.length],
      );
    });
  }
}
