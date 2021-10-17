import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Line chart of price history of a [Currency].
class PriceChart extends StatelessWidget {
  /// Line chart of price history of a [Currency].
  const PriceChart({required this.currency, required this.candles});

  /// The [Currency] to chart.
  final Currency currency;

  /// Price data for the chart.
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
    _debugPrintBounds(minX, maxX, minY, maxY);

    final greyBorder = FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[700]!, width: 2),
    );

    final horizontalInterval = (maxX - minX) / 4.2;
    final verticalInterval = (maxY - minY) / 3.2;

    final gridLine = FlLine(color: Colors.grey[800], strokeWidth: 1);
    final greyVertAndHorizGrid = FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: verticalInterval,
        verticalInterval: horizontalInterval,
        getDrawingHorizontalLine: (value) => gridLine,
        getDrawingVerticalLine: (value) => gridLine);

    final xAxisLabelStyle = TextStyle(
        color: Colors.grey[400],
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: -1.5);
    final xAxisLabels = SideTitles(
        showTitles: true,
        // Height available to label
        reservedSize: 28,
        margin: 7,
        interval: horizontalInterval,
        getTextStyles: (context, value) => xAxisLabelStyle,
        getTitles: (value) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          final day = DateFormat.EEEE().format(dateTime);
          final date = DateFormat.MMMd().format(dateTime);
          return '$day\n$date';
        });

    final yAxisLabelStyle = xAxisLabelStyle.copyWith(fontSize: 15);
    final yAxisLabels = SideTitles(
        showTitles: true,
        interval: verticalInterval,
        reservedSize: 55,
        margin: 7,
        getTextStyles: (context, value) => yAxisLabelStyle,
        getTitles: (value) =>
            NumberFormat.compactSimpleCurrency().format(value));
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

    final chartWidget = Flexible(
      child: Padding(
        padding: const EdgeInsets.only(right: 13),
        child: lineChart,
      ),
    );

    return Column(children: [
      _chartTitle(),
      chartWidget,
    ]);
  }

  void _debugPrintBounds(double minX, double maxX, double minY, double maxY) {
    final minXPrint = DateTime.fromMillisecondsSinceEpoch(minX.toInt());
    final maxXPrint = DateTime.fromMillisecondsSinceEpoch(maxX.toInt());
    print('minX=$minXPrint maxX=$maxXPrint minY=$minY maxY=$maxY');
  }

  Widget _chartTitle() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 30,
            child: MyText(
              currency.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[300],
              ),
            ),
          ),
          // TODO(feature): Add granularity dropdown
          const MyText('Dropdown goes here'),
        ],
      );

  LineChartBarData _priceData() {
    const _gradientColors = [Color(0xFF64B5F6), Color(0xFF69F0AE)];

    return LineChartBarData(
        spots: candles
            .map((c) => FlSpot(
                  c.timestamp.millisecondsSinceEpoch.toDouble(),
                  c.closingPrice,
                ))
            .toList(),
        isCurved: true,
        colors: _gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: _gradientColors.map((c) => c.withOpacity(0.3)).toList(),
        ));
  }
}
