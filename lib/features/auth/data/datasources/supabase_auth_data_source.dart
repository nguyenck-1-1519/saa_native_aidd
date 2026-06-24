import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

/// Thin wrapper over Supabase auth.
class SupabaseAuthDataSource {
  SupabaseAuthDataSource(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  /// Exchanges a Google idToken for a Supabase session and returns the user.
  Future<AuthUser> signInWithIdToken({
    required String idToken,
    String? accessToken,
  }) async {
    final res = await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    final user = res.user;
    if (user == null) {
      throw const AuthException('Supabase returned no user');
    }
    return AuthUserModel.fromSupabase(user);
  }

  Future<void> signOut() => _auth.signOut();

  AuthUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AuthUserModel.fromSupabase(user);
  }

  /// Emits the current user on every auth change (null when signed out).
  Stream<AuthUser?> watchAuthState() => _auth.onAuthStateChange.map(
        (state) {
          final user = state.session?.user;
          return user == null ? null : AuthUserModel.fromSupabase(user);
        },
      );
}
