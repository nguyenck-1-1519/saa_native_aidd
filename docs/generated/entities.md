# SAA 2025 — Data Model / Entities

All entities are immutable Dart classes in `lib/features/*/domain/entities/`. No local database exists. The only persisted state is the Supabase session JWT (Keychain via `SecureSessionStorage`) and the locale preference (SharedPreferences). All other data is in-memory or fetched at runtime from stub repositories.

---

## MODEL001 — AuthUser

**File:** `lib/features/auth/domain/entities/auth_user.dart`
**Feature:** F001 Auth

Represents a successfully authenticated user. Contains public profile data only — no tokens, no roles.

| Field | Type | Required | Source |
|---|---|---|---|
| `id` | `String` | yes | Supabase `User.id` (UUID) |
| `email` | `String` | yes | Supabase `User.email` |
| `displayName` | `String?` | no | Supabase user metadata |
| `photoUrl` | `String?` | no | Supabase user metadata |

**Persistence:** not serialized to disk. The Supabase session string (Keychain) is restored by `SupabaseAuthDataSource.watchAuthState()` on cold start; the user object is reconstructed from the live session.

**Fake default (demo/test):**
```
id:          'fake-user-id'
email:       'sunner@sun-asterisk.com'
displayName: 'Sun* Tester'
photoUrl:    null
```

**Model mapping:** `AuthUserModel.fromSupabase(User)` in `lib/features/auth/data/models/auth_user_model.dart` maps `supabase_flutter.User` → `AuthUser`.

---

## MODEL002 — AwardCard

**File:** `lib/features/home/domain/entities/award_card.dart`
**Feature:** F002 Home

Represents one award category shown in the Home screen carousel.

| Field | Type | Required | Source |
|---|---|---|---|
| `id` | `String` | yes | Mock data key |
| `name` | `String` | yes | Award category name |
| `description` | `String` | yes | Short description |
| `imageRef` | `String` | yes | Asset path / media key for card image |

**Persistence:** none. Loaded at runtime from `StubAwardsRepository` / `HomeMockData`.

**Live API:** not yet implemented. `AwardsRepository` interface exists; real backend call is deferred. Current implementations: `StubAwardsRepository` (800 ms artificial delay, configurable behavior: `data` / `empty` / `error`) and `FakeAwardsRepository` (immediate, four static scenarios for tests).

---

## MODEL003 — CountdownState

**File:** `lib/features/home/domain/entities/countdown_state.dart`
**Feature:** F002 Home

Represents the remaining time to the SAA 2025 event (target date: 2025-12-26).

| Field | Type | Required | Notes |
|---|---|---|---|
| `days` | `int` | yes | Clamped to 0 once elapsed |
| `hours` | `int` | yes | Clamped to 0 once elapsed |
| `minutes` | `int` | yes | Clamped to 0 once elapsed |
| `isElapsed` | `bool` | yes | `true` when target date is in the past |

**Constant:** `CountdownState.elapsed` — all zeros, `isElapsed: true`.

**Persistence:** none. Recomputed every second by `CountdownController` (Riverpod `Notifier`, 1 s `Timer`) via `ComputeCountdown` use case. Negatives never leak to the UI.

---

## Stub / Mock Data Sources

| Entity | Source file | Status |
|---|---|---|
| `AwardCard` list | `lib/features/home/data/sources/home_mock_data.dart` | Stub — no live endpoint |
| Unread notification count | `StubNotificationRepository` (Stream\<int\>) | Stub — no live endpoint |
| Kudos availability flag | `StubKudosConfigRepository` (bool) | Stub — no live endpoint |

No local database (SQLite, Hive, etc.) is used anywhere in the project.
