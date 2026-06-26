# Spec draft — F008 System/Error screens

> Minimal spec. Provenance: hand-off brief (decided), MoMorph iOS designs, existing router.
> Feature code: **F008**. Type: feature (presentation-only).

## Screens
| Screen | Trigger | MoMorph (fileKey 9ypp4enmFmdK3YAFJLIu6C) |
|--------|---------|--------------------------------------------|
| Access Denied (403) | auth/permission guard blocks access; route `/access-denied` | screen `k-7zJk2B7s` — https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/k-7zJk2B7s |
| Not Found (404) | unknown route via go_router `errorBuilder` | screen `sn2mdavs1a` — https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/sn2mdavs1a |

## Functional requirements
- **FR1** AccessDeniedScreen: static illustration + message + CTA. Renders at `/access-denied`.
- **FR2** NotFoundScreen: static illustration + message + CTA. Renders for any unmatched route.
- **FR3** CTA navigation via go_router:
  - Logged-in user → CTA "Về Home" → `Routes.home` (`context.go`).
  - Logged-out user → CTA "Về Login" → `Routes.login` (`context.go`).
  - CTA target chosen from `authStateProvider` (loggedIn ? home : login).
- **FR4** go_router `errorBuilder` wired → NotFoundScreen (currently absent).
- **FR5** `/access-denied` re-pointed from PlaceholderScreen → AccessDeniedScreen.
- **FR6** All UI strings localized (VN default + EN + JA) via ARB.
- **FR7** No layout overflow on smallest target iPhone width.

## Non-functional
- Clean Architecture: presentation-only feature `lib/features/system/presentation/`. No domain/data layer.
- Files < 200 lines. snake_case filenames.
- Content/illustration are mock from Figma design (no invented data).

## Deferred (out of scope)
- **Permission gating that produces a real 403.** No code path today pushes `/access-denied`
  (redirect only sends unauth → login). AccessDenied is made *reachable as a route* for
  future role/permission checks. When a permission system lands, redirect/guard logic pushes
  `/access-denied`; that wiring is a future feature, not F008.
- Animations, retry/diagnostic actions, error reporting/telemetry.
- Deep-link recovery, "report this problem" flows.
