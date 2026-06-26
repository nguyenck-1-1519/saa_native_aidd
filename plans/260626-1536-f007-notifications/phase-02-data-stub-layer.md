# Phase 02 — Data / stub layer (Track B)

## Context Links
- Plan: [plan.md](plan.md) · Depends on: [phase-01-domain-layer.md](phase-01-domain-layer.md)
- Pattern refs: `lib/features/kudos/data/repositories/stub_kudos_feed_repository.dart` (behavior enum + delay), `lib/features/kudos/data/sources/kudos_mock_data.dart` (static mock), `lib/features/awards/data/repositories/fake_*` (named-ctor fakes)
- Standards: `docs/code-standards.md` §1 (data implements domain interface; no Flutter widgets)

## Overview
- **Priority:** P1 · **Status:** done
- Stub repository + mock data implementing `NotificationFeedRepository`, plus a Fake for tests. Mock copy/types sourced from MoMorph design.
- **Delivered:** StubNotificationFeedRepository + FakeNotificationFeedRepository + NotificationsMockData with mixed read/unread types + deep-link routes.

## Key Insights
- Mirror the proven trio: `Stub*Repository` (behavior enum `data|empty|error` + delay) for dev/QA; `Fake*Repository` (named ctors `data|empty|error|loading`) for tests; `*MockData` static const from design.
- Mark-read must mutate **in-memory** state so the badge decrements live during a session. Stub holds a mutable `List<AppNotification>` seeded from mock data; `markAsRead`/`markAllAsRead` flip `isRead` via `copyWith` and return the updated list.
- Mock data needs a spread of types + a mix of read/unread so the list, badge, and deep-link paths are all exercisable. Deep-link targets use real route strings: kudos rows → `Routes.kudoDetailPath(<mock kudo id from KudosDetailMockData>)`; award rows → a sentinel the integration maps to `goBranch` (store as a route-ish string, resolved in P5).

## Requirements
- Functional: serve list, empty, error; mark one/all read mutating in-memory. (FR2, FR3, FR5, FR6, FR7)
- Non-functional: artificial delay (~800ms, match kudos) to exercise loading; files <200 lines.

## Architecture
```
StubNotificationFeedRepository(behavior, delay)
  _items: List<AppNotification>  (mutable, seeded from NotificationsMockData.items)
  getNotifications()  → delay → switch(behavior): data=_items / empty=[] / error=throw UnknownFailure
  markAsRead(id)      → flip matching item's isRead via copyWith → return List.of(_items)
  markAllAsRead()     → map all to isRead:true → return List.of(_items)
```

## Related Code Files
**Create:**
- `lib/features/notifications/data/sources/notifications_mock_data.dart` — `NotificationsMockData.items` (static list; copy + types from MoMorph frame `_b68CBWKl5`). Reuse existing kudo ids from `KudosDetailMockData` for kudos-type deep-links so taps land on a real detail.
- `lib/features/notifications/data/repositories/stub_notification_feed_repository.dart` — `enum StubNotificationFeedBehavior { data, empty, error }` + mutable in-memory list.
- `lib/features/notifications/data/repositories/fake_notification_feed_repository.dart` — named ctors `.data() .empty() .error() .loading()` for widget/unit tests (mirrors `FakeKudosFeedRepository`).

**Read for context:** pattern refs above; `lib/features/kudos/data/sources/kudos_detail_mock_data.dart` for reusable ids.

## Implementation Steps
1. Build `NotificationsMockData.items` from the design frame (confirm types + copy at takumi time). Include ≥1 of each `NotificationType`, mix of read/unread, descending `createdAt`.
2. Implement `StubNotificationFeedRepository` with mutable list + behavior enum + delay; mutate-and-return on mark methods.
3. Implement `FakeNotificationFeedRepository` (no delay) with named ctors; `loading()` returns a never-completing future for the loading-state test.
4. `fvm flutter analyze lib/features/notifications/data`.

## Todo List
- [ ] `NotificationsMockData` (design-sourced, types confirmed)
- [ ] `StubNotificationFeedRepository` (behavior + delay + in-memory mutate)
- [ ] `FakeNotificationFeedRepository` (named ctors incl. loading)
- [ ] analyze clean

## Success Criteria
- Stub returns design-sourced data; mark-read mutates and the next `getNotifications` reflects it.
- Fake supports all four test states without real I/O.

## Risk Assessment
- **R1 (Med/Med):** in-memory mutation lost on stub re-creation (provider rebuild). Mitigation: keep the repository a singleton `Provider` (not autoDispose) in P3 so the session-level read-state survives navigation.
- **R2 (Low):** null MoMorph S3 icon URLs (known gotcha). Mitigation: UI maps `type → Material icon`, so icons don't depend on S3 at all.

## Security Considerations
- Mock copy only — no real user data.

## Next Steps
- Unblocks P3 (providers). Parallel with P4 (UI).
