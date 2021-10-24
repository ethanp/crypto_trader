import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChartData extends StatelessWidget {
  const ChartData(this.candles);

  /// Price data for the chart.
  final List<Candle> candles;

  @override
  Widget build(BuildContext context) {
    final state = context.read<PortfolioState>();

    // Compute bounds //
    final Iterable<double> timestamps =
        candles.map((c) => c.timestamp.millisecondsSinceEpoch.toDouble());
    final minX = timestamps.min;
    final maxX = timestamps.max;
    final Iterable<double> closingPrices = candles.map((c) => c.closingPrice);
    const minY = .0;
    final maxY = closingPrices.max;

    final greyBorder = FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[700]!, width: 2),
    );

    final horizontalInterval = (maxX - minX) /
        (state.granularity == Granularities.sixHours ? 3.2 : 5.2);
    final verticalInterval = (maxY - minY) / 3.2;

    final gridLine = FlLine(color: Colors.grey[800], strokeWidth: 1);
    final greyVertAndHorizGrid = FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: verticalInterval,
      verticalInterval: horizontalInterval,
      getDrawingHorizontalLine: (value) => gridLine,
      getDrawingVerticalLine: (value) => gridLine,
    );

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
        if (state.granularity >= Granularities.sixHours) {
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

    final tooltip = LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
          final millis = touchedSpot.x.toInt();
          final dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
          final day = DateFormat.E().format(dateTime);
          final date = DateFormat.MMMd().format(dateTime);
          final hourMin = DateFormat.jm().format(dateTime);
          final time = '$day $date\n$hourMin';
          final dollars = Dollars(touchedSpot.y);
          final text = '$dollars\n$time';
          const style = TextStyle(color: Colors.lightBlueAccent);
          return LineTooltipItem(text, style);
        }).toList(),
      ),
    );

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
        lineTouchData: tooltip,
      ),
      // Without this, swapping from Bitcoin to Cardano takes ~10sec.
      swapAnimationDuration: Duration.zero,
    );

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(right: 13),
        child: lineChart,
      ),
    );
  }

  LineChartBarData _priceData() {
    const _gradientColors = [Colors.lightBlueAccent, Colors.tealAccent];
    return LineChartBarData(
      spots: candles
          .map((c) => FlSpot(
                c.timestamp.millisecondsSinceEpoch.toDouble(),
                c.closingPrice,
              ))
          .toList(),
      isCurved: true,
      colors: _gradientColors,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: [
          _gradientColors[0].withOpacity(0.3),
          _gradientColors[1].withOpacity(0.6)
        ],
        gradientFrom: const Offset(.5, 1),
        gradientTo: const Offset(.5, 0),
      ),
    );
  }
}
