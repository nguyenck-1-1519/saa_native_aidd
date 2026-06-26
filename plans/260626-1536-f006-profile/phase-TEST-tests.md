# Phase TEST — Tests

**blockedBy: INT. Status: done.** Tester owns `test/**` only (reads impl, never edits it — team rule).

Delivered: 63 profile tests (domain/data/provider/widget/overflow/i18n/nav). All green. FakeProfileRepository + unit tests (GetProfile, ProfileData ==/hashCode, StubProfileRepository behavior). Widget tests: self/other affordance delta, header/stats/awards/recent-kudos sections, loading/error/empty states, narrow-width overflow, vi/en/ja l10n. Nav tests: route-shadow guard (/profile vs /profile/:userId), recent-kudo tap → kudoDetail, kudo sender/recipient tap → /profile/:userId. Review DONE_WITH_CONCERNS 7/10; fixed H1 (filter), H2 (awards render), H3 (k-suffix), M1 (route-shadow test), M2 (empty fixture).

## Context Links
- Test patterns: `test/features/kudos/` (data + presentation), `ProviderScope(overrides:[...])` with Fake repo
- Code-standards §8: Fake* over stub for tests, all tests pass offline.

## Overview
- Priority: P2 · Status: pending
- Prove F006 behavior: self vs other rendering, each section, navigation, no-overflow, i18n.

## Test Matrix

| Layer | What it proves |
|-------|----------------|
| **Unit (domain)** | `GetProfile(id)` delegates to repo; `ProfileData` value equality; `ProfileUser` ==/hashCode |
| **Unit (data)** | `StubProfileRepository.data` returns self≠other; unknown id → default (no throw); `error` → `UnknownFailure` |
| **Unit (provider)** | `profileProvider(id)` resolves via Fake; `currentUserIdProvider` reads auth id / null when logged-out |
| **Widget** | self renders edit/settings affordances; other hides them; header/stats/awards/recent-kudos sections present with stub data; loading shows spinner; error shows retry; empty awards/kudos handled |
| **Widget (overflow)** | renders at narrow width + long name/department + many badges → no RenderFlex overflow |
| **Widget (i18n)** | section labels resolve in vi / en / ja (no missing-key, no raw key shown) |
| **Integration (nav)** | tap recent kudo → kudoDetail route; tap kudo sender/recipient → `/profile/:userId`; `/profile` tab vs `/profile/:userId` resolve correctly (route-shadow guard) |

## Related Code Files
- Create: `test/features/profile/data/stub_profile_repository_test.dart`
- Create: `test/features/profile/domain/get_profile_test.dart`
- Create: `test/features/profile/presentation/profile_providers_test.dart`
- Create: `test/features/profile/presentation/profile_screen_test.dart` (self/other/sections/states)
- Create: `test/features/profile/presentation/profile_overflow_i18n_test.dart`
- Create: `test/features/profile/presentation/profile_navigation_test.dart` (route + tap-through)
- Create: `lib/features/profile/data/repositories/fake_profile_repository.dart` (implements ProfileRepository, no delay — for test overrides)

## Implementation Steps
1. Add `FakeProfileRepository` (same interface, deterministic, zero delay).
2. Domain/data/provider unit tests with mocktail / Fake.
3. Widget tests inject Fake via `ProviderScope(overrides:[profileRepositoryProvider.overrideWith(...)])` + auth override for self id.
4. Overflow test at small `MediaQuery` size; i18n test pumps each locale.
5. Nav test drives GoRouter, asserts pushed locations (kudoDetail + profileUser) and the shadow guard.

## Todo List
- [ ] Fake repo + unit tests (domain/data/provider)
- [ ] Widget tests: self/other + sections + states
- [ ] Overflow + i18n tests
- [ ] Navigation tests (route shadow + tap-through)
- [ ] `fvm flutter test` + `fvm flutter analyze` green

## Success Criteria
- All tests pass offline (no Supabase/Google). `fvm flutter analyze` clean. Self/other delta, all sections,
  both nav paths, route-shadow, no-overflow, and 3-locale i18n all covered and green.

## Risk Assessment
- Med: route-shadow regression is the highest-impact bug — its nav test is the gate. Do NOT skip/soft-pass it.

## Next Steps
- Green → hand to reviewer; update docs (changelog/roadmap/feature-list) for F006.
