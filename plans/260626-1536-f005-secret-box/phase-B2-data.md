# Phase B2 — Data: stub repository + mock reward data (Track B)

**Track:** B (logic) · **blockedBy:** B1 · **Status:** pending

## Context Links
- Pattern refs: `lib/features/kudos/data/repositories/stub_kudos_stats_repository.dart`,
  `lib/features/kudos/data/sources/kudos_mock_data.dart`
- Spec: `spec/secret-box/secret-box.md` (FR4–FR8)

## Overview
- **Priority:** P2 · **Status:** pending
- Implement `SecretBoxRepository` against in-memory stub data with the project's
  `Stub*Behavior {data, error}` + artificial delay convention.

## Key Insights
- Session-scoped mutable state: the stub holds `unopenedCount` and decrements on `open()`
  (in-memory only — no persistence, FR7). A new stub instance resets — acceptable for MVP.
- Reward variants are mock data sourced from design content; pick one on `open()` (deterministic
  or simple rotation — no randomness needed for MVP, keep testable).
- `assetRef` may be null (null-S3 design nodes) → reward UI must fall back (handled in A1).

## Requirements
- **Functional:** `getState()` returns current unopened count + opened rewards; `open()`
  decrements unopened, appends the chosen reward, returns it; error behavior throws a `Failure`.
- **Non-functional:** files < 200 lines; mirror existing stub delay (~600–800ms).

## Architecture
Data flow: controller → `OpenSecretBox` usecase → `StubSecretBoxRepository.open()` mutates
in-memory count → returns `SecretBoxReward` from `SecretBoxMockData`.

## Related Code Files
**Create:**
- `lib/features/secret_box/data/sources/secret_box_mock_data.dart` — reward list (design content) + initial state.
- `lib/features/secret_box/data/repositories/stub_secret_box_repository.dart` — `StubSecretBoxBehavior {data, error}`, delay, in-memory count.

**Modify:** none. **Delete:** none.

## Implementation Steps
1. `secret_box_mock_data.dart`: const list of `SecretBoxReward` (e.g. "1 áo phông SAA", …) from
   the 7 standby design variants; an initial `SecretBoxState` (e.g. unopenedCount=1).
2. `stub_secret_box_repository.dart`: implements `SecretBoxRepository`; `open()` guards
   unopenedCount>0 else throws/returns sentinel; decrements; returns next reward.
3. Use `core/error/failures.dart` `UnknownFailure` for the error behavior (match Kudos stub).

## Todo List
- [ ] secret_box_mock_data.dart
- [ ] stub_secret_box_repository.dart

## Success Criteria
- `fvm flutter analyze` clean; `open()` twice past supply surfaces the FR8 "none left" path.

## Risk Assessment
- **Med:** in-memory state lost on rebuild/hot-reload → stats may desync from feed. Mitigation —
  INT shares ONE repository/provider instance across feed stats + secret box (single source).

## Security Considerations
- None (local stub, no PII/network).

## Next Steps
- Unblocks B3 (providers wrap these).
