import 'package:FiTrack/screens/StatisticsScreen.dart';
import 'package:FiTrack/services/HiveService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var categoryColors = <String, Color>{};

class pie_chart_widget_category extends StatelessWidget {
  const pie_chart_widget_category({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          width: 200,
          child: PieChart(PieChartData(sections: buildSections().toList())),
        ),
        const SizedBox(width: 32),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories",
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
            }),
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
        value: spending,
        title: "", //
        color: Colors
            .primaries[categories.indexOf(category) % Colors.primaries.length],
      );
    });
  }
}
