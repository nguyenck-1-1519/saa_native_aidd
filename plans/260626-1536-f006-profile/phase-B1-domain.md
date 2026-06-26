# Phase B1 — Domain: entities + repo interface + usecase

**Track B (logic). No blockedBy. First in the B chain.**

## Context Links
- Spec: plans/260626-1536-f006-profile/spec/profile/profile-spec-draft.md (reuse map + ProfileData shape)
- Reuse: `lib/features/kudos/domain/entities/kudos_stats.dart`, `lib/features/awards/domain/entities/award_detail.dart`, `lib/features/auth/domain/entities/auth_user.dart`
- Pattern mirror: `lib/features/kudos/domain/` (entity + repo interface + usecase split)

## Overview
- Priority: P2 · Status: pending
- Define the profile domain layer: a `ProfileData` aggregate composed of existing entities plus a
  thin `ProfileUser` (identity-for-display), a `ProfileRepository` interface, and a `GetProfile` usecase.

## Key Insights
- **Compose, do not duplicate.** Reuse `KudosStats` (counts/hearts), `AwardDetail` (awards), `Kudo`/
  `KudoDetail` (recent kudos). Only `ProfileUser` is genuinely new (profile owns display identity that
  `AuthUser` lacks: role, department, heroLevel, badges).
- Domain layer: **Dart only** — no Flutter, no Riverpod, no Supabase (code-standards §1).
- Errors via `throw Failure` (core/error/failures.dart) — no `Either` (code-standards §5).

## Requirements
- FR: `GetProfile(userId)` returns a `ProfileData` for any user (self or other) — `isSelf` is a
  presentation concern, not domain. Stub decides what data a userId maps to.
- NFR: each file < 200 lines; one usecase per file.

## Architecture / Data flow
`GetProfile(userId).call()` → `ProfileRepository.getProfile(userId)` → `ProfileData`.
`ProfileData { ProfileUser user; KudosStats stats; List<AwardDetail> awards; List<Kudo> recentKudos; }`
(Confirm at design-fetch whether `Kudo` carries enough for the recent-kudos row; if not, add a thin
`RecentKudoView` value object — only then.)

## Related Code Files
- Create: `lib/features/profile/domain/entities/profile_user.dart`
- Create: `lib/features/profile/domain/entities/profile_data.dart`
- Create: `lib/features/profile/domain/repositories/profile_repository.dart` (abstract interface)
- Create: `lib/features/profile/domain/usecases/get_profile.dart`
- Read for context: kudos/awards/auth entities above.

## Implementation Steps
1. `ProfileUser`: `{ id, name, role, department, avatarUrl?, heroLevel?, badges? }` with `==`/`hashCode` (mirror existing entity style).
2. `ProfileData`: bundle `ProfileUser` + reused entities; value equality on identity fields.
3. `ProfileRepository`: `abstract interface class` with `Future<ProfileData> getProfile(String userId);`.
4. `GetProfile`: ctor takes repo; `call(String userId)` delegates.

## Todo List
- [ ] profile_user.dart
- [ ] profile_data.dart
- [ ] profile_repository.dart
- [ ] get_profile.dart

## Success Criteria
- `fvm flutter analyze` clean. No Flutter/Riverpod import in `domain/`. Entities compose, not duplicate.

## Risk Assessment
- Med/Low: `Kudo` may lack a field the recent-kudos row needs → mitigate by adding a thin view object
  ONLY at design-fetch, not pre-emptively (YAGNI).

## Security Considerations
- `ProfileUser` is public display data only — no tokens, no email leakage in `toString()`.

## Next Steps
- Unblocks B2 (stub implements `ProfileRepository`).
