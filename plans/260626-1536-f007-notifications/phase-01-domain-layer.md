# Phase 01 — Domain layer (Track B)

## Context Links
- Plan: [plan.md](plan.md) · Spec: [spec/notifications/notifications-spec.md](spec/notifications/notifications-spec.md)
- Pattern refs: `lib/features/kudos/domain/entities/kudo.dart`, `lib/features/kudos/domain/repositories/kudos_feed_repository.dart`, `lib/features/home/domain/usecases/watch_unread_count.dart`
- Standards: `docs/code-standards.md` §1 (domain = pure Dart, no Flutter/Riverpod/Supabase imports)

## Overview
- **Priority:** P1 (foundation) · **Status:** done
- Domain contracts for notifications: entity, type enum, repository interface, usecases. No Flutter imports.
- **Delivered:** AppNotification + NotificationType + NotificationFeedRepository interface + 3 usecases (GetNotifications, MarkNotificationRead, MarkAllNotificationsRead), pure Dart, no Flutter deps.

## Key Insights
- Domain must stay pure Dart (standards §1). `AppNotification` carries no widget/IconData — UI maps `type → icon`.
- `deepLinkTarget` is a plain route string (e.g. `/kudos/detail/abc`) or null; domain does not know about GoRouter.
- Existing `features/home` already has a `NotificationRepository` (unread-count only). F007 introduces a richer, feature-owned contract; the home one is retired in P3.

## Requirements
- Functional: model a notification, list them, mark one/all read, derive unread count. (FR1, FR2, FR3, FR4, FR5, FR7)
- Non-functional: pure Dart; throws `Failure` subtypes (no `Either`) per standards §5; files <200 lines.

## Architecture
Data flow (domain view):
```
UI → usecase(GetNotifications) → NotificationRepository.getNotifications() → List<AppNotification>
UI → usecase(MarkNotificationRead/MarkAllRead) → repository mutates → returns updated List<AppNotification>
unread count = notifications.where((n) => !n.isRead).length  (derived, not a separate source)
```

## Related Code Files
**Create:**
- `lib/features/notifications/domain/entities/notification_type.dart` — `enum NotificationType { kudosReceived, award, secretBox, system }` (confirm values vs MoMorph frame `_b68CBWKl5` at takumi time).
- `lib/features/notifications/domain/entities/app_notification.dart` — `AppNotification { id, type, title, body, createdAt (DateTime), isRead, deepLinkTarget (String?) }` + value-equality (`==`/`hashCode` on id, isRead) + `copyWith` (needed for mark-read).
- `lib/features/notifications/domain/repositories/notification_feed_repository.dart` — `abstract interface class`:
  - `Future<List<AppNotification>> getNotifications()` (throws `Failure`)
  - `Future<List<AppNotification>> markAsRead(String id)` (returns updated list)
  - `Future<List<AppNotification>> markAllAsRead()` (returns updated list)
- `lib/features/notifications/domain/usecases/get_notifications.dart` — `GetNotifications(repo)` → `call()`.
- `lib/features/notifications/domain/usecases/mark_notification_read.dart` — `MarkNotificationRead(repo)` → `call(String id)`.
- `lib/features/notifications/domain/usecases/mark_all_notifications_read.dart` — `MarkAllNotificationsRead(repo)` → `call()`.

**Read for context:** the pattern refs above.

## Implementation Steps
1. Create `notification_type.dart` enum (no display strings in domain — UI/l10n owns labels).
2. Create `app_notification.dart` with `copyWith` (used by stub mark-read to flip `isRead`).
3. Create `notification_feed_repository.dart` interface — mark methods return the **full updated list** so the controller can re-derive count in one round-trip (KISS: one source of truth).
4. Create the 3 usecase classes mirroring `WatchUnreadCount`/`GetKudosFeed` style (constructor takes repo, single `call`).
5. Run `fvm flutter analyze lib/features/notifications/domain`.

## Todo List
- [ ] `NotificationType` enum
- [ ] `AppNotification` entity + copyWith + equality
- [ ] `NotificationFeedRepository` interface
- [ ] 3 usecases (get / mark-read / mark-all-read)
- [ ] analyze clean

## Success Criteria
- `fvm flutter analyze` clean for the domain folder; zero Flutter/Riverpod imports in `domain/`.
- Entity + interface compile; usecases callable.

## Risk Assessment
- **R1 (Low/Med):** enum values differ from design. Mitigation: confirm against MoMorph frame before coding; enum is cheap to extend.
- **R2 (Low):** mark-read return shape. Returning full list (vs void) chosen so count derivation has a single source — avoids a second fetch.

## Security Considerations
- None (local stub, no PII beyond mock copy, no auth surface).

## Next Steps
- Unblocks P2 (data/stub). Runs in parallel with P4 (UI).
