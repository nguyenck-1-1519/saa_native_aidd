---
feature_id: F006
title: Profile — self + other (iOS)
lang: vi
platform: iOS (Flutter) — Android sau
fileKey: 9ypp4enmFmdK3YAFJLIu6C
momorph_screens:
  - Self profile:  hSH7L8doXB
  - Other profile: bEpdheM0yU
status: implemented (local stub — no real backend/identity)
depends_on: F003 Awards (AwardDetail), F004 Kudos (KudosStats, Kudo)
---

# F006 — Profile (self + other)

## 1. Mục tiêu

Hiển thị trang cá nhân người dùng (bản thân hoặc người khác).  
Profile tab (shell branch 3 `/profile`) nay là màn thật, không còn `PlaceholderScreen`.  
Other-profile (`/profile/:userId`) available qua tap vào sender/recipient avatar trong feed.

## 2. Màn — ProfileScreen (2 MoMorph screenIds → 1 screen + isSelf)

| Variant | MoMorph screenId | isSelf | Top-bar | Unique affordances |
|---|---|---|---|---|
| Self  | hSH7L8doXB | true  | Settings icon | Edit-profile button, KudosStats section, Secret Box entry |
| Other | bEpdheM0yU | false | Back arrow | Send-Kudo button |

`isSelf = (currentUserId == profileUserId)` — evaluated in route wrapper.

## 3. Routes

| Route | Constant | Widget | Shell | Purpose |
|---|---|---|---|---|
| `/profile` | `Routes.profile` | `SelfProfileRouteWrapper` → `ProfileScreen` | Branch 3 | Self profile tab |
| `/profile/:userId` | `Routes.profileUserPath(userId)` | `OtherProfileRouteWrapper` → `ProfileScreen` | No (push) | Other user profile |

GoRouter literal-before-param: `/profile` (shell, literal) declared before `/profile/:userId` (standalone, param) — no route shadow.

## 4. Module

```
lib/features/profile/
├── domain/
│   ├── entities/profile_data.dart       # aggregate — composes AwardDetail + KudosStats + Kudo
│   ├── entities/profile_user.dart       # net-new entity (name, dept, heroLevel, badges, avatarUrl)
│   ├── repositories/profile_repository.dart
│   └── usecases/get_profile.dart
├── data/
│   ├── sources/profile_mock_data.dart
│   ├── repositories/stub_profile_repository.dart
│   └── repositories/fake_profile_repository.dart
└── presentation/
    ├── profile_screen.dart              # pure presentational; isSelf gates affordances
    ├── profile_view_model.dart          # UI-layer ViewModel (strings only; no domain types)
    ├── profile_filter_host.dart         # StatefulWidget — owns KudosFilter state
    ├── profile_mock_data.dart
    ├── providers/profile_providers.dart # profileProvider (FutureProvider.family) + currentUserIdProvider
    └── widgets/
        ├── profile_header_section.dart
        ├── profile_stats_section.dart
        ├── profile_awards_header.dart
        ├── profile_awards_list.dart
        ├── profile_kudos_section.dart
        ├── profile_kudos_card.dart
        ├── profile_kudos_card_content.dart
        ├── profile_kudos_card_subwidgets.dart
        └── profile_icon_collection.dart
```

Route wrappers live in `lib/core/router/profile_route_wrappers.dart`.

## 5. Composition — ProfileData

`ProfileData` composes three existing domain types — no entity duplication (per YAGNI):

| Field | Type | Source feature |
|---|---|---|
| `user` | `ProfileUser` | F006 (new) |
| `stats` | `KudosStats` | F004 |
| `awards` | `List<AwardDetail>` | F003 |
| `recentKudos` | `List<Kudo>` | F004 |

## 6. FR

- FR1: Self profile (`/profile`) — shows header, icon collection, KudosStats (with Secret Box entry), awards list, kudos feed (received/sent filter via `KudosFilter` dropdown).
- FR2: Other profile (`/profile/:userId`) — same layout but replaces KudosStats section with "Send Kudo" button; settings icon hidden, back arrow shown.
- FR3: `isSelf` evaluated in route wrapper (`currentUserId == profileUserId`); `ProfileScreen` is pure (no Riverpod, no router).
- FR4: `ProfileFilterHost` owns `KudosFilter` state (`received` | `sent`); filters `recentKudos` client-side.
- FR5: Tapping sender/recipient avatar → `context.push(Routes.profileUserPath(uid))` (other-profile push).
- FR6: `profileProvider` is `FutureProvider.family<ProfileData, String>` — keyed by userId; shared cache entry across self and other.
- FR7: `currentUserIdProvider` derives logged-in user id from `authStateProvider`. Returns `null` during transitional sign-out (router guard prevents reaching profile unauth'd).
- FR8: Data from `StubProfileRepository` (local stub; `selfUserId = 'fake-user-id'`; any unrecognised id falls back to other-mock).
- FR9: i18n labels vi/en/ja (loading/error keys). JA cần review người bản ngữ.

## 7. NFR

- Clean Architecture: `features/profile/{domain,data,presentation}`. File <200 dòng.
- `profileRepositoryProvider` and `getProfileProvider` are standard Riverpod DI — overridable in tests with `FakeProfileRepository`.
- Tests: 63 tests (F006); tổng suite 475, 0 failed.

## 8. Deferred

- Real backend identity (Supabase userId → profile data).
- Edit-profile form submission (`onEditProfile` wired but no-op currently).
- Settings screen content (settings icon visible, content empty).
- Social actions (follow, etc.).
- `onTapUser` in Kudo feed cards routes to `/profile/:userId` — stable for sender/recipient avatar taps; deferred full implementation pending stable `KudoDetail.senderId/recipientId` from backend.
- Android.
