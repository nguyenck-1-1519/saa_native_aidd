# SAA 2025 — Route List

Source of truth: `lib/core/router/app_router.dart` · Route constants: `abstract final class Routes`

Auth redirect guard fires on every navigation event (driven by `authStateProvider` via `refreshListenable`). See `docs/system/architecture.md` → Auth Redirect Guard for the full redirect table.

---

## Standalone Routes (outside shell — no bottom navigation bar)

| # | Path | Constant | Screen Widget | Auth-guarded | Purpose |
|---|---|---|---|---|---|
| 1 | `/` | `Routes.splash` | `_SplashScreen` | No | Loading spinner shown while `authStateProvider` resolves initial session. Redirect clears this immediately once auth state is known. |
| 2 | `/login` | `Routes.login` | `LoginScreen` | No (auth exit point) | Google sign-in, language selector. Authenticated users are redirected away to `/home`. |
| 3 | `/search` | `Routes.search` | `PlaceholderScreen("Search")` | Yes (indirect) | Placeholder — feature not yet built. |
| 4 | `/notifications` | `Routes.notifications` | `PlaceholderScreen("Notifications")` | Yes (indirect) | Placeholder — feature not yet built. |
| 5 | `/about-kudos` | `Routes.aboutKudos` | `PlaceholderScreen("About Kudos")` | Yes (indirect) | Placeholder — informational kudos page not yet built. |
| 6 | `/kudos-detail` | `Routes.kudosDetail` | `PlaceholderScreen("Kudos Detail")` | Yes (indirect) | Placeholder — kudos detail screen not yet built. |
| 7 | `/kudos-feed` | `Routes.kudosFeed` | `PlaceholderScreen("Kudos Feed")` | Yes (indirect) | Placeholder — kudos feed screen not yet built. |
| 8 | `/write-kudo` | `Routes.writeKudo` | `PlaceholderScreen("Write Kudo")` | Yes (indirect) | Placeholder — write kudo screen not yet built. |
| 9 | `/access-denied` | `Routes.accessDenied` | `PlaceholderScreen("Access Denied")` | No (error destination) | Shown when `AccountDisabled` failure occurs (Supabase 400/403). |

> **Retired (F003):** `/award-detail` (`Routes.awardDetail`) and `/about-award` (`Routes.aboutAward`) removed. Home carousel "Chi tiết" and hero "ABOUT AWARD" now navigate via `goBranch(1)` to `/awards` with `selectedAwardIdProvider` pre-set.

> "Auth-guarded (indirect)" — the redirect guard sends any unauthenticated user to `/login` for all paths except `/login` and `/access-denied`. There is no per-route `redirect` annotation; the global guard covers all.

---

## Shell Routes (inside `StatefulShellRoute.indexedStack` — bottom navigation bar present)

Shell scaffold: `_ShellScaffold` wraps branches with `HomeBottomNavBar` (4 tabs, gold active indicator).
Per-tab state is preserved via `indexedStack`.

| Branch | Path | Constant | Screen Widget | Auth-guarded | Purpose |
|---|---|---|---|---|---|
| 0 | `/home` | `Routes.home` | `HomeScreen` | Yes (indirect) | Main home: hero countdown, awards carousel, kudos section, FAB, notification badge. |
| 1 | `/awards` | `Routes.awards` | `AwardsScreen` | Yes (indirect) | F003 Awards tab — dropdown over 5 awards; loading/error/retry; pre-selectable via Home deep-link. |
| 2 | `/kudos` | `Routes.kudos` | `PlaceholderScreen("Kudos")` | Yes (indirect) | Placeholder — kudos tab not yet built. |
| 3 | `/profile` | `Routes.profile` | `PlaceholderScreen("Profile")` | Yes (indirect) | Placeholder — user profile tab not yet built. |

---

## Notes

- All placeholder routes use `PlaceholderScreen` (displays "Chưa triển khai"). The route paths are explicit and stable — swapping to a real screen requires only changing the `builder`, not the call sites.
- No dynamic/parameterized routes exist (no `:id` segments). `kudos-detail`, etc. are path-only stubs awaiting parameter design.
- The `GoRouter` has no named routes — navigation uses path strings from the `Routes` constants class.
- Award pre-selection from Home uses `selectedAwardIdProvider` (Riverpod `StateProvider`) rather than a route parameter — no URL change needed for deep-link behavior within the shell.
