import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

// TODO
void main() {
  setUp(() async {
    try {
      // Hive reset
      await Directory('temp').delete(recursive: true);
    } catch (e) {
      // print("ERROR");
      // print(e);
    }
  });

  // * Note: All tests are wrapped with `runAsync` to prevent this error:
  // * A Timer is still pending even after the widget tree was disposed.

  testWidgets('GenerateScreen layout is correct.', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpApp();
      await r.generate.expectInitialLayoutIsCorrect();
    });
  });
}
