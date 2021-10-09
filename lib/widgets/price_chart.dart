import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  static final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  static const Color _horizontalGridLineColor = Color(0xff37434d);
  static const Color _verticalGridLineColor = Color(0xff37434d);
  static const Color _leftAxisLabelsColor = Color(0xff67727d);
  static const Color _bottomAxisLabelsColor = Color(0xff68737d);

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
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      titlesData: _titles,
      lineBarsData: _bars,
      gridData: _grid,
      borderData: _border,
    ));
  }

  FlTitlesData get _titles => FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: _bottomAxisLabels,
        leftTitles: _leftAxisLabels,
      );

  SideTitles get _bottomAxisLabels => SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: _bottomAxisLabelsColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'MAR';
            case 5:
              return 'JUN';
            case 8:
              return 'SEP';
          }
          return '';
        },
        margin: 8,
      );

  SideTitles get _leftAxisLabels => SideTitles(
        showTitles: true,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: _leftAxisLabelsColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 32,
        margin: 12,
      );

  List<LineChartBarData> get _bars => [
        LineChartBarData(
          spots: data,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ];

  final FlGridData _grid = FlGridData(
    show: true,
    drawVerticalLine: true,
    getDrawingHorizontalLine: (value) =>
        FlLine(color: _horizontalGridLineColor, strokeWidth: 1),
    getDrawingVerticalLine: (value) =>
        FlLine(color: _verticalGridLineColor, strokeWidth: 1),
  );

  final _border = FlBorderData(
    show: true,
    border: Border.all(color: const Color(0xff37434d), width: 1),
  );
}
