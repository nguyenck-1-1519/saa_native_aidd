import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/stub_profile_repository.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile.dart';

// ---------------------------------------------------------------------------
// Repository DI — override with FakeProfileRepository in tests
// ---------------------------------------------------------------------------

/// Provides the [ProfileRepository] implementation.
///
/// Swap this with a `FakeProfileRepository` override in widget/unit tests for
/// deterministic, zero-delay control (code-standards §8).
final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => StubProfileRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getProfileProvider = Provider<GetProfile>(
  (ref) => GetProfile(ref.watch(profileRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------

/// Loads [ProfileData] for any [userId] (self or other).
///
/// Usage:
/// ```dart
/// ref.watch(profileProvider(userId))
/// ```
/// Keyed by userId so both self and other-profile routes share one cache entry
/// per user without any extra machinery.
final profileProvider =
    FutureProvider.family<ProfileData, String>((ref, userId) {
  return ref.watch(getProfileProvider).call(userId);
});

/// Derives the logged-in user's id from [authStateProvider].
///
/// Returns `null` when the user is not authenticated (which the router already
/// prevents for the Profile tab — this is a defensive null for the rare
/// transitional state during sign-out).
///
/// **Self-profile id mapping:** the self profile stub uses
/// `ProfileMockData.selfUserId` ('fake-user-id'), which matches the id
/// emitted by [FakeAuthRepository] in demo/test mode. In a real Supabase
/// session the user's UUID is passed through unchanged — the stub simply
/// falls back to the [_other] mock for any unrecognised id (no crash).
final currentUserIdProvider = Provider<String?>(
  (ref) => ref.watch(authStateProvider).valueOrNull?.id,
);
