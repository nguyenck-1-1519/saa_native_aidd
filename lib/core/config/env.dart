import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application environment flavor.
enum AppEnv { development, staging, production }

/// Typed config accessors.
///
/// Resolution order per value: a `--dart-define` (or `--dart-define-from-file`,
/// see `config/<env>.json`) wins; otherwise the value falls back to the local
/// `.env` asset (gitignored). This lets `development` rely on local `.env` while
/// `staging`/`production` carry their own config files. Missing keys → ''.
abstract final class Env {
  /// Loads the local `.env` (tolerant: absent file is fine when running purely
  /// off `--dart-define-from-file`).
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      dotenv.testLoad(fileInput: '');
    }
  }

  static String _resolve(String defineValue, String key) =>
      defineValue.isNotEmpty ? defineValue : (dotenv.env[key] ?? '');

  /// A value is "real" only if it is set AND not a leftover template
  /// placeholder. Prevents booting the real auth path against bogus config
  /// (which crashes native Google Sign-In on iOS).
  static bool _isConfigured(String v) =>
      v.isNotEmpty &&
      !v.startsWith('your_') &&
      !v.contains('YOUR_') &&
      !v.contains('replace_with');

  // --- App flavor ---------------------------------------------------------
  static const String _appEnvRaw =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static AppEnv get appEnv => switch (_appEnvRaw) {
        'staging' => AppEnv.staging,
        'production' => AppEnv.production,
        _ => AppEnv.development,
      };

  static String get appName => _resolve(
        const String.fromEnvironment('APP_NAME'),
        'APP_NAME',
      );

  // --- Supabase -----------------------------------------------------------
  static String get supabaseUrl => _resolve(
        const String.fromEnvironment('SUPABASE_URL'),
        'SUPABASE_URL',
      );

  static String get supabasePublishableKey => _resolve(
        const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
        'SUPABASE_PUBLISHABLE_KEY',
      );

  // --- Google OAuth (client-side ids; not secrets) ------------------------
  static String get googleWebClientId => _resolve(
        const String.fromEnvironment('GOOGLE_CLIENT_ID'),
        'GOOGLE_CLIENT_ID',
      );

  static String get googleIosClientId => _resolve(
        const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
        'GOOGLE_IOS_CLIENT_ID',
      );

  /// True when the minimum config for live Supabase auth is present.
  static bool get hasSupabaseConfig =>
      _isConfigured(supabaseUrl) && _isConfigured(supabasePublishableKey);

  /// True when native Google Sign-In has real (non-placeholder) client ids.
  static bool get hasGoogleConfig =>
      _isConfigured(googleIosClientId) && _isConfigured(googleWebClientId);
}
