import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalapi/utils/color_resources.dart';

class RevenueChartCard extends StatelessWidget {
  final List<double> current; // values in thousands
  final List<double> previous; // values in thousands
  final String currentLabel;
  final String previousLabel;

  const RevenueChartCard({
    super.key,
    required this.current,
    required this.previous,
    this.currentLabel = 'Current',
    this.previousLabel = 'Previous',
  });

  @override
  Widget build(BuildContext context) {
    final start = AppColors.primaryColorStudent(context);
    final end = AppColors.primaryColorOwner(context);
    final titleColor = Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: start.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: titleColor),
              const SizedBox(width: 8),
              Text(
                'Revenue',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const Spacer(),
              // Legend
              Row(
                children: [
                  _LegendDot(color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    currentLabel,
                    style: GoogleFonts.outfit(fontSize: 12, color: titleColor),
                  ),
                  const SizedBox(width: 12),
                  _LegendDot(color: const Color(0xFFFF8F00)),
                  const SizedBox(width: 6),
                  Text(
                    previousLabel,
                    style: GoogleFonts.outfit(fontSize: 12, color: titleColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 220, child: LineChart(_chartData(context))),
        ],
      ),
    );
  }

  LineChartData _chartData(BuildContext context) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Use provided data, pad/trim to 12 months
    List<double> y2025 = List<double>.from(current);
    List<double> y2024 = List<double>.from(previous);
    if (y2025.length < 12) {
      y2025 = [...y2025, ...List<double>.filled(12 - y2025.length, 0)];
    } else if (y2025.length > 12) {
      y2025 = y2025.sublist(0, 12);
    }
    if (y2024.length < 12) {
      y2024 = [...y2024, ...List<double>.filled(12 - y2024.length, 0)];
    } else if (y2024.length > 12) {
      y2024 = y2024.sublist(0, 12);
    }

    final white = Colors.white;
    const amber = Color(0xFFFF8F00);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine:
            (value) => FlLine(color: white.withOpacity(0.18), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              final i = value.toInt() - 1;
              if (i < 0 || i >= months.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  months[i],
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                '₹${value.toInt()}k',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.9),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 350,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: white,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [white.withOpacity(0.28), white.withOpacity(0.02)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          spots: [
            for (int i = 0; i < y2025.length; i++) FlSpot(i + 1, y2025[i]),
          ],
        ),
        LineChartBarData(
          isCurved: true,
          color: amber,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: [
            for (int i = 0; i < y2024.length; i++) FlSpot(i + 1, y2024[i]),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
