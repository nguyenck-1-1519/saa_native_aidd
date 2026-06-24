import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saa_2025/core/l10n/locale_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleController', () {
    test('starts with default locale (vi)', () async {
      final controller = LocaleController();
      // Allow time for _load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.state, const Locale('vi'));
    });

    test('setLocale updates state (FUN_003)', () async {
      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setLocale(const Locale('en'));

      expect(controller.state, const Locale('en'));
    });

    test('setLocale persists to SharedPreferences', () async {
      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setLocale(const Locale('ja'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), 'ja');
    });

    test('setLocale ignores unsupported locales (FUN_001)', () async {
      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      final oldState = controller.state;
      await controller.setLocale(const Locale('fr'));

      expect(controller.state, oldState);
    });

    test('setLocale ignores same locale', () async {
      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      final oldState = controller.state;
      await controller.setLocale(const Locale('vi'));

      expect(controller.state, oldState);
    });

    test('loads persisted locale on init', () async {
      // Pre-populate SharedPreferences
      SharedPreferences.setMockInitialValues({'locale': 'en'});

      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.state, const Locale('en'));
    });

    test('ignores invalid persisted locale', () async {
      SharedPreferences.setMockInitialValues({'locale': 'xx'});

      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.state, const Locale('vi'));
    });

    test('supports VN/EN/JA (GUI_002, FUN_001)', () async {
      final controller = LocaleController();
      await Future.delayed(const Duration(milliseconds: 100));

      await controller.setLocale(const Locale('vi'));
      expect(controller.state, const Locale('vi'));

      await controller.setLocale(const Locale('en'));
      expect(controller.state, const Locale('en'));

      await controller.setLocale(const Locale('ja'));
      expect(controller.state, const Locale('ja'));
    });
  });

  group('localeControllerProvider', () {
    test('provides a LocaleController instance', () {
      final container = ProviderContainer();

      final controller = container.read(localeControllerProvider.notifier);

      expect(controller, isA<LocaleController>());
    });

    test('default locale from provider is vi', () async {
      final container = ProviderContainer();
      await Future.delayed(const Duration(milliseconds: 100));

      final locale = container.read(localeControllerProvider);

      expect(locale, const Locale('vi'));
    });
  });
}
