import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kalapi/utils/color_resources.dart';
import 'package:kalapi/view/pages/home/model/graph_api_res.dart';

class RevenueChartCard extends StatelessWidget {
  final List<double> current; // actual values
  final List<double> previous; // actual values
  final String currentLabel;
  final String previousLabel;
  final GraphApiRes? graphData;

  const RevenueChartCard({
    super.key,
    required this.current,
    required this.previous,
    this.currentLabel = 'Current',
    this.previousLabel = 'Previous',
    this.graphData,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColorStudent(context);
    final secondaryColor = AppColors.primaryColorOwner(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Chart',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (current.isNotEmpty || previous.isNotEmpty)
                      Text(
                        'Order statistics',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                  ],
                ),
              ),
              // Legend
              if (current.isNotEmpty || previous.isNotEmpty)
                _buildLegend(context),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 280,
            child: _buildChart(context, primaryColor, secondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (current.isNotEmpty) ...[
          _LegendItem(
            color: Colors.white,
            label: currentLabel.isNotEmpty ? currentLabel : 'Current',
          ),
          if (previous.isNotEmpty) const SizedBox(width: 16),
        ],
        if (previous.isNotEmpty)
          _LegendItem(
            color: const Color(0xFFFFB74D),
            label: previousLabel.isNotEmpty ? previousLabel : 'Previous',
          ),
      ],
    );
  }

  Widget _buildChart(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    if (current.isEmpty && previous.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No data available',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    final maxLength =
        current.length > previous.length ? current.length : previous.length;

    // Calculate Y-axis max
    final allValues = [...current, ...previous];
    final maxValue =
        allValues.isNotEmpty
            ? (allValues.reduce((a, b) => a > b ? a : b) * 1.15)
                .ceil()
                .toDouble()
            : 100.0;
    final minValue = 0.0;

    // Get date labels
    final dateLabels = _getDateLabels();

    // Calculate X-axis interval
    final xAxisInterval = _calculateXAxisInterval(maxLength);

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: maxValue / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: xAxisInterval.toDouble(),
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= maxLength) {
                  return const SizedBox.shrink();
                }

                // Show label based on interval
                if (i % xAxisInterval != 0 && i != maxLength - 1) {
                  return const SizedBox.shrink();
                }

                String label;
                if (dateLabels.isNotEmpty && i < dateLabels.length) {
                  label = dateLabels[i];
                } else {
                  label = '${i + 1}';
                }

                // Rotate text if there are many data points
                final shouldRotate = maxLength > 10;

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Transform.rotate(
                    angle:
                        shouldRotate ? -0.5 : 0, // Rotate ~30 degrees if needed
                    child: Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: maxValue > 0 ? (maxValue / 5).ceil().toDouble() : 1000,
              getTitlesWidget: (value, meta) {
                if (value < minValue) return const SizedBox.shrink();
                // Format with proper number formatting
                final formattedValue = _formatCurrency(value);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    formattedValue,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue,
        barGroups: _buildBarGroups(
          context,
          primaryColor,
          secondaryColor,
          maxValue,
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final index = group.x.toInt();
              String dateLabel = '';
              String seriesLabel = '';

              // Get date label if available
              if (graphData != null &&
                  graphData!.chart != null &&
                  graphData!.chart!.series != null &&
                  graphData!.chart!.series!.isNotEmpty) {
                // Determine which series this bar belongs to
                if (rodIndex == 0 &&
                    graphData!.chart!.series![0].data != null) {
                  final dataPoints = graphData!.chart!.series![0].data!;
                  if (index >= 0 && index < dataPoints.length) {
                    final date = dataPoints[index].date;
                    if (date != null) {
                      try {
                        final dateTime = DateTime.parse(date);
                        dateLabel = DateFormat('MMM dd, yyyy').format(dateTime);
                      } catch (e) {
                        dateLabel = date;
                      }
                    }
                    seriesLabel =
                        graphData!.chart!.series![0].name ?? currentLabel;
                  }
                } else if (rodIndex == 1 &&
                    graphData!.chart!.series!.length > 1 &&
                    graphData!.chart!.series![1].data != null) {
                  final dataPoints = graphData!.chart!.series![1].data!;
                  if (index >= 0 && index < dataPoints.length) {
                    final date = dataPoints[index].date;
                    if (date != null) {
                      try {
                        final dateTime = DateTime.parse(date);
                        dateLabel = DateFormat('MMM dd, yyyy').format(dateTime);
                      } catch (e) {
                        dateLabel = date;
                      }
                    }
                    seriesLabel =
                        graphData!.chart!.series![1].name ?? previousLabel;
                  }
                }
              }

              final value = rod.toY;
              // Show actual value in tooltip with proper formatting
              final formattedValue = _formatActualCurrency(value);

              String tooltipText = '';
              if (dateLabel.isNotEmpty) {
                tooltipText = '$dateLabel';
              }
              if (seriesLabel.isNotEmpty) {
                tooltipText +=
                    tooltipText.isNotEmpty ? '\n$seriesLabel' : seriesLabel;
              }
              tooltipText +=
                  tooltipText.isNotEmpty ? '\n$formattedValue' : formattedValue;

              return BarTooltipItem(
                tooltipText,
                GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<String> _getDateLabels() {
    if (graphData == null ||
        graphData!.chart == null ||
        graphData!.chart!.series == null ||
        graphData!.chart!.series!.isEmpty ||
        graphData!.chart!.series![0].data == null) {
      return [];
    }

    final dataPoints = graphData!.chart!.series![0].data!;
    return dataPoints.map((d) {
      if (d.date == null) return '';
      try {
        final date = DateTime.parse(d.date!);
        // More compact formatting based on data length
        if (dataPoints.length > 20) {
          // For many points, show just day number
          return DateFormat('d').format(date);
        } else if (dataPoints.length > 10) {
          // For medium datasets, show day/month
          return DateFormat('d/M').format(date);
        } else if (dataPoints.length > 7) {
          // For smaller datasets, show abbreviated month and day
          return DateFormat('MMM d').format(date);
        } else {
          // For very small datasets, show full date
          return DateFormat('MMM dd').format(date);
        }
      } catch (e) {
        if (d.date!.length >= 10) {
          return d.date!.substring(5, 10);
        }
        return d.date!;
      }
    }).toList();
  }

  int _calculateXAxisInterval(int maxLength) {
    if (maxLength > 30) {
      return (maxLength / 8).ceil();
    } else if (maxLength > 15) {
      return (maxLength / 5).ceil();
    } else if (maxLength > 7) {
      return 2;
    }
    return 1;
  }

  List<BarChartGroupData> _buildBarGroups(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
    double maxY,
  ) {
    final maxLength =
        current.length > previous.length ? current.length : previous.length;

    return List.generate(maxLength, (index) {
      double currentValue = 0.0;
      double previousValue = 0.0;

      if (index < current.length) {
        currentValue = current[index];
      }
      if (index < previous.length) {
        previousValue = previous[index];
      }

      List<BarChartRodData> rods = [];

      // Add current bar if there's data (even if value is 0)
      if (index < current.length) {
        rods.add(
          BarChartRodData(
            toY: currentValue,
            color: Colors.white,
            width: (previous.isNotEmpty && index < previous.length) ? 12 : 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: Colors.white.withOpacity(0.1),
              toY: maxY,
            ),
          ),
        );
      }

      // Add previous bar if there's data (even if value is 0)
      if (previous.isNotEmpty && index < previous.length) {
        rods.add(
          BarChartRodData(
            toY: previousValue,
            color: const Color(0xFFFFB74D),
            width: (current.isNotEmpty && index < current.length) ? 12 : 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: Colors.white.withOpacity(0.1),
              toY: maxY,
            ),
          ),
        );
      }

      // If no data at all, return empty transparent bar
      if (rods.isEmpty) {
        rods.add(BarChartRodData(toY: 0, color: Colors.transparent, width: 16));
      }

      return BarChartGroupData(
        x: index,
        barRods: rods,
        barsSpace: rods.length > 1 ? 4 : 0,
      );
    });
  }

  String _formatCurrency(double value) {
    // Format for Y-axis labels (abbreviated)
    if (value >= 100000) {
      // For values >= 1 lakh
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      // For values >= 1 thousand
      return '₹${(value / 1000).toStringAsFixed(1)}k';
    } else {
      // For values < 1 thousand, show as integer
      return '₹${value.toInt()}';
    }
  }

  String _formatActualCurrency(double value) {
    // Format for tooltips (actual value with commas and proper formatting)
    final formatter = NumberFormat('#,##0.00', 'en_IN');
    final formatted = formatter.format(value);
    // Remove .00 if it's a whole number
    if (formatted.endsWith('.00')) {
      return '₹${formatted.replaceAll('.00', '')}';
    }
    return '₹$formatted';
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
