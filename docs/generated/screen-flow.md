# Screen Flow — SAA 2025 Flutter App

Generated from source. Ground truth: `lib/core/router/app_router.dart`, `lib/features/home/presentation/home_screen.dart`.

---

## Flow Diagram

```mermaid
flowchart TD
    BOOT([App Boot]) --> SCR001[SCR001 Splash\n/ — auth loading gate]

    SCR001 -->|authState loading| SCR001
    SCR001 -->|authState error| SCR002[SCR002 Login\n/login]
    SCR001 -->|authState: user null| SCR002
    SCR001 -->|authState: user non-null\nauto-login / session restore| SCR003[SCR003 Home\n/home]

    SCR002 -->|Google sign-in success| SCR003
    SCR002 -->|language tap| SCR002

    SCR003 -->|header search icon| SCR007[SCR007 Search\n/search — placeholder]
    SCR003 -->|header bell icon| SCR008[SCR008 Notifications\n/notifications — placeholder]
    SCR003 -->|hero About Award CTA| SCR010[SCR010 About Award\n/about-award — placeholder]
    SCR003 -->|hero About Kudos CTA| SCR011[SCR011 About Kudos\n/about-kudos — placeholder]
    SCR003 -->|awards carousel card tap| SCR009[SCR009 Award Detail\n/award-detail — placeholder]
    SCR003 -->|kudos section Chi tiết| SCR012[SCR012 Kudos Detail\n/kudos-detail — placeholder]
    SCR003 -->|FAB pencil action| SCR014[SCR014 Write Kudo\n/write-kudo — placeholder]
    SCR003 -->|FAB kudos action| SCR013[SCR013 Kudos Feed\n/kudos-feed — placeholder]

    SCR003 -->|bottom nav tab 1| SCR004[SCR004 Awards Tab\n/awards — placeholder]
    SCR003 -->|bottom nav tab 2| SCR005[SCR005 Kudos Tab\n/kudos — placeholder]
    SCR003 -->|bottom nav tab 3| SCR006[SCR006 Profile Tab\n/profile — placeholder]

    SCR004 -->|bottom nav tab 0| SCR003
    SCR005 -->|bottom nav tab 0| SCR003
    SCR006 -->|bottom nav tab 0| SCR003

    ROUTER_403([Router: 403 / auth error]) --> SCR015[SCR015 Access Denied\n/access-denied — placeholder]

    SCR_ANY([Any non-login route]) -->|authState: user null| SCR002
```

---

## Navigation Rules (from `app_router.dart` redirect)

| Condition | Current location | Redirect to |
|---|---|---|
| `authState.isLoading` | not `/` | `/` (splash) |
| `authState.isLoading` | `/` | stay (no loop) |
| `authState.hasError` | not `/login` | `/login` |
| `authState.value != null` (logged in) | `/` or `/login` | `/home` |
| `authState.value == null` (not logged in) | any non-login | `/login` |

Router is driven by `ValueNotifier` refreshed on every `authStateProvider` change — all redirects are reactive, not imperative.

---

## Navigation Method per Transition

| From | To | Method | Notes |
|---|---|---|---|
| SCR003 header | SCR007, SCR008 | `context.push(route)` | Back-stack preserved |
| SCR003 hero CTAs | SCR010, SCR011 | `context.push(route)` | Back-stack preserved |
| SCR003 awards card | SCR009 | `context.push(Routes.awardDetail)` | Single detail route (no id param yet) |
| SCR003 kudos CTA | SCR012 | `context.push(route)` | Via `KudosSection.onDetail` callback |
| SCR003 FAB pencil | SCR014 | `_guardedPush(Routes.writeKudo)` | Double-tap guard (`_fabBusy`) |
| SCR003 FAB kudos | SCR013 | `_guardedPush(Routes.kudosFeed)` | Double-tap guard (`_fabBusy`) |
| Shell bottom nav | SCR003–006 | `navigationShell.goBranch(index)` | `StatefulShellRoute` — per-tab state kept |
| Auto-redirect | SCR002→SCR003 | GoRouter redirect | Triggered by `authStateProvider` stream |
| Auto-redirect | SCR003→SCR002 | GoRouter redirect | Triggered by `authStateProvider` null |

---

## Notes

- All standalone placeholder destinations (SCR007–SCR015) sit **outside** the `StatefulShellRoute` — no bottom nav bar rendered.
- Shell tabs (SCR004–SCR006) are inside the shell — `HomeBottomNavBar` always visible.
- `_guardedPush` in `HomeScreen._HomeScreenState` sets `_fabBusy = true` before `await context.push(...)` and resets it when the pushed route pops — prevents duplicate pushes from rapid double-taps.
- No deep-link handling is implemented; all routes use flat path strings from `Routes` constants.
- Award Detail (`/award-detail`) carries no path parameters yet — the card's `id` is not threaded through.
