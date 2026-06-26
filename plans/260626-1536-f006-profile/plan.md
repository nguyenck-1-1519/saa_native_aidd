---
title: "F006 Profile — self + other (one ProfileScreen, isSelf branch)"
description: "Build the real Profile tab (branch 3) for the iOS Flutter app: self profile + other-user profile as ONE ProfileScreen with an isSelf branch. Header, stats, awards, recent kudos — composed over local stub data, reusing F003 Awards + F004 Kudos entities. MoMorph two-track."
status: pending
priority: P2
effort: 14h
branch: main
work_type: feature
spec_draft: plans/260626-1536-f006-profile/spec/profile/
tags: [flutter, profile, momorph, feature]
created: 2026-06-26
builds_on: [260624-0839-awards-detail-screen, 260625-2309-kudos-remaining-screens]
---

# F006 Profile — self + other

Builds the real Profile screen(s). The Profile tab (bottom-nav branch 3, `Routes.profile`)
is currently a `PlaceholderScreen` (`lib/core/router/app_router.dart` branch 3). This feature
replaces it with a real `ProfileScreen` and adds an "other user" profile route.

**ONE `ProfileScreen` + `isSelf` branch** (self shows edit/settings affordances; other hides them) —
NOT two duplicate files (DRY). Data is **local stub only** (no backend), consistent with F002–F004.
Composes existing F003 Awards + F004 Kudos entities — does NOT duplicate them.

MoMorph two-track: Track A (UI, runtime `momorph-implement-design`) runs parallel to Track B
(logic). No `blocks` between A and B. The INT phase is the only join. Executed by `tkm:takumi`.

## MoMorph refs (fileKey 9ypp4enmFmdK3YAFJLIu6C — iOS)
- Profile bản thân (self):  `hSH7L8doXB` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
- Profile người khác (other): `bEpdheM0yU` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU
- Clarifications: plans/260626-1536-f006-profile/spec/profile/profile-spec-draft.md (defer list + open items)

## Phases

| # | Phase | Track | Status | Depends on |
|---|-------|-------|--------|------------|
| B1 | [Domain — entities + repo interface + usecase](phase-B1-domain.md) | B | pending | — |
| B2 | [Data — stub repository + mock data](phase-B2-data.md) | B | pending | B1 |
| B3 | [Providers + l10n keys](phase-B3-providers-l10n.md) | B | pending | B2 |
| A1 | [UI — ProfileScreen (self + other via isSelf)](phase-A1-ui-profile.md) | A | pending | — |
| INT | [Integration — wrapper, router rewire, other-profile entry](phase-INT-integration.md) | — | pending | A1, B3 |
| TEST | [Tests — render/stats/awards/kudos/nav/overflow/i18n](phase-TEST-tests.md) | — | pending | INT |

**Track independence (MoMorph rule):** A1 has NO `blocks`/`blockedBy` against B1–B3. Both
tracks are concurrently runnable. INT is the single join; TEST follows INT.

## Dependency graph

```
Track B:  B1 ──> B2 ──> B3 ──┐
                             ├──> INT ──> TEST
Track A:  A1 ────────────────┘
```

## Key dependencies / integration points

- `lib/core/router/app_router.dart` — replace branch-3 `PlaceholderScreen` with the self
  `ProfileScreen`; add `/profile/:userId` (full-screen push, outside shell) for other profiles.
- `lib/features/auth` — `authStateProvider` / `AuthUser` supplies self identity.
- `lib/features/kudos/domain/entities` — `KudosStats`, `Kudo`, `KudoDetail`, `KudoRecipient` reused.
- `lib/features/awards/domain/entities/award_detail.dart` — `AwardDetail` reused for awards section.
- `Routes.kudoDetailPath(id)` — tap a recent kudo → existing kudo detail route.
- Other-profile entry: kudo sender/recipient tap in `view_kudo_screen` / kudo cards (wire where feasible).

## Iron Laws

- **DRY:** one ProfileScreen (isSelf), compose existing entities, reuse stub/provider/wrapper patterns.
- **KISS:** FutureProvider for the profile aggregate (no retry controller unless design needs it).
- **YAGNI:** no backend, no edit submission, no social actions — see spec defer list.

## Unresolved (carried to design-fetch — see spec open items)
- Exact self-vs-other affordance delta; hero level/badges placement; recent-sent vs received.
