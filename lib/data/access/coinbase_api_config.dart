import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  const Config(this.loaded);

  final dynamic loaded;

  String get key => loaded['key'] as String;

  String get secret => loaded['secret'] as String;

  String get passphrase => loaded['passphrase'] as String;

  static Future<Config> loadFromDisk() async {
    final configOnDisk = await rootBundle.loadString('config/all.json');
    return Config(jsonDecode(configOnDisk));
  }

  /// Can be useful for debugging.
  @override
  String toString() {
    final fields = {
      'key': key,
      'secret': secret,
      'passphrase': passphrase,
    }.entries.map((e) => '${e.key}: ${e.value}').join(',\n  ');
    return 'Config{\n  $fields\n}';
  }
}
