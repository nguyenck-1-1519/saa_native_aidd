# Phase 03 — Providers + badge migration (Track B)

## Context Links
- Plan: [plan.md](plan.md) · Depends on: [phase-02-data-stub-layer.md](phase-02-data-stub-layer.md)
- Pattern refs: `lib/features/kudos/presentation/providers/kudos_providers.dart` (DI + AsyncNotifier controller + refresh), `lib/features/home/presentation/providers/home_providers.dart` (current `unreadCountProvider` def at L77)
- Standards: `docs/code-standards.md` §4 (Riverpod: AsyncNotifier for action w/ loading/error; no StateProvider for business logic)

## Overview
- **Priority:** P1 · **Status:** pending
- Wire DI + a `NotificationsController` (AsyncNotifier) with `refresh`/`markRead`/`markAllRead`, expose a derived unread-count provider, and **migrate the header bell badge** off the hardcoded home stub onto this real source.

## Key Insights
- **CRITICAL migration:** today `unreadCountProvider` (in `features/home/.../home_providers.dart` L77) wraps `watchUnreadCountProvider` → `StubNotificationRepository` (hardcoded `3`). Both `home_screen.dart` (L176) and `awards_screen.dart` (L29) read it. F007 makes the badge reflect the real list and decrement on mark-read.
- **DRY / single source of truth:** unread count is **derived** from the notifications controller — NOT a parallel stream. Redefine `unreadCountProvider` to read the F007 controller. Keep the *symbol name and type* (`Provider`/`StreamProvider<int>` consumers use `.valueOrNull ?? 0`) stable so call sites need zero edits.
- Repository provider is a plain `Provider` (singleton, NOT autoDispose) so in-memory read-state survives navigation away and back (see P2 R1).

## Requirements
- Functional: load list w/ loading/empty/error+retry; mark one/all read updates list AND badge atomically. (FR3, FR5, FR6, FR7)
- Non-functional: zero call-site churn at home/awards; standards §4 provider conventions.

## Architecture
```
notificationFeedRepositoryProvider (Provider, singleton) → StubNotificationFeedRepository
getNotificationsProvider / markNotificationReadProvider / markAllNotificationsReadProvider (usecase DI)

NotificationsController (AsyncNotifier<List<AppNotification>>)
  build()        → getNotifications.call()
  refresh()      → AsyncLoading → guard(getNotifications.call())
  markRead(id)   → markNotificationRead.call(id) → state = AsyncData(updatedList)
  markAllRead()  → markAllNotificationsRead.call() → state = AsyncData(updatedList)

notificationsUnreadCountProvider (Provider<int>) =
  ref.watch(notificationsControllerProvider).valueOrNull?.where((n)=>!n.isRead).length ?? 0

// Badge migration — redefine the existing symbol to delegate here:
unreadCountProvider  → derive from notificationsUnreadCountProvider
```

## Related Code Files
**Create:**
- `lib/features/notifications/presentation/providers/notifications_providers.dart` — repo + usecase DI, `NotificationsController` (AsyncNotifier), `notificationsControllerProvider`, `notificationsUnreadCountProvider`.

**Modify:**
- `lib/features/home/presentation/providers/home_providers.dart` — repoint `unreadCountProvider` (L77) to derive from `notificationsUnreadCountProvider`; remove now-dead `watchUnreadCountProvider`/`notificationRepositoryProvider` *only if* nothing else uses them (grep first). Keep `unreadCountProvider` name + `.valueOrNull ?? 0` contract intact for home/awards.

**Delete (after grep confirms zero refs):**
- `lib/features/home/data/repositories/stub_notification_repository.dart`
- `lib/features/home/domain/repositories/notification_repository.dart`
- `lib/features/home/domain/usecases/watch_unread_count.dart`

## Implementation Steps
1. Create `notifications_providers.dart` (DI + controller + derived count), mirroring `kudos_providers.dart`.
2. `grep -rn "watchUnreadCount\|notificationRepositoryProvider\|StubNotificationRepository\|WatchUnreadCount" lib/ test/` — list every consumer.
3. Repoint `unreadCountProvider` to derive from `notificationsUnreadCountProvider`. If keeping `StreamProvider<int>` shape is simplest for consumers, wrap the derived int in a one-shot stream; else switch to `Provider<int>` (both satisfy `.valueOrNull ?? 0`? — note: plain `Provider<int>` has no `.valueOrNull`; consumers use `AsyncValue` API, so either keep it Async via `StreamProvider`/`FutureProvider`, OR update the 2 call sites to read `Provider<int>` directly). **Decide in step 3 after reading both call sites; document the choice.**
4. Delete the retired home notification files once grep shows zero remaining refs.
5. `fvm flutter analyze` whole project (catches broken imports from deletions).

## Todo List
- [ ] `notifications_providers.dart` (DI + controller + derived count)
- [ ] grep all consumers of the old home notification scaffold
- [ ] repoint `unreadCountProvider`; reconcile its type vs the 2 call sites
- [ ] delete retired home notification files (post-grep)
- [ ] project-wide analyze clean

## Success Criteria
- Badge count equals unread items in the controller; mark-read decrements it; mark-all → 0.
- Home + Awards bell still compile and show the live count with no call-site behavioral regression.
- No dead references to the deleted home notification scaffold.

## Risk Assessment
- **R1 (HIGH/HIGH):** badge migration breaks Home/Awards if `unreadCountProvider`'s type changes (they call `.valueOrNull`). Mitigation: keep an `AsyncValue`-shaped provider (`StreamProvider`/`FutureProvider<int>`) wrapping the derived count so `.valueOrNull ?? 0` keeps working — zero call-site edits. Verify with `fvm flutter analyze` + the home/awards widget tests in P6.
- **R2 (Med/Low):** deleting home files breaks an import elsewhere. Mitigation: grep gate before delete (step 2); project-wide analyze (step 5).
- **R3 (Low):** count not refreshing after mark-read because consumers cache. Mitigation: derive via `ref.watch` on the controller so it recomputes on every state change.

## Compatibility / Migration
- Call sites (`home_screen.dart` L176, `awards_screen.dart` L29) keep reading `unreadCountProvider` — name preserved. Migration is internal repointing, not a contract change.

## Security Considerations
- None new.

## Next Steps
- With P4, unblocks P5 (integration). Parallel with P4.
