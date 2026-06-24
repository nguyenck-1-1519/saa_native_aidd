# Screen List — SAA 2025 Flutter App

Generated from source. Ground truth: `lib/core/router/app_router.dart`, `lib/features/`.

---

## ID Schema

- **SCR###** — full screen (distinct route)
- **REG###** — independent region within a composite screen (own state, scroll, or auth concern)
- **F001** — Login feature (`features/auth`)
- **F002** — Home feature (`features/home`)
- **F003** — Awards feature (`features/awards`)

---

## Screens

### SCR001 — Splash

| Field | Value |
|---|---|
| Route | `/` |
| Class | `_SplashScreen` (inline in `app_router.dart`) |
| Feature | F001 (auth gate) |
| Shell | No |
| Status | Implemented |

**Purpose:** Auth-state loading gate. Displays a centered `CircularProgressIndicator` while `authStateProvider` resolves the initial Supabase session. Router redirect holds all navigation here until the stream emits; no loop guard needed because the redirect explicitly returns `null` when already on splash.

**Auth guard behavior:** Any auth-loading state → stays on splash. No back-navigation possible (initial route).

---

### SCR002 — Login

| Field | Value |
|---|---|
| Route | `/login` |
| Class | `LoginScreen` — `lib/features/auth/presentation/screens/login_screen.dart` |
| Feature | F001 |
| Shell | No |
| Status | Implemented |

**Regions (not independent enough for REG ids — single scroll, single state):**
- Logo + `LanguageSelector` header row
- "ROOT FURTHER" brand mark + localized description body
- `GoogleLoginButton` CTA
- Localized copyright footer

**Key behaviors:**
- `loginControllerProvider` AsyncNotifier listens; on `AsyncError` → localized snackbar (`NetworkFailure` / `AccountDisabled` / generic)
- `AuthCancelled` is silently ignored (no snackbar shown — falls through `_` default which emits `authErrorGeneric`; cancel is a deliberate user action — see BL007)
- `LanguageSelector` changes locale immediately and persists via `LocaleController`
- Redirected to `/home` automatically once `authStateProvider` emits a non-null user

---

### SCR003 — Home

| Field | Value |
|---|---|
| Route | `/home` |
| Class | `HomeScreen` — `lib/features/home/presentation/home_screen.dart` |
| Feature | F002 |
| Shell | Yes — branch 0 of `StatefulShellRoute` (`_ShellScaffold`) |
| Status | Implemented |

**Composite screen.** Rendered inside the 4-tab shell which supplies bottom navigation (`HomeBottomNavBar`). Body is a `CustomScrollView` with a pinned `SliverPersistentHeader` (header) + `SliverToBoxAdapter` sections (hero, awards, kudos). FAB is hoisted to `Scaffold.floatingActionButton`.

#### Regions

| ID | Name | Widget | State | Source |
|---|---|---|---|---|
| REG001 | Header | `HomeHeader` | `unreadCountProvider` (StreamProvider) | `widgets/home_header.dart` |
| REG002 | Hero + Countdown | `HeroCountdown` | `countdownControllerProvider` (Notifier, 1 s tick) | `widgets/hero_countdown.dart` |
| REG003 | Awards Carousel | `AwardsCarousel` | `awardsControllerProvider` (AsyncNotifier) | `widgets/awards_carousel.dart` |
| REG004 | Kudos Section | `KudosSection` | `kudosAvailableProvider` (feature flag, bool) | `widgets/kudos_section.dart` |
| REG005 | FAB | `HomeFab` | `_fabBusy` (local bool — double-tap guard) | `home_screen.dart:_fabBusy` |
| REG006 | Bottom Nav | `HomeBottomNavBar` | `navigationShell.currentIndex` (shell state) | `widgets/home_bottom_nav_bar.dart` |

Note: `ThemeDescription` (`widgets/theme_description.dart`) is a static presentational block between REG002 and REG003; no independent state — not assigned a REG id.

---

## Placeholder Screens

All backed by `PlaceholderScreen` (`lib/features/placeholder/presentation/placeholder_screen.dart`) — renders "Chưa triển khai" + title. No logic, no state.

### Shell tabs (inside `StatefulShellRoute` — bottom nav visible)

| ID | Title | Route | Feature | Status |
|---|---|---|---|---|
| SCR004 | Awards | `/awards` | F003 | Implemented |
| SCR005 | Kudos Tab | `/kudos` | F002 | Placeholder |
| SCR006 | Profile Tab | `/profile` | F002 | Placeholder |

**SCR004 — Awards** (`AwardsScreen`, `lib/features/awards/presentation/screens/awards_screen.dart`):
Dropdown over 5 awards (Top Talent, Top Project Leader, Best Manager, Signature 2025-Creator, MVP).
Selecting an award loads its full detail view. States: loading / error+retry / content.
Reuses `HomeHeader` + `KudosSection` widgets. Pre-selectable from Home via `selectedAwardIdProvider`.
5 l10n keys added (VN/EN/JA).

### Standalone (outside shell — no bottom nav)

| ID | Title | Route | Navigated from | Feature | Status |
|---|---|---|---|---|---|
| SCR007 | Search | `/search` | REG001 header search icon | F002 | Placeholder |
| SCR008 | Notifications | `/notifications` | REG001 header bell icon | F002 | Placeholder |
| SCR009 | About Kudos | `/about-kudos` | REG002 hero CTA | F002 | Placeholder |
| SCR010 | Kudos Detail | `/kudos-detail` | REG004 kudos section "Chi tiết" | F002 | Placeholder |
| SCR011 | Kudos Feed | `/kudos-feed` | REG005 FAB kudos action | F002 | Placeholder |
| SCR012 | Write Kudo | `/write-kudo` | REG005 FAB pencil action | F002 | Placeholder |
| SCR013 | Access Denied | `/access-denied` | Router redirect (403 case) | F001/F002 | Placeholder |

> **Retired (F003):** SCR009-old "Award Detail" (`/award-detail`) and SCR010-old "About Award" (`/about-award`) placeholders removed. Their navigation entry points now deep-link to SCR004 (Awards tab).

---

## Summary Table

| ID | Name | Route | Feature | Shell | Implemented |
|---|---|---|---|---|---|
| SCR001 | Splash | `/` | F001 | No | Yes |
| SCR002 | Login | `/login` | F001 | No | Yes |
| SCR003 | Home | `/home` | F002 | Yes | Yes |
| SCR004 | Awards | `/awards` | F003 | Yes | Yes |
| SCR005 | Kudos Tab | `/kudos` | F002 | Yes | Placeholder |
| SCR006 | Profile Tab | `/profile` | F002 | Yes | Placeholder |
| SCR007 | Search | `/search` | F002 | No | Placeholder |
| SCR008 | Notifications | `/notifications` | F002 | No | Placeholder |
| SCR009 | About Kudos | `/about-kudos` | F002 | No | Placeholder |
| SCR010 | Kudos Detail | `/kudos-detail` | F002 | No | Placeholder |
| SCR011 | Kudos Feed | `/kudos-feed` | F002 | No | Placeholder |
| SCR012 | Write Kudo | `/write-kudo` | F002 | No | Placeholder |
| SCR013 | Access Denied | `/access-denied` | F001/F002 | No | Placeholder |
