import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/core/_core.dart';
import 'package:gato_id_generator/src/util/delay.dart';

void main() {
  late PlatformBrightnessBloc brightnessBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    brightnessBloc = PlatformBrightnessBloc();
  });

  group("PlatformBrightnessBloc", () {
    test("Initial state is Brightness.light", () async {
      expect(brightnessBloc.state, Brightness.light);
    });

    test('''
      Given PlatformBrightnessBloc.init(),
      When box is yet opened, 
      Then state is Brightness.light.
    ''', () async {
      await brightnessBloc.init();
      expect(brightnessBloc.state, Brightness.light);
    });

    test('''
      Given PlatformBrightnessBloc.init() is done,
      When BrightnessChange to light, 
      Then state is Brightness.light.
    ''', () async {
      await brightnessBloc.init();
      expect(brightnessBloc.state, Brightness.light);

      brightnessBloc.add(BrightnessChange(to: Brightness.light));
      expect(brightnessBloc.state, Brightness.light);
    });

    test('''
      Given PlatformBrightnessBloc.init() is done,
      When BrightnessChange to dark, 
      Then state is Brightness.dark.
    ''', () async {
      await brightnessBloc.init();
      expect(brightnessBloc.state, Brightness.light);

      brightnessBloc.add(BrightnessChange(to: Brightness.dark));
      await delay(true, 300);
      expect(brightnessBloc.state, Brightness.dark);
    });

    // TODO more exhaustive tests, e.g persistance test, Hive test.
  });
}
