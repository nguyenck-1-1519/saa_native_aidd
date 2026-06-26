# Phase B4 — Router: un-retire detail, add all/content routes (Track B)

**Track:** B (logic) · **blockedBy:** B3 · **Status:** done · **Priority:** P2

## Context links
- Router: `lib/core/router/app_router.dart`
- F004 retired `/kudos-detail`, `/kudos-feed`, `/about-kudos` → goBranch(kKudosBranchIndex)

## Overview
Add routes for the 5 new screens. F004 collapsed detail into the feed tab as a placeholder
shortcut — now restore a real detail destination. Keep the shell/tab structure intact.

## Requirements
- **Routes to add** (full-screen push outside shell, like `/write-kudo`):
  - `/kudos/all` → AllKudosScreen
  - `/kudos/:id` (or `/kudos/detail/:id`) → ViewKudoScreen (id param → kudoDetailProvider)
  - `/kudos/community-standards` → CommunityStandardsScreen
  - `/kudos/rules` → KudosRulesScreen
- **Route constants** in `Routes` (mirror `writeKudo`). Avoid clashing with tab `kudos = '/kudos'`.
- **View kudo anonymous** = same `/kudos/:id` route; A3 is a render branch on `isAnonymous`
  (no separate route).
- Document param contract for INT (id passing).

## Related code files
- Modify: `lib/core/router/app_router.dart` (add 4 routes + constants + builders/imports)

## Todo
- [x] Route constants (allKudos, kudoDetail, communityStandards, kudosRules)
- [x] GoRoute entries (full-screen push) with builders
- [x] `:id` param plumbing into ViewKudoScreen
- [x] Comment updating the F004 "retired routes" note

## Success criteria
- `flutter analyze` clean; deep navigation works; back returns to caller. No tab-structure regression.

## Risk
- `/kudos/:id` must not shadow `/kudos` tab or `/kudos/all`/`/kudos/rules` — order/literal-vs-param
  carefully (literal routes before param route, or use `/kudos/detail/:id`).

## Delivered
Routes added (/kudos/all, /kudos/detail/:id, /kudos/community-standards, /kudos/rules) via kudos_route_wrappers.dart.

## Next
- INT wires feed/all "Xem chi tiết"→detail, "View all"→all, form link→community-standards.
