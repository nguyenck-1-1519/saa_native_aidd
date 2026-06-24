# Permissions Matrix — SAA 2025 Flutter App

> Rows = routes. Columns = auth states. Source: `app_router.dart` redirect logic.
> "Allow" = route renders. "Redirect" = go_router redirect fires before render.

---

| Route | Screen | Unauthenticated | Authenticated |
|-------|--------|-----------------|---------------|
| `/` | Splash (SCR001) | Allow (transient) → redirect to `/login` once resolved | Allow (transient) → redirect to `/home` once resolved |
| `/login` | Login (SCR002) | Allow | Redirect → `/home` |
| `/home` | Home (SCR003) | Redirect → `/login` | Allow |
| `/awards` | Awards tab (SCR004) | Redirect → `/login` | Allow |
| `/kudos` | Kudos tab (SCR005) | Redirect → `/login` | Allow |
| `/profile` | Profile tab (SCR006) | Redirect → `/login` | Allow |
| `/search` | Search (SCR007) | Redirect → `/login` | Allow |
| `/notifications` | Notifications (SCR008) | Redirect → `/login` | Allow |
| `/award-detail` | Award Detail (SCR009) | Redirect → `/login` | Allow |
| `/about-award` | About Award (SCR010) | Redirect → `/login` | Allow |
| `/about-kudos` | About Kudos (SCR011) | Redirect → `/login` | Allow |
| `/kudos-detail` | Kudos Detail (SCR012) | Redirect → `/login` | Allow |
| `/kudos-feed` | Kudos Feed (SCR013) | Redirect → `/login` | Allow |
| `/write-kudo` | Write Kudo (SCR014) | Redirect → `/login` | Allow |
| `/access-denied` | Access Denied (SCR015) | Allow* | Allow* |

\* `/access-denied` has no session check at the router level. It is navigated to explicitly
by the auth error-mapping layer when a 403-equivalent condition is encountered. See PERM003
in `docs/system/permissions.md`.

---

## Auth State Definitions

| State | Meaning |
|-------|---------|
| **Loading** | `authStateProvider` is resolving; router holds on splash (no redirect loop) |
| **Unauthenticated** | `authStateProvider` emits `null` (no session) |
| **Authenticated** | `authStateProvider` emits a non-null `AuthUser` |
| **Stream error** | `authStateProvider` emits an error; treated as unauthenticated → `/login` |

---

## Notes

- The redirect is re-evaluated on every `authStateProvider` emission (via `ValueNotifier` refresh wired into `routerProvider`).
- The 4 shell-route branches (`/home`, `/awards`, `/kudos`, `/profile`) share the same redirect logic; there is no per-tab access differentiation.
- No route requires elevated privilege beyond a valid session (no role-based gates).
