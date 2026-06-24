# SAA 2025 — System Overview

## What it is

**SAA 2025** (Sun* Annual Awards) is a mobile app that lets Sun* employees view award categories, follow the event countdown, and eventually submit Kudos recognition. The 2025 edition targets iOS-first; Android support is deferred.

Package: `saa_2025` · Version: `1.0.0+1`

---

## Tech Stack

| Layer | Library / Tool | Version |
|---|---|---|
| Language | Dart | ^3.8.1 |
| Framework | Flutter (fvm) | 3.32.7 |
| State / DI | flutter_riverpod | ^2.5.1 |
| Navigation | go_router | ^14.6.2 |
| Backend | supabase_flutter | ^2.8.0 |
| Auth (native) | google_sign_in | ^6.2.2 |
| Secure storage | flutter_secure_storage | ^9.2.2 |
| Config | flutter_dotenv | ^5.2.1 |
| Locale persist | shared_preferences | ^2.3.3 |
| i18n codegen | flutter gen-l10n | (Flutter built-in) |

---

## Architecture

Clean Architecture, applied per feature. Three canonical layers:

```
presentation/   ← widgets, screens, Riverpod providers/notifiers
domain/         ← entities, repository interfaces, use cases
data/           ← datasources, repository implementations, models
```

Shared infrastructure lives in `core/`:
- `core/config`  — `Env`, `SupabaseInit`, `SecureSessionStorage`
- `core/error`   — sealed `Failure` hierarchy
- `core/l10n`    — `LocaleController`, ARB strings
- `core/router`  — `routerProvider` (GoRouter), `Routes` constants
- `core/theme`   — `AppColors`, `AppTypography`, `AppTheme`

---

## Module List

| ID | Feature | Status |
|---|---|---|
| F001 | Auth (login / logout / session) | Implemented |
| F002 | Home (hero, countdown, awards, kudos) | Implemented |
| — | Placeholder (stub screen for unbuilt routes) | Implemented |
| — | Core (config, error, l10n, router, theme) | Implemented |

Awards, Kudos detail, notifications, profile — routes exist, screens are placeholders.

---

## Build & Run

**Prerequisites:** fvm installed; `fvm use` pins Flutter 3.32.7.

```bash
# Install Flutter via fvm
fvm install

# Development (reads .env for Supabase/Google credentials)
fvm flutter run --dart-define-from-file config/development.json

# Staging
fvm flutter run --dart-define-from-file config/staging.json

# Production
fvm flutter run --dart-define-from-file config/production.json
```

`development.json` only sets `APP_ENV=development` and `APP_NAME`. Supabase and Google credentials come from a local gitignored `.env`. Start local Supabase with `npx supabase start` before running against a live backend.

**No-credential mode:** if `.env` is absent or keys are placeholder strings, `Env.hasSupabaseConfig` / `Env.hasGoogleConfig` return `false`. The app boots into a fake-auth demo path — no native crash on iOS.

---

## Platform Notes

- **iOS:** primary target. Google Sign-In uses Keychain (`KeychainAccessibility.first_unlock`) for session storage. `GIDClientID` must be set in `Info.plist`.
- **Android:** deferred. No `google-services.json` or Android-specific configuration has been added yet.
