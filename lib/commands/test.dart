import 'command.dart';

class FakeCommand extends MultistageCommand {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType verify()');
    });
  }

  @override
  String get title => throw UnimplementedError();

  @override
  String get subtitle => throw UnimplementedError();
}

class ErrantRequestCommand extends MultistageCommand {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      throw Exception('error from $runtimeType#request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('ERROR: Should not have gotten here in $runtimeType');
    });
  }

  @override
  String get title => throw UnimplementedError();

  @override
  String get subtitle => throw UnimplementedError();
}

class ErrantVerifyCommand extends MultistageCommand {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      throw Exception('error from $runtimeType#verify()');
    });
  }

  @override
  String get title => throw UnimplementedError();

  @override
  String get subtitle => throw UnimplementedError();
}
