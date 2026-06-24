import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// In-memory [AuthRepository] for tests and credential-free demo runs.
///
/// No Google/Supabase calls. Configure [nextFailure] to make the next sign-in
/// throw, or seed [initialUser] to simulate an existing session (auto-login).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthUser? initialUser,
    this.signInDelay = const Duration(milliseconds: 50),
    AuthUser? signedInUser,
  })  : _current = initialUser,
        _signedInUser = signedInUser ?? _defaultUser;
  // watchAuthState() yields _current synchronously, so no seed emit is needed.

  static const AuthUser _defaultUser = AuthUser(
    id: 'fake-user-id',
    email: 'sunner@sun-asterisk.com',
    displayName: 'Sun* Tester',
    photoUrl: null,
  );

  final Duration signInDelay;
  final AuthUser _signedInUser;
  final _controller = StreamController<AuthUser?>.broadcast();

  AuthUser? _current;

  /// If set, the next [signInWithGoogle] throws this and then clears it.
  Failure? nextFailure;

  /// Counts sign-in attempts — lets tests assert double-click prevention.
  int signInCallCount = 0;

  @override
  Future<AuthUser> signInWithGoogle() async {
    signInCallCount++;
    await Future<void>.delayed(signInDelay);
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
    _current = _signedInUser;
    _controller.add(_current);
    return _signedInUser;
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  @override
  Stream<AuthUser?> watchAuthState() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  AuthUser? get currentUser => _current;

  void dispose() => _controller.close();
}
