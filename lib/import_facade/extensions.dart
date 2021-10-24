extension Zipper<T> on List<T> {
  List<U> mapWithIndex<U>(U Function(T, int) func) =>
      List.generate(length, (idx) => func(this[idx], idx));

  List<T> takeEvery(final int i) =>
      [for (int curr = 0; curr < length; curr += i) this[curr]];
}

extension SumInt on Iterable<int> {
  int get sum => reduce((c, i) => c + i);
}

extension SumDouble on Iterable<double> {
  double get sum => reduce((c, i) => c + i);

  double get max => reduce((c, i) => i > c ? i : c);

  double get min => reduce((c, i) => i < c ? i : c);
}
