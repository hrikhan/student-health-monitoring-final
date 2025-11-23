import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/storage/pulse_history_model.dart';

class HistoryChart extends StatelessWidget {
  const HistoryChart({
    super.key,
    required this.history,
  });

  final List<PulseHistoryModel> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(child: Text('no_history'.tr));
    }

    final spots = history
        .reversed
        .toList()
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.bpm.toDouble()))
        .toList();

    final gradientColors = [
      Colors.redAccent.withOpacity(0.8),
      Colors.orangeAccent.withOpacity(0.6),
    ];

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 36),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ),
        minY: 40,
        maxY: 200,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
