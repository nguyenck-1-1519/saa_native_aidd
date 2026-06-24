# Feature List — SAA 2025 Flutter App

> Source: implemented code (F001 auth, F002 Home, F003 Awards). IDs are stable references — do not renumber.

---

## F001 — Login & Authentication

**Purpose:** Google OAuth sign-in via Supabase; session persistence; i18n; auth guard.

**Module:** `lib/features/auth/`

| Attribute | Value |
|-----------|-------|
| Status | Shipped (iOS) |
| Screens | SCR001 Splash (`/`), SCR002 Login (`/login`) |
| Depends on | — (foundation feature) |

### User Stories Covered
US001, US002, US003, US004, US005, US006, US007, US008, US009, US010, US011

### Screens (SCR###)

| SCR### | Route | Description |
|--------|-------|-------------|
| SCR001 | `/` | Splash — shown while auth state resolves; redirects once known |
| SCR002 | `/login` | Login — Google sign-in button, language selector, error display |

### Sub-features

| # | Sub-feature | Description |
|---|-------------|-------------|
| F001.1 | Google OAuth | google_sign_in idToken → supabase.signInWithIdToken |
| F001.2 | Auto-login | Session restored from Keychain on app launch via watchAuthState stream |
| F001.3 | Sign-out | Clears both google_sign_in and Supabase sessions; isolated error handling |
| F001.4 | Secure session storage | Supabase session token persisted in iOS Keychain (flutter_secure_storage) |
| F001.5 | i18n | flutter gen-l10n; vi/en/ja; default vi; locale persisted in shared_preferences |
| F001.6 | Auth guard | go_router redirect: loading→splash, error→login, loggedIn+on-login/splash→home, not-loggedIn→login |
| F001.7 | Login double-click guard | LoginController.signInWithGoogle returns early if state.isLoading |
| F001.8 | Error mapping | AuthCancelled / NetworkFailure / AccountDisabled / UnknownFailure → localized UI message |

---

## F002 — Home Screen

**Purpose:** SAA 2025 entry point after login: event hero+countdown, awards carousel, Kudos highlight, bottom nav shell, FAB.

**Module:** `lib/features/home/`

| Attribute | Value |
|-----------|-------|
| Status | Shipped (iOS, 2026-06-23) |
| Screens | SCR003 Home (`/home`) + placeholder screens (SCR004–SCR017) |
| Depends on | F001 (router, theme, l10n, auth guard) |

### User Stories Covered
US012, US013, US014, US015, US016, US017, US018, US019, US020, US021, US022, US023, US024, US025, US026, US027, US028, US029, US030, US031

### Screens (SCR###)

| SCR### | Route | Description |
|--------|-------|-------------|
| SCR003 | `/home` | Home — main content screen (shell branch 0) |
| SCR004 | `/awards` | Awards tab — placeholder (shell branch 1) |
| SCR005 | `/kudos` | Kudos tab — placeholder (shell branch 2) |
| SCR006 | `/profile` | Profile tab — placeholder (shell branch 3) |
| SCR007 | `/search` | Search — standalone placeholder |
| SCR008 | `/notifications` | Notifications — standalone placeholder |
| SCR009 | `/award-detail` | Award Detail — standalone placeholder |
| SCR010 | `/about-award` | About Award — standalone placeholder |
| SCR011 | `/about-kudos` | About Kudos — standalone placeholder |
| SCR012 | `/kudos-detail` | Kudos Detail — standalone placeholder |
| SCR013 | `/kudos-feed` | Kudos Feed — standalone placeholder |
| SCR014 | `/write-kudo` | Write Kudo — standalone placeholder |
| SCR015 | `/access-denied` | Access Denied — standalone placeholder (403 target) |

### Sub-features

| # | Sub-feature | Description |
|---|-------------|-------------|
| F002.1 | Hero + countdown | Key visual, event metadata (date/venue/livestream), real-time DAYS/HOURS/MINUTES countdown; 1s Timer; elapsed state shows zeros |
| F002.2 | Awards carousel | Horizontal scroll; loading / empty / error+Retry states; AwardsController (AsyncNotifier); stub repository |
| F002.3 | Kudos section | Feature-flagged (kudosAvailableProvider); fully hidden when false; banner with image fallback |
| F002.4 | Notification badge | unreadCountProvider (StreamProvider<int>); dot badge shown when value > 0 |
| F002.5 | FAB | Pencil → WriteKudo; Kudos-logo → KudosFeed; double-tap guard (_fabBusy flag) |
| F002.6 | Bottom nav shell | StatefulShellRoute.indexedStack; 4 branches (SAA2025/Awards/Kudos/Profile); active tab gold |
| F002.7 | Placeholder screens | Single shared PlaceholderScreen widget reused by all undefined destinations |
| F002.8 | Pinned header | SliverPersistentHeader; logo, language switcher (reuse F001), search, bell with badge |
| F002.9 | Theme description | Static localized "Root Further" block |
| F002.10 | i18n (reuse) | Reuses F001 l10n infrastructure; all static strings localized; language switcher in header |

---

## F003 — Awards Screen

**Purpose:** Dedicated Awards tab showing full detail for each of the 5 SAA 2025 awards, selectable via dropdown.

**Module:** `lib/features/awards/`

| Attribute | Value |
|-----------|-------|
| Status | Shipped (iOS, 2026-06-24) |
| Screens | SCR004 Awards (`/awards`) |
| Depends on | F001 (auth guard, l10n), F002 (HomeHeader, KudosSection widgets, shell) |

### Awards (dropdown options)

| ID | Award Name |
|----|-----------|
| 1 | Top Talent |
| 2 | Top Project Leader |
| 3 | Best Manager |
| 4 | Signature 2025-Creator |
| 5 | MVP |

### Sub-features

| # | Sub-feature | Description |
|---|-------------|-------------|
| F003.1 | Award dropdown | Dropdown selector over 5 awards; selection drives detail view |
| F003.2 | Award detail view | Full award detail loaded from stub repo (content from MoMorph) |
| F003.3 | Loading/error/retry | AsyncNotifier loading state, error state with retry action |
| F003.4 | Home deep-link | Home carousel "Chi tiết" + hero "ABOUT AWARD" → `goBranch(1)` + pre-set `selectedAwardIdProvider` |
| F003.5 | Retired routes | `/award-detail` + `/about-award` placeholders removed; entry points redirected to Awards tab |
| F003.6 | i18n | 5 l10n keys added to ARB VN/EN/JA |
| F003.7 | Widget reuse | `HomeHeader` + `KudosSection` from F002 reused in AwardsScreen |
