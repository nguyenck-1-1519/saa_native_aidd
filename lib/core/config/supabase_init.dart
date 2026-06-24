import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';
import 'secure_session_storage.dart';

/// Initializes the Supabase client from [Env].
///
/// Tolerant by design: when local config is absent (e.g. running the fake auth
/// path or a CI smoke build) it skips initialization instead of crashing. Live
/// auth requires `npx supabase start` and a filled `.env`.
abstract final class SupabaseInit {
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized || !Env.hasSupabaseConfig) return;
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureSessionStorage(),
      ),
    );
    _initialized = true;
  }

  static bool get isInitialized => _initialized;
}

/// Shorthand for the active Supabase client. Only valid after
/// [SupabaseInit.ensureInitialized] has run with valid config.
SupabaseClient get supabaseClient => Supabase.instance.client;
