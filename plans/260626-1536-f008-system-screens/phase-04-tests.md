# Phase 04 — Tests

**Status:** done · **Depends on:** Phase 03.
**File ownership:** `test/features/system/presentation/*`, `test/core/router/*` (create).
Tester owns test files only — never edits implementation.

**Delivered:** 2026-06-26. 35 tests green (11 AccessDenied + 12 NotFound + 12 wrapper integration). 306 total tests passing (includes 271 regressions). Router nav + CTA flow + i18n + layout all validated. analyze clean.

## Context links
- Spec: `plans/260626-1536-f008-system-screens/spec/system-screens/spec.md`
- Router: `lib/core/router/app_router.dart`

## Test matrix
| Test | Level | Asserts |
|------|-------|---------|
| Unknown route → NotFoundScreen | integration (router) | pump app/router, push bogus path, expect `NotFoundScreen` |
| `/access-denied` → AccessDeniedScreen | integration (router) | navigate, expect `AccessDeniedScreen` |
| AccessDenied CTA (logged-in) → home | widget | override auth = user, tap CTA, expect `Routes.home` location |
| AccessDenied CTA (logged-out) → login | widget | override auth = null, tap CTA, expect `Routes.login` location |
| NotFound CTA navigates | widget | tap CTA → expected target per auth |
| No overflow @320pt | widget | both screens at 320pt width, no overflow exceptions |
| i18n all keys resolve | unit/widget | pump each screen under vi/en/ja, no missing-key fallback |

## Test approach
- Inject `FakeAuthRepository` via `ProviderScope(overrides: [...])` (per code-standards §8).
- All tests pass offline — no Supabase/Google ID.
- Reuse existing router test harness pattern if present; else build minimal `MaterialApp.router`.

## Todo
- [ ] router: unknown route renders NotFound
- [ ] router: /access-denied renders AccessDenied
- [ ] CTA nav both screens × {logged-in, logged-out}
- [ ] overflow @320pt both screens
- [ ] i18n vi/en/ja resolve
- [ ] `fvm flutter test` green + `fvm flutter analyze` clean

## Success criteria
All matrix rows pass. `fvm flutter test` green, `fvm flutter analyze` clean.

## Risk assessment
| Risk | Likelihood | Impact | Countermove |
|------|-----------|--------|-------------|
| redirect bounces `/access-denied` test before screen mounts | Med | Med | Test the *actual* redirect behavior; if unauth bounces to login, assert that and gate the "renders AccessDenied" test to logged-in (or future allow-list per Phase 03). |
| go_router test navigation timing flakiness | Low | Med | `pumpAndSettle` after navigation; assert on `GoRouterState`/location. |
