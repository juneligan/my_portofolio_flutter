import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Clicks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: _generateBarData(),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // ✅ Increase space for Y-axis labels
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8), // ✅ Add space
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12), // ✅ Adjust font size if needed
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Transform.rotate(
                          angle: -0.5,
                          child: Text("2024-07-${value.toInt()}", style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "2024-07-${group.x.toInt()}\nTotal Clicks: ${rod.toY.toInt()}",
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       "Linklytics",
    //       style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
    //     ),
    //     flexibleSpace: Container(
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [Colors.blue, Colors.purple],
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //         ),
    //       ),
    //     ),
    //     actions: [
    //       TextButton(onPressed: () {}, child: const Text("Home", style: TextStyle(color: Colors.white))),
    //       TextButton(onPressed: () {}, child: const Text("About", style: TextStyle(color: Colors.white))),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    //           onPressed: () {},
    //           child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body:
    // );
  }

  List<BarChartGroupData> _generateBarData() {
    final data = [
      30, 50, 20, 100, 170, 250, 90, 300, 80, 150, 200, 100, 180, 120, 200
    ];
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index + 3,
        barRods: [
          BarChartRodData(toY: data[index].toDouble(), color: Colors.blue, width: 15),
        ],
      );
    });
  }
}
