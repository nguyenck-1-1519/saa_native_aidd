# Phase 05 — Integration: routing + bell + deep-links (INT)

## Context Links
- Plan: [plan.md](plan.md) · Depends on: [phase-03-providers-and-badge.md](phase-03-providers-and-badge.md) (Track B), [phase-04-notifications-screen-ui.md](phase-04-notifications-screen-ui.md) (Track A)
- Pattern refs: `lib/core/router/kudos_route_wrappers.dart` (ConsumerWidget wrapper binding providers → presentational screen), `lib/core/router/app_router.dart` (route table)

## Overview
- **Priority:** P1 (merge point) · **Status:** pending
- Join Track A (UI) + Track B (logic): bind `NotificationsScreen` to `notificationsControllerProvider`, replace the `/notifications` placeholder, and wire row taps to mark-read + deep-link.

## Key Insights
- Follow the established wrapper pattern: a package-private `ConsumerWidget` in a `core/router/*_route_wrappers.dart` file maps `AsyncValue` → loading/error/data and passes props to the presentational screen. Keeps `app_router.dart` <200 lines.
- Deep-link resolution lives **here**, not in domain/data: map `AppNotification` → action.
  - `kudosReceived` → `context.push(Routes.kudoDetailPath(targetId))` (target exists, F004 follow-up).
  - `award` → `ref.read(selectedAwardIdProvider.notifier).state = id; StatefulNavigationShell.of(context).goBranch(kAwardsBranchIndex)` (F003 pattern). NOTE: `goBranch` needs a shell context — `/notifications` is a standalone route OUTSIDE the shell. Resolve: pop to shell first then goBranch, OR route award notifications to Awards via `context.go(Routes.awards)` after setting the selection. **Decide at takumi time; default = `context.go` to the tab path.**
  - `secretBox` / `system` → no-op or coming-soon snackbar (F005 future).
- Tap order: **mark read first** (`controller.markRead(id)`), **then** navigate — so the badge decrements even if the user backs out.

## Requirements
- Functional: FR1 (real screen), FR4 (tap → mark read → deep-link), FR5 (badge reflects taps), FR8 (back preserves tab state). 
- Non-functional: `app_router.dart` stays <200 lines (use wrapper file).

## Architecture / Data flow
```
Bell (home/awards) → context.push(Routes.notifications)
  → NotificationsRouteWrapper (ConsumerWidget)
      watch notificationsControllerProvider (AsyncValue<List<AppNotification>>)
      .when(loading→spinner, error→retry(invalidate), data→NotificationsScreen(props))
      onTap(n): controller.markRead(n.id) → _resolveDeepLink(n) → navigate
      onMarkAllRead: controller.markAllRead()
  → badge (unreadCountProvider) recomputes from controller state
```

## Related Code Files
**Create:**
- `lib/core/router/notifications_route_wrapper.dart` — `NotificationsRouteWrapper` (ConsumerWidget) + private `_resolveDeepLink(BuildContext, WidgetRef, AppNotification)` helper.

**Modify:**
- `lib/core/router/app_router.dart` — replace the `/notifications` `PlaceholderScreen` builder (L150–154) with `const NotificationsRouteWrapper()`; add the import. Leave `Routes.notifications` constant unchanged.

**Read for context:** `home_screen.dart` L179–181 (bell already pushes `Routes.notifications` — no change needed), `awards_screen.dart` (bell wiring).

## Implementation Steps
1. Create `notifications_route_wrapper.dart` mirroring `AllKudosRouteWrapper` (loading/error/data, retry via `ref.invalidate(notificationsControllerProvider)`).
2. Implement `_resolveDeepLink`: switch on `NotificationType` → push kudos detail / set award selection + go awards / no-op snackbar.
3. Swap the `/notifications` builder in `app_router.dart`; add import.
4. Confirm the bell already routes (`home_screen.dart` L180, `awards_screen.dart`) — no edit unless tests show otherwise.
5. `fvm flutter analyze` + manual run on iOS simulator: open from bell, tap a kudos row → lands on detail, badge decremented.

## Todo List
- [ ] `NotificationsRouteWrapper` (binds controller, loading/error/data + retry)
- [ ] `_resolveDeepLink` (kudos / award / no-op branches)
- [ ] swap `/notifications` builder in `app_router.dart`
- [ ] verify bell push path (no regression)
- [ ] analyze clean + manual smoke on simulator

## Success Criteria
- Bell opens the real list; tap marks read + routes to the correct target (kudos detail / awards tab); unsupported types no-op gracefully.
- Badge count drops as rows are read; mark-all → badge 0.
- Back from `/notifications` returns to the originating tab with state intact.

## Risk Assessment
- **R1 (HIGH/Med):** `goBranch` unavailable outside the shell for award deep-links. Mitigation: use `context.go(Routes.awards)` after setting `selectedAwardIdProvider` (no shell context needed); validate award-deep-link nav test in P6.
- **R2 (Med/Med):** double-tap pushes detail twice. Mitigation: reuse the `_guardedPush` in-flight-flag idea from `home_screen.dart` if observed, else rely on GoRouter dedup.
- **R3 (Low):** kudos deep-link id not in `KudosDetailMockData` → detail screen errors. Mitigation: P2 mock data seeds kudos rows with real existing detail ids.

## Compatibility / Rollback
- Rollback = restore the `PlaceholderScreen` builder for `/notifications` (one-line revert) and revert the P3 badge repoint. Both are isolated, no cascading damage.

## Security Considerations
- Deep-links only target in-app routes (no external URLs); no injection surface.

## Next Steps
- Unblocks P6 (tests + i18n + docs).
