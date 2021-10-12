import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Line chart of price history of a [Currency].
class PriceChart extends StatelessWidget {
  /// Line chart of price history of a [Currency].
  const PriceChart({required this.currency, required this.candles});

  /// The [Currency] to plot.
  final Currency currency;

  /// Raw data for the plot.
  final List<Candle> candles;

  @override
  Widget build(BuildContext context) {
    final Iterable<double> timestamps =
        candles.map((c) => c.timestamp.millisecondsSinceEpoch.toDouble());
    final Iterable<double> closingPrices = candles.map((c) => c.closingPrice);

    print(timestamps.length);
    final minX = timestamps.min;
    final maxX = timestamps.max;
    final minY = closingPrices.min;
    final maxY = closingPrices.max;
    print('minX=$minX maxX=$maxX minY=$minY maxY=$maxY');

    final greyBorder = FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[700]!, width: 2),
    );

    final gridLine = FlLine(color: Colors.grey[800], strokeWidth: 1);
    final greyVertAndHorizGrid = FlGridData(
        show: true,
        drawVerticalLine: true,
        checkToShowVerticalLine: (value) {
          print('Check vertical $value');
          return true;
          // return DateTime.fromMillisecondsSinceEpoch(value);
        },
        getDrawingHorizontalLine: (value) {
          print('Horizontal line: $value');
          return gridLine;
        },
        getDrawingVerticalLine: (value) {
          print('Vertical line: $value');
          return gridLine;
        });

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

    final len = maxY - minY;
    var a = minY + len / 7;
    final b = <int>[];
    for (int i = 1; i < 7; i++) {
      b.add(a.toInt());
      a += len;
    }
    final yAxisLabels = SideTitles(
        showTitles: true,
        interval: 1000,
        reservedSize: 62,
        margin: 12,
        getTextStyles: (context, value) => axisLabelStyle,
        getTitles: (value) {
          final v = value.toInt();
          print('Finding $v in $b');
          return b.contains(v) ? '\$$v' : '';
        });
    final xyAxisLabels = FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: xAxisLabels,
        leftTitles: yAxisLabels);

    final lineChart = LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        titlesData: xyAxisLabels,
        lineBarsData: [_priceData()],
        gridData: greyVertAndHorizGrid,
        borderData: greyBorder,
      ),
    );

    return Column(children: [
      SizedBox(height: 20, child: Text(currency.name)),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(right: 13),
          child: lineChart,
        ),
      ),
    ]);
  }

  LineChartBarData _priceData() {
    const List<Color> _gradientColors = [Color(0xFF64B5F6), Color(0xFF69F0AE)];

    return LineChartBarData(
        spots: candles
            .map((c) => FlSpot(
                c.timestamp.millisecondsSinceEpoch.toDouble(), c.closingPrice))
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
