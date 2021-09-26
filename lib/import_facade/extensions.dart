extension Zipper<T> on List<T> {
  List<U> zipWithIndex<U>(U Function(T, int) func) =>
      List.generate(this.length, (idx) => func(this[idx], idx));
}

extension Sum on Iterable<int> {
  int get sum => reduce((c, i) => c + i);
}
