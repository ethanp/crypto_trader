import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  // TODO show which currency it is above the chart.
  final Currency currency;
  final List<Candle> candles;

  PriceChart({required this.currency, required this.candles});

  final List<Color> _gradientColors = [
    Colors.blue[300]!,
    Colors.greenAccent[200]!,
  ];

  @override
  Widget build(BuildContext context) {
    final greyBorder = FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[700]!, width: 1),
    );

    final gridLine = FlLine(color: Colors.grey[800], strokeWidth: 1);
    final greyVertAndHorizGrid = FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) => gridLine,
        getDrawingVerticalLine: (value) => gridLine);

    final axisLabelStyle = TextStyle(
      color: Colors.grey[400],
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
    final xAxisLabels = SideTitles(
        showTitles: true,
        // Height available to label
        reservedSize: 22,
        margin: 8,
        interval: 1,
        getTextStyles: (context, value) => axisLabelStyle,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return '3wk';
            case 5:
              return '2wk';
            case 8:
              return '1wk';
            default:
              return '';
          }
        });
    final yAxisLabels = SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 62,
        margin: 12,
        getTextStyles: (context, value) => axisLabelStyle,
        getTitles: (value) {
          final v = value.toInt();
          return v % 1000 == 0 ? '\$$v' : '';
        });
    final xyAxisLabels = FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: xAxisLabels,
        leftTitles: yAxisLabels);

    final Iterable<double> timestamps =
        candles.map((c) => c.timestamp.millisecondsSinceEpoch.toDouble());
    final Iterable<double> closingPrices = candles.map((c) => c.priceClose);

    print(timestamps.length);
    var minX = timestamps.min;
    var maxX = timestamps.max;
    var minY = closingPrices.min;
    var maxY = closingPrices.max;
    print('minX=$minX maxX=$maxX minY=$minY maxY=$maxY');
    var priceData = _priceData();
    return LineChart(LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        titlesData: xyAxisLabels,
        lineBarsData: [priceData],
        gridData: greyVertAndHorizGrid,
        borderData: greyBorder));
  }

  LineChartBarData _priceData() {
    return LineChartBarData(
        spots: candles
            .map((c) => FlSpot(
                c.timestamp.millisecondsSinceEpoch.toDouble(), c.priceClose))
            .toList(),
        isCurved: true,
        colors: _gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors:
              _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ));
  }
}
