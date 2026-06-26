# Phase INT — Integration: wire UI ↔ providers/router, stats sync (Track A+B)

**Track:** A+B (join) · **blockedBy:** B3, B4, A1 · **Status:** pending

## Context Links
- Feed entry: `lib/features/kudos/presentation/kudos_screen.dart` (line ~136 `onOpenSecretBox: null`),
  `lib/features/kudos/presentation/widgets/all_kudos_stats.dart` (`_OpenSecretBoxButton`)
- Stats: `lib/features/kudos/domain/entities/kudos_stats.dart`,
  `lib/features/kudos/presentation/providers/kudos_providers.dart` (`kudosStatsProvider`)
- Route: `lib/core/router/app_router.dart` (B4 placeholder builder)
- Screen + controller: A1 `secret_box_screen.dart`, B3 `secret_box_providers.dart`

## Overview
- **Priority:** P2 · **Status:** pending
- The single join point. Replace mock UI state with the live controller, rewire the feed button
  to navigate, finalize the route builder, and sync the feed stats after a successful open.

## Key Insights
- Feed button is currently disabled (`onOpenSecretBox: null` → button greyed). INT passes a
  real callback that does `context.push(Routes.secretBox)`.
- Stats sync (FR7): on `revealed`, `secretBoxOpened++` / `secretBoxUnopened--`. Cleanest path —
  derive the feed's secret-box counts from the SHARED `secretBoxRepositoryProvider` state, or
  invalidate `kudosStatsProvider` on pop so it re-reads. Decide at implement; prefer single source.
- FR8 already-opened: when `unopenedCount==0`, keep the feed button enabled but the screen shows
  a "none left / already opened" state (or disable the button — confirm against design).

## Requirements
- **Functional:** feed button → secretBox route; screen bound to controller (closed/opening/
  revealed); reveal animation fires on opening; close pops to feed; feed stats reflect the open.
- **Non-functional:** no `kudos_screen.dart` regression; analyze clean; no 375px overflow.

## Architecture (data flow end-to-end)
feed "Mở Secret Box" tap → `context.push('/secret-box')` → `SecretBoxScreen` watches
`SecretBoxController` → user taps box → `controller.open()` (phase=opening, animation) →
`OpenSecretBox` usecase → `StubSecretBoxRepository` decrements + returns reward → phase=revealed →
reward shown → close pops → feed re-reads shared state → stats updated.

## Related Code Files
**Modify:**
- `kudos_screen.dart` — pass real `onOpenSecretBox: () => context.push(Routes.secretBox)`.
- `all_kudos_stats.dart` — none expected (button already takes the callback); verify only.
- `app_router.dart` — swap B4 placeholder builder → `const SecretBoxScreen()`.
- `secret_box_screen.dart` — convert to `ConsumerWidget`, bind controller to `phase`/`reward`/
  `onOpen`/`onClose`; replace mock props.
- `kudos_providers.dart` — wire stats to the shared secret-box state (or invalidation on pop).

**Create / Delete:** none.

## Implementation Steps
1. Finalize route builder → real screen.
2. Rewire feed button callback.
3. Bind screen to controller (open/reset, phase-driven animation).
4. Implement stats sync via shared provider (or invalidate-on-pop).
5. Handle FR8 none-left state.
6. `fvm flutter analyze` + manual QA the full loop on iOS sim.

## Todo List
- [ ] Route builder swap
- [ ] Feed button rewire
- [ ] Screen ↔ controller binding
- [ ] Stats sync (FR7)
- [ ] None-left state (FR8)

## Success Criteria
- Tap "Mở Secret Box" → open → reveal reward → close → feed stats updated; no overflow; back works.

## Risk Assessment
- **High:** stats desync between feed and box (two sources of truth). Mitigation — ONE shared
  `secretBoxRepositoryProvider`; feed stats derive from it, never a parallel counter.
- **Med:** animation jank / stuck phase. Mitigation — controller guards error → closed; A1 uses
  `AnimationController` with `dispose`.

## Rollback
- Revert the 5 edited files; the route + secret_box module become dead code (harmless) until
  re-applied. Feed button returns to `onOpenSecretBox: null` (coming-soon stub) — no cascade.

## Security Considerations
- Logged-in only (auth redirect). No PII, no network.

## Next Steps
- Unblocks TEST.
