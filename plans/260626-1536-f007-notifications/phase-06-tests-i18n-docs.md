# Phase 06 — Tests + i18n + docs (TEST)

## Context Links
- Plan: [plan.md](plan.md) · Depends on: [phase-05-integration.md](phase-05-integration.md)
- Pattern refs: existing widget tests under `test/` (375×812, `tester.view.physicalSize = Size(1170,2532); dpr=3`), `lib/core/l10n/app_{vi,en,ja}.arb`, `docs/project-changelog.md`, `docs/generated/feature-list.md`
- Standards: `docs/code-standards.md`; testing = mocktail, Fake repos via provider override.

## Overview
- **Priority:** P1 (done-gate) · **Status:** pending
- Prove the feature with the full test matrix, add VN/EN/JA strings, refresh docs.

## Requirements
- Functional: every FR has a test. Non-functional: no-overflow at 375px, i18n complete (no hardcoded VN leaking to JA/EN).

## Test Matrix
| Layer | Test | Covers |
|-------|------|--------|
| Unit | `StubNotificationFeedRepository` data/empty/error + markAsRead/markAllAsRead mutate-and-return | FR2,FR3,FR7 / P2 |
| Unit | `NotificationsController` build/refresh/markRead/markAllRead state transitions (override w/ Fake) | P3 |
| Unit | `notificationsUnreadCountProvider` derives correct count; decrements after markRead; 0 after markAll | FR5 / P3 R1,R3 |
| Widget | `NotificationsScreen` renders list rows (title/body/timestamp/icon) | FR2 |
| Widget | read vs unread visual distinction | FR3 |
| Widget | empty / loading / error+retry states | FR6 |
| Widget | tap row → `onTap` fires with correct notification | FR4 |
| Widget | no `RenderFlex overflowed` at 375×812 | overflow gotcha |
| Widget | i18n — pump VN/EN/JA, assert localized title/empty/error copy (no VN leak) | FR9 |
| Integration | `NotificationsRouteWrapper`: AsyncValue→loading/error/data; retry invalidates | P5 |
| Integration | tap kudos row → marks read → navigates to `/kudos/detail/:id` | FR4 deep-link |
| Integration | tap award row → sets `selectedAwardIdProvider` → Awards tab | FR4 deep-link |
| Integration | unsupported type → no crash (no-op/snackbar) | FR4 edge |
| Integration | badge: Home/Awards bell shows live count; decrements after a row read | FR5 / P3 R1 regression |

## i18n keys (add to all 3 ARB, default VN)
`notificationsTitle`, `notificationsEmpty`, `notificationsError`, `notificationsRetry`,
`notificationsMarkAllRead` (if affordance present), relative-time units if not using `intl`.
Replace the `// TODO(l10n)` placeholders pattern seen in kudos wrappers — use real keys here from the start.

## Related Code Files
**Create:** `test/features/notifications/**` (unit + widget + integration mirrors of `lib/features/notifications/**`), `test/core/router/notifications_route_wrapper_test.dart`.
**Modify:** `lib/core/l10n/app_vi.arb`, `app_en.arb`, `app_ja.arb`; `docs/project-changelog.md`, `docs/development-roadmap.md`, `docs/generated/feature-list.md` (mark F007 done), `docs/system-architecture.md` (note badge source moved to notifications feature; the home notification stub retired).

## Implementation Steps
1. Write unit tests (repo + controller + derived count).
2. Write widget tests (states, read/unread, tap, overflow, i18n) at the standard test surface.
3. Write integration/router tests (deep-links + badge regression for home/awards).
4. Add ARB keys to VN/EN/JA; run `fvm flutter gen-l10n`.
5. `fvm flutter analyze` + `fvm flutter test` — all green (existing 270 must not regress).
6. Update docs (changelog, roadmap, feature-list, system-architecture badge-source note).
7. Hand to `reviewer` agent.

## Todo List
- [ ] unit tests (repo, controller, derived count)
- [ ] widget tests (states, read/unread, tap, overflow, i18n VN/EN/JA)
- [ ] integration tests (kudos deep-link, award deep-link, no-op type, badge regression)
- [ ] ARB keys VN/EN/JA + gen-l10n
- [ ] analyze clean + full test suite green (no regression vs 270)
- [ ] docs updated
- [ ] reviewer pass

## Success Criteria (observable "done")
- `fvm flutter analyze` clean; `fvm flutter test` green incl. all new tests + prior suite.
- Every FR row in the matrix has a passing test.
- JA/EN runs show no Vietnamese leakage on Notifications.
- iOS simulator: bell → list → tap → deep-link → badge decrement works end-to-end.

## Risk Assessment
- **R1 (Med/Med):** badge regression in home/awards from P3 migration. Mitigation: the dedicated badge regression integration test (matrix last row).
- **R2 (Low/Low):** JA copy needs native review (known project debt). Mitigation: flag in completion message; not a blocker.

## Security Considerations
- None.

## Next Steps
- Feature complete → update memory build-status (F007 done); commit on a feature branch.
