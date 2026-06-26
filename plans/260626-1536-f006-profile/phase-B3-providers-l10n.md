# Phase B3 — Providers + l10n keys

**Track B (logic). blockedBy: B2.**

## Context Links
- Pattern mirror: `lib/features/kudos/presentation/providers/kudos_providers.dart` (Provider DI + FutureProvider)
- ARB files: `lib/core/l10n/app_vi.arb`, `app_en.arb`, `app_ja.arb`
- Self identity: `lib/features/auth/presentation/providers/auth_providers.dart` (`authStateProvider`)

## Overview
- Priority: P2 · Status: pending
- Wire DI providers for the profile feature and add localized strings for section labels / states.

## Key Insights
- Keep it KISS: `profileProvider` as a **FutureProvider.family<ProfileData, String>** keyed by userId
  (no retry controller unless design demands it — mirrors `kudosStatsProvider` simplicity, family covers self+other).
- Self userId comes from `authStateProvider.valueOrNull?.id`; expose a small `currentUserIdProvider`
  derive so the self route and the wrapper share one source of truth (DRY).
- Override `profileRepositoryProvider` with `FakeProfileRepository` / stub in tests (code-standards §8).
- Every UI string (section titles "Danh hiệu", "Kudos nhận/gửi", error/empty/retry) → all 3 ARB files; `gen-l10n` after.

## Requirements
- FR: `profileProvider(userId)` loads `ProfileData`; `currentUserIdProvider` returns logged-in id (or null).
- NFR: providers in `presentation/providers/`; do not touch `data/` except via provider (code-standards §4).

## Architecture / Data flow
`profileRepositoryProvider` (DI stub) → `getProfileProvider` (usecase) → `profileProvider(userId)`
(FutureProvider.family) → wrapper reads `.when(...)`. `currentUserIdProvider` ← `authStateProvider`.

## Related Code Files
- Create: `lib/features/profile/presentation/providers/profile_providers.dart`
- Modify: `lib/core/l10n/app_vi.arb`, `app_en.arb`, `app_ja.arb` (add profile keys)
- Read for context: kudos_providers.dart, auth_providers.dart.

## Implementation Steps
1. `profileRepositoryProvider = Provider<ProfileRepository>((_) => StubProfileRepository());`
2. `getProfileProvider = Provider<GetProfile>((ref) => GetProfile(ref.watch(profileRepositoryProvider)));`
3. `profileProvider = FutureProvider.family<ProfileData, String>((ref, id) => ref.watch(getProfileProvider).call(id));`
4. `currentUserIdProvider = Provider<String?>((ref) => ref.watch(authStateProvider).valueOrNull?.id);`
5. Add ARB keys (vi/en/ja) for all profile labels + loading/error/empty/retry; run `fvm flutter gen-l10n`.

## Todo List
- [ ] profile_providers.dart
- [ ] ARB keys ×3 + gen-l10n

## Success Criteria
- `fvm flutter analyze` clean; `gen-l10n` succeeds; no hardcoded UI strings introduced.

## Risk Assessment
- Low: self id null (logged-out) — router redirect already gates Profile behind auth; wrapper still guards null.

## Security Considerations
- No token/email in providers; identity limited to display id.

## Next Steps
- Unblocks INT (wrapper consumes `profileProvider` + `currentUserIdProvider`).
