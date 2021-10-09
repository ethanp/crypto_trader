import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  static final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  static final Color _horizontalGridLineColor = const Color(0xff37434d);
  static final Color _verticalGridLineColor = const Color(0xff37434d);

  static final _axisLabelStyle = TextStyle(
    color: Colors.grey[400],
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

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
        },
      );

  SideTitles get _leftAxisLabels => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 32,
        margin: 12,
        getTextStyles: (context, value) => _axisLabelStyle,
        getTitles: (value) {
          final v = value.toInt();
          return v % 2 == 0 ? '\$$v' : '';
        },
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
