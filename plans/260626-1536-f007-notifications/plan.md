---
title: "F007 Notifications — list screen + real bell badge"
description: "Real Notifications list (local stub) replacing the placeholder, with read/unread, deep-links, and a header bell badge wired to the actual list."
status: pending
priority: P2
effort: 7h
branch: main
tags: [flutter, notifications, momorph, clean-architecture, stub]
work_type: feature
feature_code: F007
spec_draft: plans/260626-1536-f007-notifications/spec/notifications/
builds_on: 260625-2309-kudos-remaining-screens
created: 2026-06-26
---

# F007 Notifications

Build the real Notifications list screen behind `Routes.notifications = '/notifications'`
(currently a `PlaceholderScreen`). Local stub data only — no backend/push, consistent
with F002–F004. The header bell badge moves from a hardcoded stub stream to the real
notification list state.

## MoMorph refs
- Notifications: `_b68CBWKl5` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/_b68CBWKl5
- fileKey `9ypp4enmFmdK3YAFJLIu6C` (iOS design)

## Two-track shape (MoMorph create-plan rule)
Track A (UI) and Track B (logic) are **parallel-runnable** — NO blocks/blockedBy between them.
A dedicated integration phase (P5) joins them. Track A phase is minimal (≤30 lines) per the
MoMorph development rule; `momorph-implement-design` fills the visual detail at takumi time.

## Phases

| # | Phase | Track | Status | Depends on |
|---|-------|-------|--------|-----------|
| P1 | [Domain layer](phase-01-domain-layer.md) | B | pending | — |
| P2 | [Data / stub layer](phase-02-data-stub-layer.md) | B | pending | P1 |
| P3 | [Providers + badge migration](phase-03-providers-and-badge.md) | B | pending | P2 |
| P4 | [NotificationsScreen UI](phase-04-notifications-screen-ui.md) | A | pending | — |
| P5 | [Integration: routing + bell + deep-links](phase-05-integration.md) | INT | pending | P3, P4 |
| P6 | [Tests + i18n + docs](phase-06-tests-i18n-docs.md) | TEST | pending | P5 |

## Dependency graph

```
P1 ─▶ P2 ─▶ P3 ─┐
                ├─▶ P5 ─▶ P6
P4 ─────────────┘
```

Track A (P4) and Track B (P1→P2→P3) run concurrently. P5 is the single merge point.

## Key decisions (hand-off, decided)
- Data = local stub only. DI seam (`notificationRepositoryProvider`) left to swap for a real API later.
- Badge source migrates: existing `features/home` `unreadCountProvider` (hardcoded stub `3`) → derived
  from the F007 notifications controller. The old `features/home` notification stub is retired (see P3 risk).
- `AppNotification` entity carries an optional `deepLinkTarget` route string; tap marks read then routes.
- Read-state is in-memory for MVP (resets on restart) unless design mandates persistence.

## Critical pre-work (takumi time, not now)
MoMorph frame `_b68CBWKl5` must be read FIRST to confirm: exact notification types, row layout,
read/unread visual treatment, presence of "mark all as read", and copy strings (mock-data source).

## Cross-feature touch points
- `lib/core/router/app_router.dart` — `/notifications` builder (P5).
- `lib/features/home/presentation/home_screen.dart` + `awards_screen.dart` — bell badge source (P3/P5).
- `lib/features/home/presentation/providers/home_providers.dart` — retire old `unreadCountProvider` source (P3).
- Kudos `/kudos/detail/:id` + Awards tab `goBranch` — deep-link targets (P5).

## Reports
Research/scout reports → `plans/260626-1536-f007-notifications/reports/`.
