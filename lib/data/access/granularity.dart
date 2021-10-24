class Granularity {
  const Granularity({
    required this.duration,
    required this.name,
  });

  final Duration duration;
  final String name;

  bool operator >=(Granularity other) => duration >= other.duration;

  @override
  String toString() => name;
}

class Granularities {
  static const Granularity oneMinute =
      Granularity(duration: Duration(minutes: 1), name: '1 Minute');
  static const Granularity fiveMinutes =
      Granularity(duration: Duration(minutes: 5), name: '5 Minutes');
  static const Granularity fifteenMinutes =
      Granularity(duration: Duration(minutes: 15), name: '15 Minutes');
  static const Granularity oneHour =
      Granularity(duration: Duration(hours: 1), name: '1 Hour');
  static const Granularity sixHours =
      Granularity(duration: Duration(hours: 6), name: '6 Hours');
  static const Granularity oneDay =
      Granularity(duration: Duration(days: 1), name: '1 Day');

  static List<Granularity> all = [
    oneMinute,
    fiveMinutes,
    fifteenMinutes,
    oneHour,
    sixHours,
    oneDay,
  ];
}
