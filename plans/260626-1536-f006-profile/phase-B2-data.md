# Phase B2 — Data: stub repository + mock data

**Track B (logic). blockedBy: B1.**

## Context Links
- Pattern mirror: `lib/features/kudos/data/repositories/stub_kudos_stats_repository.dart`, `lib/features/kudos/data/sources/kudos_mock_data.dart`, `lib/features/awards/data/sources/awards_detail_mock_data.dart`
- Interface: `lib/features/profile/domain/repositories/profile_repository.dart` (B1)

## Overview
- Priority: P2 · Status: pending
- Implement `StubProfileRepository` over static mock data. No backend (local stub only, like F002–F004).

## Key Insights
- Stub pattern: enum `StubProfileBehavior { data, error }`, artificial delay to exercise loading,
  `error` throws `UnknownFailure` (exactly mirrors `StubKudosStatsRepository`).
- Mock data = design content (from Figma) + composed reuse: pull award shapes consistent with F003
  mock, kudo shapes consistent with F004 mock, so self-profile numbers feel coherent with the rest of the app.
- Two mock users minimum: a "self" user and at least one "other" user keyed by userId, so the
  other-profile route resolves to real-looking stub data.

## Requirements
- FR: `getProfile(userId)` returns the self user's data for the self id and a distinct other user's
  data for any other id; unknown id → a sensible default other-user (no crash).
- NFR: data layer imports `domain/` only (no Flutter/Riverpod, code-standards §1); file < 200 lines.

## Architecture / Data flow
`StubProfileRepository.getProfile(userId)` → delay → `switch(behavior)` → `ProfileMockData.forUser(userId)`.

## Related Code Files
- Create: `lib/features/profile/data/sources/profile_mock_data.dart` (self + other users, avatars null → grey placeholder by design)
- Create: `lib/features/profile/data/repositories/stub_profile_repository.dart`
- Read for context: kudos/awards mock-data files above (keep numbers/awards coherent).

## Implementation Steps
1. `ProfileMockData`: `static ProfileData forUser(String userId)` — map known self id + ≥1 other id;
   reuse `KudosStats`, `AwardDetail`, `Kudo` instances (compose from values seen in design).
2. `StubProfileRepository implements ProfileRepository`: behavior enum + delay (800ms default),
   `data` → `ProfileMockData.forUser(id)`, `error` → `throw UnknownFailure`.

## Todo List
- [ ] profile_mock_data.dart
- [ ] stub_profile_repository.dart

## Success Criteria
- `fvm flutter analyze` clean. `getProfile(selfId)` ≠ `getProfile(otherId)`. Unknown id returns data, not throw.

## Risk Assessment
- Low: avatar nulls — handled by grey placeholder in UI (A1 contract). Keep nulls, do not invent URLs.

## Security Considerations
- Mock data only; no real PII, no secrets.

## Next Steps
- Unblocks B3 (providers DI the stub).
