import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<Color> _gradientColors = [
    Colors.blue[300]!,
    Colors.greenAccent[200]!,
  ];

  final _gridLine = FlLine(
    color: Colors.grey[800],
    strokeWidth: 1,
  );

  final _axisLabelStyle = TextStyle(
    color: Colors.grey[400],
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  final _greyBorder = FlBorderData(
    show: true,
    border: Border.all(color: Colors.grey[700]!, width: 1),
  );

  FlGridData get _greyVertAndHorizGrid => FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) => _gridLine,
      getDrawingVerticalLine: (value) => _gridLine);

  final List<FlSpot> data = [
    FlSpot(0, 3),
    FlSpot(2.6, 2),
    FlSpot(4.9, 5),
    FlSpot(6.8, 3.1),
    FlSpot(8, 4),
    FlSpot(9.5, 3),
    FlSpot(11, 4),
  ];

  @override
  Widget build(BuildContext context) => LineChart(LineChartData(
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      titlesData: _xyAxisLabels,
      lineBarsData: [_priceData],
      gridData: _greyVertAndHorizGrid,
      borderData: _greyBorder));

  FlTitlesData get _xyAxisLabels => FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: _xAxisLabels,
      leftTitles: _yAxisLabels);

  SideTitles get _xAxisLabels => SideTitles(
      showTitles: true,
      // Height available to label
      reservedSize: 22,
      margin: 8,
      interval: 1,
      getTextStyles: (context, value) => _axisLabelStyle,
      getTitles: (value) {
        switch (value.toInt()) {
          case 2:
            return '3wk';
          case 5:
            return '2wk';
          case 8:
            return '1wk';
        }
        return '';
      });

  SideTitles get _yAxisLabels => SideTitles(
      showTitles: true,
      interval: 1,
      reservedSize: 32,
      margin: 12,
      getTextStyles: (context, value) => _axisLabelStyle,
      getTitles: (value) {
        final v = value.toInt();
        return v % 2 == 0 ? '\$$v' : '';
      });

  LineChartBarData get _priceData => LineChartBarData(
      spots: data,
      isCurved: true,
      colors: _gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ));
}
