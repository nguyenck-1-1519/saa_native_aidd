# F007 Notifications — Spec Draft (minimal)

Feature code: **F007** · Work type: feature · Data: local stub only (no backend/push)
Screen ref (MoMorph, iOS, fileKey `9ypp4enmFmdK3YAFJLIu6C`):
- Notifications: `_b68CBWKl5` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/_b68CBWKl5

## Functional Requirements

- **FR1** Real Notifications list screen replaces `/notifications` PlaceholderScreen.
- **FR2** Each row shows: type icon, title, body, relative timestamp, read/unread visual state.
- **FR3** Read/unread styling — unread row visually distinct (per design; bg tint / dot / weight).
- **FR4** Tapping a row marks it read (local), then deep-links to the related screen where a target exists.
- **FR5** Unread badge count on the header bell reflects the real notification list; decrements as rows are read.
- **FR6** States: loading / empty / error+retry — mirror Home/Awards/Kudos pattern.
- **FR7** "Mark all as read" affordance if present in design (else deferred).
- **FR8** Back navigation returns to the caller (Home or Awards), preserving tab state.
- **FR9** i18n VN/EN/JA for all static labels (title, empty/error copy, "mark all read", relative-time units). Default VN.

## Notification types (confirm at runtime via MoMorph frame)

`NotificationType` enum — candidate values (verify against design):
`kudosReceived`, `award`, `secretBox`, `system`. Each maps to an icon + optional deep-link builder.

## Deep-link targets (wire where target exists, else no-op/coming-soon)

| Type | Target | Status |
|------|--------|--------|
| kudosReceived | `/kudos/detail/:id` (`Routes.kudoDetailPath`) | exists (F004 follow-up) |
| award | Awards tab via `goBranch(kAwardsBranchIndex)` + `selectedAwardIdProvider` | exists (F003) |
| secretBox | — | no-op (F005 future) |
| system | — | no-op or in-app body only |

## Entity

`AppNotification` (domain, framework-free):
`id, type (NotificationType), title, body, createdAt (DateTime), isRead (bool), deepLinkTarget (String? — route path or null)`.

## Out of scope / defer list

- Real backend / push notifications (FCM/APNs) — DI seam left to swap stub later.
- Notification settings/preferences screen.
- Secret-box deep-link (depends on future F005).
- Persisting read-state across app restarts (in-memory for MVP unless design demands otherwise).
- Pagination / infinite scroll (single stub list).

## Provenance

- `builds_on: 260625-2309-kudos-remaining-screens` (kudos deep-link target).
- Existing scaffold to migrate: `features/home` `NotificationRepository` + `watchUnreadCount` +
  `unreadCountProvider` currently emit a hardcoded stub (3). F007 takes ownership of the badge source.
