import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  const Config(this.loaded);
  final dynamic loaded;

  String get key => loaded['key'];
  String get passphrase => loaded['passphrase'];

  static Future<Config> loadFromDisk() async {
    final configOnDisk = await rootBundle.loadString('config/config.json');
    return Config(jsonDecode(configOnDisk));
  }

  /// Can be useful for debugging.
  @override
  String toString() {
    final fields = <String, String>{
      'key': key,
      'passphrase': passphrase,
    }.entries.map((e) => '${e.key}: ${e.value}').join(',\n  ');
    return 'Config{\n  $fields\n}';
  }
}
