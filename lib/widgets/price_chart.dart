import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Line chart of price history of a [Currency].
class PriceChart extends StatelessWidget {
  /// Line chart of price history of a [Currency].
  const PriceChart({required this.candles});

  /// Price data for the chart.
  final List<Candle> candles;

  @override
  Widget build(BuildContext context) {
    final state = context.read<PortfolioState>();
    return Column(children: [
      _chartHeader(state),
      _chartWidget(state),
    ]);
  }

  Widget _chartHeader(PortfolioState state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        child: Row(children: [
          _currencyName(state),
          const Spacer(),
          _granularityDropdown(state),
        ]),
      );

  Widget _currencyName(PortfolioState state) => SizedBox(
        width: 150,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: MyText(
            state.currency.name,
            // This key is required so that the AnimatedSwitcher interprets
            // the child as "new" each time the currency changes.
            key: ValueKey<String>(state.currency.name),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.lightBlueAccent[100],
            ),
          ),
        ),
      );

  Widget _granularityDropdown(PortfolioState state) {
    return SizedBox(
      width: 140,
      height: 45,
      child: DropdownButtonFormField<Granularity>(
        value: state.granularity,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
        ),
        enableFeedback: true,
        onChanged: (Granularity? newValue) => state.setGranularity(newValue!),
        items: [
          for (final dropdownValue in Granularity.granularities)
            DropdownMenuItem(
              value: dropdownValue,
              child: Center(
                child: Text(
                  dropdownValue.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _chartWidget(PortfolioState state) {
    // Compute bounds //
    final Iterable<double> timestamps =
        candles.map((c) => c.timestamp.millisecondsSinceEpoch.toDouble());
    final minX = timestamps.min;
    final maxX = timestamps.max;
    final Iterable<double> closingPrices = candles.map((c) => c.closingPrice);
    final minY = closingPrices.min;
    final maxY = closingPrices.max;
    _debugPrintBounds(minX, maxX, minY, maxY);

    final greyBorder = FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[700]!, width: 2),
    );

    final horizontalInterval =
        (maxX - minX) / (state.granularity == Granularity.sixHours ? 3.2 : 5.2);
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
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            value.toInt(),
            isUtc: true,
          );
          if (state.granularity >= Granularity.sixHours) {
            final day = DateFormat.EEEE().format(dateTime);
            final date = DateFormat.MMMd().format(dateTime);
            return '$day\n$date';
          }
          return DateFormat.jm().format(dateTime);
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

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(right: 13),
        child: lineChart,
      ),
    );
  }

  void _debugPrintBounds(double minX, double maxX, double minY, double maxY) {
    final minXPrint = DateTime.fromMillisecondsSinceEpoch(minX.toInt());
    final maxXPrint = DateTime.fromMillisecondsSinceEpoch(maxX.toInt());
    print('minX=$minXPrint maxX=$maxXPrint minY=$minY maxY=$maxY');
  }

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

class CurrentGranularity extends ChangeNotifier {
  var _granularity = Granularity.days;

  Granularity get granularity => _granularity;

  void setGranularity(Granularity granularity) {
    _granularity = granularity;
    notifyListeners();
  }
}
