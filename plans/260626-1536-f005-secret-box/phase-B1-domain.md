# Phase B1 — Domain: entities, phase, repository, usecases (Track B)

**Track:** B (logic) · **blockedBy:** none · **Status:** pending

## Context Links
- Spec: `spec/secret-box/secret-box.md` (FR1–FR9)
- Pattern refs: `lib/features/kudos/domain/entities/kudos_stats.dart`,
  `lib/features/kudos/domain/repositories/kudos_stats_repository.dart`,
  `lib/features/kudos/domain/usecases/get_kudos_stats.dart`

## Overview
- **Priority:** P2 · **Status:** pending
- Define the pure domain layer for the Secret Box flow: the reward entity, the reveal phase
  enum, the repository interface, and usecases. No Flutter imports.

## Key Insights
- Mirror Kudos domain style: immutable entity with `==`/`hashCode`, repository returns
  `Future`, one usecase per call as a callable class (`call()`).
- The 7 reward variants are DATA (`SecretBoxReward` instances), not types/screens (DRY).

## Requirements
- **Functional:** model a reward (FR4/FR5), the reveal phase (FR2–FR4), fetch the box state
  (opened? how many unopened — FR8), and an "open box" action returning the revealed reward (FR4).
- **Non-functional:** files < 200 lines; no presentation/data imports.

## Architecture
Data flow: `OpenSecretBox` usecase → `SecretBoxRepository.open()` → returns a `SecretBoxReward`.
`GetSecretBoxState` usecase → `SecretBoxRepository.getState()` → returns `SecretBoxState`
(remaining unopened count + already-opened rewards). `SecretBoxPhase` is a UI-facing enum the
controller drives; domain stays phase-agnostic except exposing it as the canonical enum.

## Related Code Files
**Create:**
- `lib/features/secret_box/domain/entities/secret_box_reward.dart` — `{id, name, assetRef?, descriptor}`.
- `lib/features/secret_box/domain/entities/secret_box_state.dart` — `{unopenedCount, openedRewards}`.
- `lib/features/secret_box/domain/value_objects/secret_box_phase.dart` — enum `closed, opening, revealed`.
- `lib/features/secret_box/domain/repositories/secret_box_repository.dart` — `getState()`, `open()`.
- `lib/features/secret_box/domain/usecases/get_secret_box_state.dart`
- `lib/features/secret_box/domain/usecases/open_secret_box.dart`

**Modify:** none. **Delete:** none.

## Implementation Steps
1. Create `SecretBoxReward` (immutable, `==`/`hashCode`, `assetRef` nullable for null-S3 fallback).
2. Create `SecretBoxState` (immutable).
3. Create `SecretBoxPhase` enum.
4. Create `SecretBoxRepository` abstract interface.
5. Create `GetSecretBoxState` + `OpenSecretBox` callable usecases over the repository.

## Todo List
- [ ] secret_box_reward.dart
- [ ] secret_box_state.dart
- [ ] secret_box_phase.dart
- [ ] secret_box_repository.dart
- [ ] get_secret_box_state.dart
- [ ] open_secret_box.dart

## Success Criteria
- `fvm flutter analyze` clean for the new domain files; no Flutter/material imports in domain.

## Risk Assessment
- **Low:** over-modeling. Mitigation — keep entities to fields the design + stub actually use (YAGNI).

## Security Considerations
- None (no PII, no network, local stub).

## Next Steps
- Unblocks B2 (stub repo implements `SecretBoxRepository`).
