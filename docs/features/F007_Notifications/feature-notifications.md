---
feature_id: F007
title: Notifications list (iOS)
lang: vi
platform: iOS (Flutter) — Android sau
momorph_screen: _b68CBWKl5
status: implemented (local stub — no real backend/push)
depends_on: F002 Home (unreadCountProvider migrated here), F004 Kudos, F005 Secret Box
---

# F007 — Notifications

## 1. Mục tiêu

Hiển thị danh sách thông báo của người dùng, đánh dấu đã đọc từng item hoặc toàn bộ, và điều hướng deep-link tới màn liên quan. Badge chuông trên Home + Awards phản ánh số thông báo chưa đọc thực tế (single source of truth từ `notificationsUnreadCountProvider`).

## 2. Màn — NotificationsScreen (screenId _b68CBWKl5)

Route: `/notifications` (standalone — ngoài shell, không có bottom nav).
Entry: biểu tượng chuông trên `HomeHeader` (REG001).

## 3. Module

```
lib/features/notifications/
├── domain/
│   ├── entities/app_notification.dart       # id, title, body, type, isRead, createdAt, deepLinkTarget?
│   ├── entities/notification_type.dart      # enum NotificationType
│   ├── repositories/notification_feed_repository.dart
│   ├── usecases/get_notifications.dart
│   ├── usecases/mark_notification_read.dart
│   └── usecases/mark_all_notifications_read.dart
├── data/
│   ├── repositories/stub_notification_feed_repository.dart  # in-memory local stub
│   ├── repositories/fake_notification_feed_repository.dart
│   └── sources/notifications_mock_data.dart
└── presentation/
    ├── notifications_screen.dart            # pure widget (props-driven)
    ├── notifications_mock_data.dart         # kNotificationsMockItems
    ├── providers/notifications_providers.dart
    └── widgets/
        ├── notification_item.dart
        ├── notifications_empty_state.dart
        ├── notifications_mark_all_button.dart
        └── notifications_nav_bar.dart
```

Router wrapper: `lib/core/router/notifications_route_wrapper.dart` — ConsumerWidget; binds `NotificationsScreen` to `notificationsControllerProvider`; handles loading/error states; resolves deep-links on tap.

## 4. Notification Types

```dart
enum NotificationType { kudos, award, secretBox, system }
```

| Type | typeKey (UI) | Icon colour |
|---|---|---|
| `kudos` | `kudos` | Blue (envelope) |
| `award` | `badge` | Blue (shield) |
| `secretBox` | `secretBox` | Green (gift) |
| `system` | `system` | Grey (bell) |

## 5. Deep-link table

| NotificationType | deepLinkTarget | Action |
|---|---|---|
| `kudos` | kudo ID (non-null) | `context.push('/kudos/detail/:id')` |
| `kudos` | null | no-op (mark-read only) |
| `award` | award ID (non-null) | set `selectedAwardIdProvider`, `context.go('/awards')` |
| `award` | null | `context.go('/awards')` |
| `secretBox` | — | `context.push('/secret-box')` |
| `system` | — | no-op (mark-read only) |

## 6. State management

- `notificationsControllerProvider` — `AsyncNotifier<List<AppNotification>>`. Exposes `refresh()`, `markRead(id)`, `markAllRead()`.
- `notificationsUnreadCountProvider` — `Provider<int>`. Derived from controller state; returns 0 on loading/error.
- `unreadCountProvider` — `StreamProvider<int>` in `home_providers.dart`. Re-emits `notificationsUnreadCountProvider` as a stream so `HomeHeader` badge stays reactive.

## 7. Bell badge migration

Prior to F007 the Home screen carried a hardcoded stub (3 files) that always showed 3 unread.  
F007 deleted that stub. `unreadCountProvider` (`StreamProvider`) now re-emits `notificationsUnreadCountProvider`, which is derived from the live `notificationsControllerProvider` state. Home and Awards bell badges both watch `unreadCountProvider` — single source of truth, no desync.

## 8. Functional requirements (FR)

| Code | Requirement |
|---|---|
| FR1 | Screen shows list of notifications newest-first |
| FR2 | Unread items visually distinguished from read items |
| FR3 | Tapping an item marks it read and resolves deep-link (see §5) |
| FR4 | "Mark all read" button clears all unread badges immediately |
| FR5 | Empty state shown when list is empty |
| FR6 | Pull-to-refresh re-fetches from repository |
| FR7 | Bell badge on Home + Awards reflects real unread count (derived from controller) |

## 9. i18n

Keys added to ARB files (vi/en/ja): `notificationsTitle`, `notificationsMarkAllRead`, `notificationsEmpty`, `notificationsError`, `notificationsRetry`. JA cần review người bản ngữ.

Relative time labels (`_relativeTime` in route wrapper) are hardcoded Vietnamese strings — proper i18n (flutter_timeago or intl-based) deferred.

## 10. Tồn đọng (deferred)

- Real push notification backend + FCM token registration.
- Read-state persistence (in-memory only — cleared on app restart).
- Relative-time i18n (en/ja localised labels).
- Pagination (infinite scroll) — current stub returns a fixed list.
- Notification preferences / settings screen.
