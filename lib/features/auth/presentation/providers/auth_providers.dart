import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/env.dart';
import '../../../../core/config/supabase_init.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/watch_auth_state.dart';
import '../../data/datasources/google_sign_in_data_source.dart';
import '../../data/datasources/supabase_auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/fake_auth_repository.dart';

/// The auth repository. Overridden with `FakeAuthRepository` in tests; also
/// falls back to it for credential-free runs — when Supabase was not
/// initialized OR Google client ids are missing/placeholder — so the app boots
/// and the Login button works in a demo instead of crashing native Google
/// Sign-In on iOS.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!SupabaseInit.isInitialized || !Env.hasGoogleConfig) {
    return FakeAuthRepository();
  }
  final supabaseAuth = SupabaseAuthDataSource(supabaseClient);
  final google = GoogleSignInDataSource(
    iosClientId: Env.googleIosClientId,
    serverClientId: Env.googleWebClientId,
  );
  return AuthRepositoryImpl(googleSignIn: google, supabaseAuth: supabaseAuth);
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>(
  (ref) => SignInWithGoogle(ref.watch(authRepositoryProvider)),
);

final signOutProvider = Provider<SignOut>(
  (ref) => SignOut(ref.watch(authRepositoryProvider)),
);

final watchAuthStateProvider = Provider<WatchAuthState>(
  (ref) => WatchAuthState(ref.watch(authRepositoryProvider)),
);

/// Streams the current auth state — drives router redirects and auto-login.
final authStateProvider = StreamProvider<AuthUser?>(
  (ref) => ref.watch(watchAuthStateProvider).call(),
);

/// Handles the Google login action: loading/error state + double-click guard.
class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return; // double-click prevention (FUN_008)
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(signInWithGoogleProvider).call(),
    );
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, void>(LoginController.new);
