import 'package:flutter/services.dart';
import 'package:flutter_interview_lab/workbook_answers/w15.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('lab/battery');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('1 returns the level from native code', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getBatteryLevel');
      return 80;
    });
    expect(await BatteryService().level(), 80);
  });

  test('1 returns null with no native code', () async {
    expect(await BatteryService().level(), isNull);
  });

  test('1 returns null if native code fails', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'BROKEN');
    });
    expect(await BatteryService().level(), isNull);
  });

  test('2 parseVersion', () {
    expect(parseVersion('1.2.3+45'), ('1.2.3', 45));
  });

  test('3 allowsVersion', () {
    expect(allowsVersion('^1.2.3', '1.2.3'), isTrue);
    expect(allowsVersion('^1.2.3', '1.9.0'), isTrue);
    expect(allowsVersion('^1.2.3', '1.2.2'), isFalse);
    expect(allowsVersion('^1.2.3', '1.1.9'), isFalse);
    expect(allowsVersion('^1.2.3', '2.0.0'), isFalse);
  });
}
