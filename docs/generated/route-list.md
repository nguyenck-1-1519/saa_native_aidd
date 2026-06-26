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
| 4 | `/notifications` | `Routes.notifications` | `NotificationsRouteWrapper` → `NotificationsScreen` | Yes (indirect) | F007 — notifications list; mark-read/mark-all; deep-links to kudos detail, awards tab, or secret-box. Push navigation (outside shell). |
| 5 | `/write-kudo` | `Routes.writeKudo` | `WriteKudoScreen` | Yes (indirect) | F004 — full-screen New Kudo form; recipient/title/message/hashtag/image/anonymous; local validation; stub submit. Push navigation (outside shell). |
| 6 | `/access-denied` | `Routes.accessDenied` | `AccessDeniedRouteWrapper` → `AccessDeniedScreen` | No (error destination) | F008 — 403 Access Denied. Shown when `AccountDisabled` failure occurs. Auth-aware CTA: logged-in→Home, logged-out→Login. |
| 7 | `/kudos/all` | `Routes.allKudos` | `AllKudosRouteWrapper` → `AllKudosScreen` | Yes (indirect) | F004 — all kudos list with functional hashtag + department filters (local stub). Entry: KudosScreen "View all Kudos". Push navigation (outside shell). |
| 8 | `/kudos/detail/:id` | `Routes.kudoDetail` (helper: `Routes.kudoDetailPath(id)`) | `ViewKudoScreen` | Yes (indirect) | F004 — kudo detail; anonymous variant hides sender. Entry: feed card "Xem chi tiết". Push navigation (outside shell). |
| 9 | `/kudos/community-standards` | `Routes.communityStandards` | `CommunityStandardsScreen` | Yes (indirect) | F004 — static community standards content. Entry: WriteKudo "Tiêu chuẩn cộng đồng" link. Push navigation (outside shell). |
| 10 | `/kudos/rules` | `Routes.kudosRules` | `KudosRulesScreen` | Yes (indirect) | F004 — Thể lệ static content. Push navigation (outside shell). |
| 11 | `/secret-box` | `Routes.secretBox` | `SecretBoxRouteWrapper` → `SecretBoxScreen` | Yes (indirect) | F005 — full-screen Secret Box reveal flow (closed→opening→revealed); entry: KudosScreen "Mở Secret Box". Push navigation (outside shell). |
| — | *(any unknown path)* | *(errorBuilder)* | `NotFoundRouteWrapper` → `NotFoundScreen` | No (error destination) | F008 — 404 Not Found. Fires for any unrecognised route via `GoRouter.errorBuilder`. Auth-aware CTA: logged-in→Home, logged-out→Login. |

> **Retired (F003):** `/award-detail` (`Routes.awardDetail`) and `/about-award` (`Routes.aboutAward`) removed. Home carousel "Chi tiết" and hero "ABOUT AWARD" now navigate via `goBranch(1)` to `/awards` with `selectedAwardIdProvider` pre-set.

> **Retired (F004):** `/about-kudos` (`Routes.aboutKudos`), `/kudos-detail` (`Routes.kudosDetail`), `/kudos-feed` (`Routes.kudosFeed`) removed. All entry points (Home FAB S/Kudos, Home/Awards "ABOUT KUDOS", Home Kudos section "Chi tiết") now navigate via `goBranch(2)` (kKudosBranchIndex=2) to `/kudos`.

> "Auth-guarded (indirect)" — the redirect guard sends any unauthenticated user to `/login` for all paths except `/login` and `/access-denied`. There is no per-route `redirect` annotation; the global guard covers all.

---

## Shell Routes (inside `StatefulShellRoute.indexedStack` — bottom navigation bar present)

Shell scaffold: `_ShellScaffold` wraps branches with `HomeBottomNavBar` (4 tabs, gold active indicator).
Per-tab state is preserved via `indexedStack`.

| Branch | Path | Constant | Screen Widget | Auth-guarded | Purpose |
|---|---|---|---|---|---|
| 0 | `/home` | `Routes.home` | `HomeScreen` | Yes (indirect) | Main home: hero countdown, awards carousel, kudos section, FAB, notification badge. |
| 1 | `/awards` | `Routes.awards` | `AwardsScreen` | Yes (indirect) | F003 Awards tab — dropdown over 5 awards; loading/error/retry; pre-selectable via Home deep-link. |
| 2 | `/kudos` | `Routes.kudos` | `KudosScreen` | Yes (indirect) | F004 — Kudos tab: KV banner, send-kudos prompt, highlight carousel, spotlight board, stats + Mở Secret Box, recent recipients, feed cards, view-all. |
| 3 | `/profile` | `Routes.profile` | `PlaceholderScreen("Profile")` | Yes (indirect) | Placeholder — user profile tab not yet built. |

---

## Notes

- All placeholder routes use `PlaceholderScreen` (displays "Chưa triển khai"). The route paths are explicit and stable — swapping to a real screen requires only changing the `builder`, not the call sites.
- One parameterized route exists: `/kudos/detail/:id`. Build the full path via `Routes.kudoDetailPath(id)` helper.
- The `GoRouter` has no named routes — navigation uses path strings from the `Routes` constants class.
- Award pre-selection from Home uses `selectedAwardIdProvider` (Riverpod `StateProvider`) rather than a route parameter — no URL change needed for deep-link behavior within the shell.
