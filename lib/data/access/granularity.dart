class Granularity {
  const Granularity({
    required this.duration,
    required this.name,
  });

  final Duration duration;
  final String name;

  @override
  String toString() => name;

  static const Granularity oneMinute = Granularity(
    duration: Duration(seconds: 60),
    name: '1 Minute',
  );
  static const Granularity fiveMinutes = Granularity(
    duration: Duration(seconds: 300),
    name: '5 Minutes',
  );
  static const Granularity fifteenMinutes = Granularity(
    duration: Duration(seconds: 900),
    name: '15 Minutes',
  );
  static const Granularity oneHour = Granularity(
    duration: Duration(seconds: 3600),
    name: '1 Hour',
  );
  static const Granularity sixHours = Granularity(
    duration: Duration(seconds: 21600),
    name: '6 Hours',
  );
  static const Granularity days = Granularity(
    duration: Duration(seconds: 86400),
    name: '1 Day',
  );
  static List<Granularity> granularities = [
    oneMinute,
    fiveMinutes,
    fifteenMinutes,
    oneHour,
    sixHours,
    days,
  ];
}
