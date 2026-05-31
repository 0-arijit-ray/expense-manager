import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import 'dashboard_providers.dart';

/// Grouped income/expense bar chart for the selected period.
class IncomeExpenseBarChart extends StatelessWidget {
  final List<SeriesPoint> series;
  const IncomeExpenseBarChart(this.series, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxVal = series.fold<double>(
      0,
      (m, p) => [m, p.expense, p.income].reduce((a, b) => a > b ? a : b),
    );
    final interval = maxVal <= 0 ? 1.0 : maxVal / 4;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal == 0 ? 100 : maxVal * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  Money.compact(rod.toY),
                  TextStyle(color: scheme.onInverseSurface, fontSize: 12),
                );
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: scheme.outlineVariant.withValues(alpha: 0.4), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(Money.compact(value),
                      style: TextStyle(
                          fontSize: 9, color: scheme.onSurfaceVariant));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= series.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(series[i].label,
                        style: TextStyle(
                            fontSize: 10, color: scheme.onSurfaceVariant)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < series.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: series[i].expense,
                    color: scheme.error,
                    width: 7,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                  BarChartRodData(
                    toY: series[i].income,
                    color: scheme.primary,
                    width: 7,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Donut chart of spending split by category.
class CategoryDonut extends StatelessWidget {
  final List<CategorySlice> slices;
  const CategoryDonut(this.slices, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = slices.fold<double>(0, (s, e) => s + e.total);
    if (total <= 0) {
      return const SizedBox.shrink();
    }
    final top = slices.take(6).toList();

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 44,
                sections: [
                  for (final s in top)
                    PieChartSectionData(
                      value: s.total,
                      color: s.category != null
                          ? Color(s.category!.color)
                          : scheme.outline,
                      radius: 26,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in top)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: s.category != null
                                ? Color(s.category!.color)
                                : scheme.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.category?.name ?? 'Other',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          '${(s.total / total * 100).round()}%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
