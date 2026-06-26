---
title: "F008 System/Error screens (Access Denied + Not Found)"
description: "Two static iOS error screens (403/404) + go_router errorBuilder & access-denied wiring."
status: completed
priority: P2
effort: 3h
branch: feat/kudos-remaining-screens
tags: [flutter, ios, routing, error-screens, presentation, F008]
created: 2026-06-26
completed: 2026-06-26
work_type: feature
spec_draft: plans/260626-1536-f008-system-screens/spec/system-screens/
---

# F008 — System/Error Screens

Two static, presentation-only screens for an iOS-first Flutter app:
**Access Denied (403)** and **Not Found (404)**. No data/domain layer. CTAs navigate
Home/Login via go_router based on auth state. Wire go_router `errorBuilder` (404) and
re-point `/access-denied` (403) from the placeholder to the real screen.

## Architecture decision
New presentation-only feature **`lib/features/system/presentation/`**, mirroring the
flat `lib/features/placeholder/presentation/` layout (no `lib/shared/` exists). Each screen
its own file < 200 lines. Justification: keeps error screens grouped, follows the existing
single-folder pattern for layer-less UI, avoids inventing a `shared/` convention (KISS).

## Two-track shape (MoMorph create-plan: tracks stay parallel-runnable; NO UI subagents spawned now)
- **Track A — UI** (parallel, one phase per screen, ≤30 lines each): Phase 01, Phase 02.
- **Track B — logic/routing** (the integration): Phase 03.
- No `blocks`/`blockedBy` between Track A and Track B. Phase 03 *consumes* the widgets A
  produces; it is the integration point. Phase 04 (tests) depends on all.

## Phases
| # | Phase | Track | Status | Depends on | File ownership |
|---|-------|-------|--------|-----------|----------------|
| 01 | AccessDeniedScreen UI | A | done | — | `lib/features/system/presentation/access_denied_screen.dart` |
| 02 | NotFoundScreen UI | A | done | — | `lib/features/system/presentation/not_found_screen.dart` |
| 03 | Routing wiring + i18n (integration) | B | done | 01, 02 | `lib/core/router/app_router.dart`, `lib/core/l10n/app_*.arb` |
| 04 | Tests | — | done | 03 | `test/features/system/**`, `test/core/router/**` |

Track A & B are independently runnable by `tkm:takumi`; Phase 03 integrates. To keep file
ownership clean, Phase 03 owns the router + ARB edits; Phase 01/02 own only their screen file.

## Dependency graph
```
01 (AccessDenied UI) ─┐
                      ├─→ 03 (routing + i18n) ─→ 04 (tests)
02 (NotFound UI)    ─┘
```

## Key integration points
- `lib/core/router/app_router.dart`: `Routes.accessDenied` exists (line 43); currently → PlaceholderScreen (line 197-201). No `errorBuilder` on the `GoRouter` yet. `redirect` only sends unauth→login (no 403 source today).
- `authStateProvider` (`lib/features/auth/presentation/providers/auth_providers.dart`) — read to pick CTA target.
- `AppLocalizations` (`lib/core/l10n/`) — add keys, run `fvm flutter gen-l10n`.

## Success criteria (observable)
- `fvm flutter analyze` clean; `fvm flutter test` green.
- Navigating to an unknown path renders NotFoundScreen (widget test).
- `/access-denied` renders AccessDeniedScreen; CTA navigates to home (logged-in) / login (logged-out).
- No overflow at 320pt width; all 3 locales resolve every key.

## Rollback
Each phase is additive. Revert order: 04 → 03 → 02 → 01.
Phase 03 is the only edit to existing files — reverting it restores PlaceholderScreen at
`/access-denied` and removes `errorBuilder` (404 falls back to go_router default). Phases
01/02 add new files only; deleting them is a clean rollback with no cascade.

## Completion Note (2026-06-26)

All phases delivered on schedule. AccessDeniedScreen + NotFoundScreen built from MoMorph designs; system_route_wrappers.dart adds auth-aware CTA logic; router wired (errorBuilder→NotFound, /access-denied→AccessDenied); 6 ARB keys added (vi/en/ja); 35 tests green covering flows, layout, i18n. Reviewer APPROVE-WITH-NITS; H1+M1+L1 fixed. No real 403 source today (future-gated, documented). Code analyzed clean. 306/306 tests passing (includes 271 regressions + 35 F008-specific).

See detailed phase files and reports in this plan directory.
