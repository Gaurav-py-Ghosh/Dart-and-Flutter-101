// NOTE 15 WORKBOOK.
// Check it:  flutter test workbook_test/w15_test.dart
// Answers are in lib/workbook_answers/w15.dart. Try for 5 minutes first.
//
// You'll need this import for the first one:
//   import 'package:flutter/services.dart';

/// 1. PLATFORM CHANNEL. Use MethodChannel('lab/battery'), and invoke
/// 'getBatteryLevel'. Return the number. If there's no native code
/// (MissingPluginException) or the native side fails (PlatformException),
/// return null rather than crashing.
class BatteryService {
  Future<int?> level() => throw UnimplementedError();
}

/// 2. VERSIONS. parseVersion('1.2.3+45') gives ('1.2.3', 45).
(String, int) parseVersion(String version) => throw UnimplementedError();

/// 3. CARET RANGES. allowsVersion('^1.2.3', x) is true for at least 1.2.3,
/// but below 2.0.0. So 1.2.3 and 1.9.0 are allowed, and 1.2.2 and 2.0.0 aren't.
/// All versions here have three numbers, and a major version of at least 1.
bool allowsVersion(String caret, String candidate) =>
    throw UnimplementedError();
