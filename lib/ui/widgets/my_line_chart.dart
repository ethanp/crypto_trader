import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart(this.candles);

  /// Price data for the chart.
  final List<Candle> candles;

  @override
  Widget build(BuildContext context) => Flexible(
      child: Padding(
          padding: const EdgeInsets.only(right: 13),
          child: _lineChart(context)));

  Widget _lineChart(BuildContext context) {
    final PortfolioState state = context.read<PortfolioState>();

    // Compute bounds //
    final Iterable<double> timestamps =
        candles.map((c) => c.timestamp.millisecondsSinceEpoch.toDouble());
    final double minX = timestamps.min;
    final double maxX = timestamps.max;
    final Iterable<double> closingPrices = candles.map((c) => c.closingPrice);
    final double minY = _getMinY(state, closingPrices);
    final double maxY = closingPrices.max;

    final double horizontalInterval = (maxX - minX) / 5.01;
    final double verticalInterval = (maxY - minY) / 4.01;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        titlesData: _xyAxisLabels(
          horizontalInterval,
          verticalInterval,
          state.granularity,
        ),
        lineBarsData: [_priceData()],
        gridData: _grid(verticalInterval, horizontalInterval),
        borderData: _border(),
        lineTouchData: _tooltip(),
      ),
      // Without this, swapping from Bitcoin to Cardano takes ~10sec.
      swapAnimationDuration: Duration.zero,
    );
  }

  /// The largest granularity is shown with minY := 0, which allows looking
  ///  at proportions to see %ge fluctuations.
  ///
  /// The other granularities are shown "zoomed in", which makes it easier to
  ///  look at directionality of recent (relatively insignificant) changes.
  double _getMinY(PortfolioState state, Iterable<double> closingPrices) =>
      state.granularity == Granularities.oneDay ? .0 : closingPrices.min;

  FlBorderData _border() => FlBorderData(
      show: true, border: Border.all(color: Colors.grey[700]!, width: .8));

  FlGridData _grid(double verticalInterval, double horizontalInterval) {
    final gridLine = FlLine(color: Colors.grey[800], strokeWidth: 1);
    return FlGridData(
      horizontalInterval: verticalInterval,
      verticalInterval: horizontalInterval,
      getDrawingHorizontalLine: (value) => gridLine,
      getDrawingVerticalLine: (value) => gridLine,
    );
  }

  LineTouchData _tooltip() => LineTouchData(
      touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
                final dateTime = DateTime.fromMillisecondsSinceEpoch(
                  touchedSpot.x.toInt(),
                  isUtc: true,
                );
                final day = DateFormat.E().format(dateTime);
                final date = DateFormat.MMMd().format(dateTime);
                final hourMin = DateFormat.jm().format(dateTime);
                return LineTooltipItem(
                  '${Dollars(touchedSpot.y)}\n$day $date\n$hourMin',
                  const TextStyle(color: Colors.yellowAccent),
                );
              }).toList()));

  LineChartBarData _priceData() {
    const lineColors = [Colors.lightBlueAccent, Colors.tealAccent];
    final areaColors = [
      lineColors[0].withOpacity(0.3),
      lineColors[1].withOpacity(0.6)
    ];
    const verticalLine = [Offset(.5, 1), Offset(.5, 0)];
    return LineChartBarData(
        isCurved: true,
        colors: lineColors,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        spots: [
          for (final candle in candles)
            FlSpot(
              candle.timestamp.millisecondsSinceEpoch.toDouble(),
              candle.closingPrice,
            )
        ],
        belowBarData: BarAreaData(
            show: true,
            gradientFrom: verticalLine.first,
            gradientTo: verticalLine.last,
            colors: areaColors));
  }

  FlTitlesData _xyAxisLabels(
    double horizontalInterval,
    double verticalInterval,
    Granularity granularity,
  ) {
    final xAxisLabelStyle = TextStyle(
      color: Colors.grey[400],
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: -1.5,
    );
    final xAxisLabels = SideTitles(
      showTitles: true,
      // Height available to label
      reservedSize: 28,
      margin: 7,
      interval: horizontalInterval,
      getTextStyles: (context, value) => xAxisLabelStyle,
      getTitles: (value) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          value.toInt(),
          isUtc: true,
        );
        if (granularity >= Granularities.sixHours) {
          final day = DateFormat.EEEE().format(dateTime);
          final date = DateFormat.MMMd().format(dateTime);
          return '$day\n$date';
        }
        return DateFormat.jm().format(dateTime);
      },
    );

    final yAxisLabelStyle = xAxisLabelStyle.copyWith(fontSize: 15);
    final yAxisLabels = SideTitles(
      showTitles: true,
      interval: verticalInterval,
      reservedSize: 55,
      margin: 7,
      getTextStyles: (context, value) => yAxisLabelStyle,
      getTitles: (value) => NumberFormat.compactSimpleCurrency().format(value),
    );
    final xyAxisLabels = FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: xAxisLabels,
      leftTitles: yAxisLabels,
    );
    return xyAxisLabels;
  }
}
