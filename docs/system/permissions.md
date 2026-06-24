# Auth & Permission Model — SAA 2025 Flutter App

> Source: `lib/core/router/app_router.dart`, `lib/core/config/supabase_init.dart`,
> `lib/core/config/secure_session_storage.dart`, `lib/features/auth/presentation/providers/auth_providers.dart`.

---

## Single Authentication Method

The app supports **one auth method only: Google OAuth via Supabase**.

Flow: `google_sign_in` obtains a native idToken → passed to `supabase.signInWithIdToken` →
Supabase issues a session. No email/password, no other OAuth providers.

If Supabase is not initialized (missing config) or Google client IDs are absent/placeholder,
the app falls back to `FakeAuthRepository` automatically — enabling demo and CI runs without
crashing the Google Sign-In native plugin.

---

## Session Storage

The Supabase session token is persisted in the **OS secure enclave** (iOS Keychain) via
`SecureSessionStorage`, which wraps `flutter_secure_storage` with
`KeychainAccessibility.first_unlock`. This replaces Supabase's default unencrypted
SharedPreferences/NSUserDefaults storage.

- Key: `supabase.session`
- Lifecycle: written on sign-in, deleted on sign-out, read on app launch for auto-login.

---

## Route Guard

All route protection is handled by the `go_router` redirect callback in `routerProvider`,
which reads `authStateProvider` (a `StreamProvider<AuthUser?>` backed by Supabase's
`onAuthStateChange` stream).

Redirect logic (applied in order):

1. **Loading** — auth state not yet resolved → redirect to `/` (splash). No redirect loop:
   if already on splash, return null.
2. **Stream error** — auth stream emits an error → redirect to `/login`. If already on
   `/login`, return null.
3. **Logged in + on `/login` or `/`** → redirect to `/home`.
4. **Not logged in + on any route other than `/login`** → redirect to `/login`.
5. **403 (access-denied)** — the `/access-denied` route exists as an explicit destination;
   the guard does not redirect to it automatically but the auth error-mapping layer can
   navigate there when a 403 is encountered.

The router re-evaluates on every `authStateProvider` emission via a `ValueNotifier` refresh.

---

## Role Model

There is **no role-based access control** in the current implementation. The app has a single
user role: authenticated Sunner. Once a valid session exists, all in-app screens are
accessible (subject to placeholder status). No admin, moderator, or guest roles.

---

## Permission IDs

### PERM001 — Authenticated Access
All app screens behind the shell route (`/home`, `/awards`, `/kudos`, `/profile`) and all
standalone destination screens (`/search`, `/notifications`, `/award-detail`, `/about-award`,
`/about-kudos`, `/kudos-detail`, `/kudos-feed`, `/write-kudo`) require a valid Supabase
session. Unauthenticated requests are redirected to `/login` by the route guard.

### PERM002 — Unauthenticated Access
Only two routes are accessible without a session:
- `/` (splash) — transient; redirected once auth state resolves.
- `/login` — the sole public entry point.

An authenticated user landing on either of these is immediately redirected to `/home`.

### PERM003 — Access Denied Route
`/access-denied` is a standalone placeholder reachable when a 403-equivalent condition is
detected. It does not require (or reject) any particular session state at the router level —
access control for this route is handled upstream by the auth error-mapping layer.
