# Phase 03 — Routing wiring + i18n (Track B / Integration)

**Track:** B (logic) — this IS the integration. **Status:** pending.
**Depends on:** Phase 01, Phase 02 (consumes both widgets).
**File ownership:** `lib/core/router/app_router.dart`, `lib/core/l10n/app_vi.arb`,
`lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ja.arb`.

## Context links
- Router: `lib/core/router/app_router.dart` (Routes.accessDenied @43; placeholder wiring @197-201; no errorBuilder yet)
- Auth state: `lib/features/auth/presentation/providers/auth_providers.dart` (`authStateProvider`)
- Spec: `plans/260626-1536-f008-system-screens/spec/system-screens/spec.md`

## Overview
Priority P2. Wire both error screens into go_router and add localized strings.

## Requirements
- **FR4** Add `errorBuilder: (context, state) => NotFoundScreen(...)` to the `GoRouter`.
- **FR5** Replace `PlaceholderScreen(title: 'Access Denied')` at `Routes.accessDenied` with `AccessDeniedScreen(...)`.
- **FR3** CTA target = auth-aware. Read `authStateProvider` inside the builder/wrapper:
  loggedIn → `context.go(Routes.home)` + label "Về trang chủ"; else → `context.go(Routes.login)` + label "Về đăng nhập".
- **FR6** Add ARB keys to all three locales: `accessDeniedTitle/Message/Cta*`, `notFoundTitle/Message/Cta*` (CTA labels resolve from auth: `errorGoHome`, `errorGoLogin`). Run `fvm flutter gen-l10n`.

## Architecture / data flow
```
unknown route ─→ GoRouter.errorBuilder ─→ NotFoundScreen(label, onAction)
/access-denied ─→ GoRoute.builder ─→ AccessDeniedScreen(label, onAction)
   onAction/label ← read(authStateProvider).valueOrNull != null ? home : login
```
A small builder closure (or tiny route wrapper, mirroring `kudos_route_wrappers.dart`) reads
auth via `ref` and supplies `primaryLabel` + `onPrimaryAction` to the pure widgets from 01/02.

## Implementation steps
1. Import `system/presentation/access_denied_screen.dart` + `not_found_screen.dart`.
2. Add `errorBuilder` to `GoRouter(...)` returning NotFoundScreen wired to auth-aware CTA.
3. Swap `Routes.accessDenied` builder (line ~197) PlaceholderScreen → AccessDeniedScreen wired same way.
4. Add ARB keys (vi/en/ja) + `@`-descriptions; `fvm flutter gen-l10n`.
5. `fvm flutter analyze`.

## Todo
- [ ] errorBuilder → NotFoundScreen
- [ ] /access-denied → AccessDeniedScreen
- [ ] auth-aware CTA target+label for both
- [ ] ARB keys vi/en/ja + gen-l10n
- [ ] analyze clean

## Success criteria
- Unknown path renders NotFoundScreen; `/access-denied` renders AccessDeniedScreen.
- CTA goes home (logged-in) / login (logged-out). `analyze` clean.

## Risk assessment
| Risk | Likelihood | Impact | Countermove |
|------|-----------|--------|-------------|
| `redirect` intercepts `/access-denied` for unauth user → bounced to /login before screen shows | Med | High | Verify: unauth on `/access-denied` currently redirects to `/login` (redirect @89). Decide reachability — for F008 the route is "future-gated"; add an allow-list exception only if a logged-in 403 demo path is needed. Document actual behavior in tests. |
| ARB key missing in one locale → build/runtime gap | Med | Med | Add key to all 3 ARB simultaneously; gen-l10n fails loudly on mismatch. |
| errorBuilder signature drift across go_router versions | Low | Med | Match installed go_router API (pubspec); analyze catches it. |

## Security
- No tokens/PII rendered on error screens. CTA only navigates; no data exposure.

## Next steps
Phase 04 (tests). Note the 403-source deferral (see spec "Deferred").
