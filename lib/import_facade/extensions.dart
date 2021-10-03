extension Zipper<T> on List<T> {
  List<U> zipWithIndex<U>(U Function(T, int) func) =>
      List.generate(this.length, (idx) => func(this[idx], idx));
}

extension SumInt on Iterable<int> {
  int get sum => reduce((c, i) => c + i);
}

extension SumDouble on Iterable<double> {
  double get sum => reduce((c, i) => c + i);
}
