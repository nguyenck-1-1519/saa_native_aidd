# Behavior Logic — SAA 2025 Flutter App

Generated from source. Each BL is one distinct, named behavior. Source citations use `file:symbol` form relative to `lib/`.

---

## ID Schema

- **BL001–BL006** — Auth behaviors (F001)
- **BL007–BL013** — Home behaviors (F002)

---

## F001 — Auth

### BL001 — Google Sign-In with Supabase Token Exchange

| Field | Value |
|---|---|
| ID | BL001 |
| Trigger | User taps `GoogleLoginButton`; `LoginController.signInWithGoogle()` called |
| Feature | F001 |
| Source | `features/auth/data/repositories/auth_repository_impl.dart:signInWithGoogle` |

**Logic:**
1. `GoogleSignInDataSource.signIn()` — native Google OAuth flow; returns `{idToken, accessToken}`.
2. `SupabaseAuthDataSource.signInWithIdToken(idToken, accessToken)` — exchanges for a Supabase session; returns `AuthUser`.
3. Error mapping (catch chain):
   - `Failure` already domain type → rethrow (covers `AuthCancelled` thrown upstream by `GoogleSignInDataSource`)
   - `SocketException` → `NetworkFailure(message)`
   - `AuthApiException` with status 400 or 403 → `AccountDisabled(message)`
   - `AuthApiException` other status → `UnknownFailure(message)`
   - `AuthException` → `UnknownFailure(message)`
   - any other → `UnknownFailure(toString())`
4. On success: `authStateProvider` stream emits non-null user → GoRouter redirect fires → navigate to `/home`.

**Fallback:** When `!SupabaseInit.isInitialized || !Env.hasGoogleConfig`, `authRepositoryProvider` returns `FakeAuthRepository` — sign-in always succeeds with a stub user (demo/credential-free mode).

---

### BL002 — Auth Error Display (Login Screen)

| Field | Value |
|---|---|
| ID | BL002 |
| Trigger | `loginControllerProvider` emits `AsyncError` |
| Feature | F001 |
| Source | `features/auth/presentation/screens/login_screen.dart:_failureMessage` |

**Logic:**
- `ref.listen` on `loginControllerProvider`; fires only on `AsyncError`.
- `_failureMessage` maps error type via `switch`:
  - `NetworkFailure` → `l10n.authErrorNetwork`
  - `AccountDisabled` → `l10n.authErrorAccountDisabled`
  - anything else (including `AuthCancelled`) → `l10n.authErrorGeneric`
- Shows localized snackbar via `ScaffoldMessenger`; hides any current snackbar first.

Note: `AuthCancelled` falls through to `authErrorGeneric`. This is a known gap — cancel silently shows a generic error rather than no error. Tracked but not fixed (intentional per current spec).

---

### BL003 — Sign-Out (Isolated Google + Supabase)

| Field | Value |
|---|---|
| ID | BL003 |
| Trigger | Sign-out action (no UI trigger in current build — available via `SignOut` usecase) |
| Feature | F001 |
| Source | `features/auth/data/repositories/auth_repository_impl.dart:signOut` |

**Logic:**
1. `_google.signOut()` wrapped in `try/catch` — failure swallowed. Google local state is best-effort.
2. `_supabase.signOut()` — always called, even if Google sign-out threw. Supabase session is authoritative.
3. `authStateProvider` stream emits `null` → GoRouter redirect fires → navigate to `/login`.

---

### BL004 — Watch Auth State / Auto-Login (Session Restore)

| Field | Value |
|---|---|
| ID | BL004 |
| Trigger | App boot; `authStateProvider` subscribed by GoRouter via `ValueNotifier` refresh |
| Feature | F001 |
| Source | `features/auth/presentation/providers/auth_providers.dart:authStateProvider` |

**Logic:**
- `authStateProvider` is a `StreamProvider<AuthUser?>` wrapping `WatchAuthState.call()` → `SupabaseAuthDataSource.watchAuthState()`.
- On boot, Supabase session is restored from `SecureSessionStorage` (Keychain / EncryptedSharedPreferences). If valid, stream emits non-null user immediately → splash skips login and goes to home.
- Router `refreshListenable` increments on every emission → redirect re-evaluated.
- States: `isLoading` (stream not yet emitted) → splash; `hasError` → login; `value != null` → home; `value == null` → login.

---

### BL005 — Login Double-Click Guard

| Field | Value |
|---|---|
| ID | BL005 |
| Trigger | Rapid second tap on `GoogleLoginButton` while first sign-in is in flight |
| Feature | F001 |
| Source | `features/auth/presentation/providers/auth_providers.dart:LoginController.signInWithGoogle` |

**Logic:**
```
if (state.isLoading) return;   // FUN_008 — early exit, no-op
state = AsyncLoading();
state = await AsyncValue.guard(() => signInWithGoogle.call());
```
`AsyncNotifier.state` is `AsyncLoading` for the duration of the sign-in request. Any re-entrant call before resolution is dropped silently.

---

### BL006 — Locale Set + Persist + Re-render

| Field | Value |
|---|---|
| ID | BL006 |
| Trigger | User selects language in `LanguageSelector` (available on both SCR002 Login and SCR003 Home header) |
| Feature | F001 |
| Source | `core/l10n/locale_controller.dart:LocaleController.setLocale` |

**Logic:**
1. Guard: if `locale` not in `kSupportedLocales` (`vi`, `en`, `ja`) or equals current → return (no-op).
2. `state = locale` → `StateNotifier` notifies listeners → `MaterialApp.locale` rebuilds with new locale.
3. `SharedPreferences.setString('locale', locale.languageCode)` — persisted across cold starts.
4. On next boot: `_load()` reads the stored code and restores it if still supported.
5. Default locale is `vi`; used before any user choice and as the fallback if stored code is removed/unsupported.

---

## F002 — Home

### BL007 — Countdown Compute (Elapsed Clamp)

| Field | Value |
|---|---|
| ID | BL007 |
| Trigger | Called by `CountdownController.build()` on first render, then on every 1 s tick |
| Feature | F002 |
| Source | `features/home/domain/usecases/compute_countdown.dart:ComputeCountdown.call` |

**Logic:**
```
diff = target.difference(now)          // target = 2025-12-26
if diff.isNegative || diff == zero:
    return CountdownState.elapsed      // days=0, hours=0, minutes=0, isElapsed=true
days    = diff.inDays
hours   = (diff.inMinutes ~/ 60) % 24
minutes = diff.inMinutes % 60
return CountdownState(days, hours, minutes, isElapsed: false)
```
Negatives never reach the UI — clamped to elapsed state. Seconds excluded by design (UI shows D/H/M only).

---

### BL008 — Countdown Tick (1 s Timer)

| Field | Value |
|---|---|
| ID | BL008 |
| Trigger | `CountdownController.build()` — fires if `!initial.isElapsed`; ticks every 1 s |
| Feature | F002 |
| Source | `features/home/presentation/providers/countdown_controller.dart:CountdownController.build` |

**Logic:**
1. Compute initial state via `BL007`.
2. If already elapsed: skip timer creation.
3. `Timer.periodic(1 second)`: call `BL007` with fresh `DateTime.now()`; set `state = next`.
4. If `next.isElapsed`: cancel and null the timer — no further ticks.
5. `ref.onDispose`: cancel timer to prevent memory leaks (widget tree disposal).

---

### BL009 — Awards Load + Retry

| Field | Value |
|---|---|
| ID | BL009 |
| Trigger | `AwardsController.build()` on first render; `refresh()` on Retry button tap |
| Feature | F002 |
| Source | `features/home/presentation/providers/home_providers.dart:AwardsController` |

**Logic:**
- `build()`: `ref.watch(getAwardsProvider).call()` — returns `Future<List<AwardCard>>`. Riverpod wraps in `AsyncValue` automatically.
- `refresh()`:
  ```
  state = AsyncLoading()
  state = await AsyncValue.guard(() => getAwards.call())
  ```
- `AwardsCarousel` renders four states: loading skeleton, empty list, error+retry button, data cards.
- Retry tap calls `ref.read(awardsControllerProvider.notifier).refresh()` — re-runs the use case.
- Current impl: `StubAwardsRepository` — configurable via `FakeAwardsRepository` variants (`.data`, `.empty`, `.error`, `.loading`) in tests.

---

### BL010 — FAB Double-Tap Guard

| Field | Value |
|---|---|
| ID | BL010 |
| Trigger | Rapid second tap on `HomeFab` while first navigation push is in flight |
| Feature | F002 |
| Source | `features/home/presentation/home_screen.dart:_HomeScreenState._guardedPush` |

**Logic:**
```dart
Future<void> _guardedPush(String route) async {
  if (_fabBusy) return;                    // FUN_013 — drop duplicate tap
  setState(() => _fabBusy = true);
  await context.push(route);              // suspends until route pops
  if (mounted) setState(() => _fabBusy = false);
}
```
`_fabBusy` is a local `bool` state on `_HomeScreenState`. Both FAB actions (`writeKudo`, `kudosFeed`) go through `_guardedPush`. Guard resets automatically when the pushed screen pops — no manual reset needed.

---

### BL011 — Notification Badge Visibility

| Field | Value |
|---|---|
| ID | BL011 |
| Trigger | `unreadCountProvider` emits a new value; `HomeHeader` rebuilt by `Consumer` in `_HomeHeaderDelegate` |
| Feature | F002 |
| Source | `features/home/presentation/widgets/home_header.dart:_BellButton` |

**Logic:**
- `unreadCountProvider` is a `StreamProvider<int>` wrapping `WatchUnreadCount` → `StubNotificationRepository`.
- `_HomeHeaderDelegate.build` wraps `HomeHeader` in a `Consumer`; reads `unreadCountProvider.valueOrNull ?? 0`.
- `_BellButton`: renders red dot badge (`8×8 px`, `#D4271D`) only when `unreadCount > 0`. Zero or null → no badge.

---

### BL012 — Kudos Feature-Flag Hide

| Field | Value |
|---|---|
| ID | BL012 |
| Trigger | `kudosAvailableProvider` read on `HomeScreen.build` |
| Feature | F002 |
| Source | `features/home/presentation/home_screen.dart` + `features/home/presentation/widgets/kudos_section.dart:KudosSection.build` |

**Logic:**
- `kudosAvailableProvider` is a `Provider<bool>` wrapping `GetKudosAvailability.call()` → `StubKudosConfigRepository.isAvailable`.
- `HomeScreen` passes `visible: kudosVisible` to `KudosSection`.
- `KudosSection.build`: `if (!visible) return SizedBox.shrink()` — widget collapses entirely; no layout space reserved, no CTA rendered.
- Current stub: `StubKudosConfigRepository` returns a hardcoded bool. Real feature-flag source not yet wired.

---

### BL013 — Auth Repository Fallback (Demo Mode)

| Field | Value |
|---|---|
| ID | BL013 |
| Trigger | App boot when `!SupabaseInit.isInitialized || !Env.hasGoogleConfig` |
| Feature | F001/F002 (cross-cutting) |
| Source | `features/auth/presentation/providers/auth_providers.dart:authRepositoryProvider` |

**Logic:**
```dart
if (!SupabaseInit.isInitialized || !Env.hasGoogleConfig) {
  return FakeAuthRepository();   // stub: signIn always succeeds, watchAuthState emits stub user
}
// else: real AuthRepositoryImpl with Google + Supabase datasources
```
Allows the app to boot and demonstrate the full UI flow without real credentials (CI, demos, credential-free dev machines). `FakeAuthRepository` satisfies the `AuthRepository` interface; all BL001–BL005 behaviors run against it unchanged.
