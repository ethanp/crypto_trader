class InsufficientFundsException implements Exception {
  const InsufficientFundsException();

  @override
  String toString() => 'Insufficient cash available, deposit more dollars';
}
