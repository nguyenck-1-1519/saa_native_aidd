import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/google_sign_in_data_source.dart';
import '../datasources/supabase_auth_data_source.dart';

/// Real auth implementation: native Google sign-in → Supabase idToken exchange.
/// Maps low-level exceptions to domain [Failure]s.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required GoogleSignInDataSource googleSignIn,
    required SupabaseAuthDataSource supabaseAuth,
  })  : _google = googleSignIn,
        _supabase = supabaseAuth;

  final GoogleSignInDataSource _google;
  final SupabaseAuthDataSource _supabase;

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final tokens = await _google.signIn();
      return await _supabase.signInWithIdToken(
        idToken: tokens.idToken,
        accessToken: tokens.accessToken,
      );
    } on Failure {
      rethrow; // already a domain failure (e.g. AuthCancelled)
    } on SocketException catch (e) {
      throw NetworkFailure(e.message);
    } on AuthApiException catch (e) {
      // 400/403 → invalid/disabled/locked account; otherwise unknown.
      final status = int.tryParse(e.statusCode ?? '');
      if (status == 400 || status == 403) {
        throw AccountDisabled(e.message);
      }
      throw UnknownFailure(e.message);
    } on AuthException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    // Always clear the Supabase session even if Google sign-out fails.
    try {
      await _google.signOut();
    } catch (_) {
      // Ignore — local Google state is best-effort; Supabase is authoritative.
    }
    await _supabase.signOut();
  }

  @override
  Stream<AuthUser?> watchAuthState() => _supabase.watchAuthState();

  @override
  AuthUser? get currentUser => _supabase.currentUser;
}
