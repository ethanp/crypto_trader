/// Price fluctuations for one [Currency] for one "duration".
class Candle {
  /// Price fluctuations for one [Currency] for one "duration".
  const Candle({
    required this.timestamp,
    required this.lowestPrice,
    required this.highestPrice,
    required this.openingPrice,
    required this.closingPrice,
  });

  /// Parse Coinbase response into a [Candle].
  factory Candle.fromCoinbase(dynamic input) {
    final seconds = (input[0] as num).toInt();
    return Candle(
      timestamp: DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
      lowestPrice: (input[1] as num).toDouble(),
      highestPrice: (input[2] as num).toDouble(),
      openingPrice: (input[3] as num).toDouble(),
      closingPrice: (input[4] as num).toDouble(),
    );
  }

  /// Start time of the period.
  final DateTime timestamp;

  /// Lowest price in this time interval.
  final double lowestPrice;

  /// Highest price in this time interval.
  final double highestPrice;

  /// Opening price in this time interval.
  final double openingPrice;

  /// Closing price in this time interval.
  final double closingPrice;

  @override
  String toString() => 'Candle('
      'timestamp: $timestamp, '
      'priceLow: $lowestPrice, '
      'priceHigh: $highestPrice, '
      'priceOpen: $openingPrice, '
      'priceClose: $closingPrice)';
}
