import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The only locales the app supports (default first).
const List<Locale> kSupportedLocales = [
  Locale('vi'),
  Locale('en'),
  Locale('ja'),
];

/// Default locale shown before any user choice (FUN_001 / GUI_002 → VN).
const Locale kDefaultLocale = Locale('vi');

const String _prefsKey = 'locale';

/// Holds and persists the active app [Locale].
///
/// Starts at [kDefaultLocale] (vi), then loads any persisted choice. Only
/// languages in [kSupportedLocales] are accepted (FUN_001).
class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(kDefaultLocale) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code != null && _isSupported(code)) {
      state = Locale(code);
    }
  }

  /// Switches the active locale (ignored if unsupported) and persists it.
  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale.languageCode) || locale == state) return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  bool _isSupported(String code) =>
      kSupportedLocales.any((l) => l.languageCode == code);
}

/// Global provider for the active locale.
final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);
