// ANSWERS for note 15. Try lib/workbook/w15.dart first.

import 'package:flutter/services.dart';

class BatteryService {
  static const _channel = MethodChannel('lab/battery');

  Future<int?> level() async {
    try {
      return await _channel.invokeMethod<int>('getBatteryLevel');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}

(String, int) parseVersion(String version) {
  final parts = version.split('+');
  return (parts[0], int.parse(parts[1]));
}

bool allowsVersion(String caret, String candidate) {
  List<int> numbers(String text) => text.split('.').map(int.parse).toList();

  final minimum = numbers(caret.substring(1));
  final version = numbers(candidate);
  if (version[0] != minimum[0]) return false;
  if (version[1] != minimum[1]) return version[1] > minimum[1];
  return version[2] >= minimum[2];
}
