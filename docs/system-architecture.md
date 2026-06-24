# Kiến trúc hệ thống — SAA 2025

> Tài liệu sống. Nguồn gốc: `plans/260622-1419-flutter-mvp-login-supabase/spec/system/architecture.md`.

## 1. Tổng quan

Flutter mobile app (iOS trước, Android sau) theo **Clean Architecture**.
Backend: **Supabase** (local trong dev) cho Auth (Google OAuth) và DB.
State management & DI: **Riverpod**. i18n: `flutter gen-l10n` (ARB).

## 2. Cây thư mục `lib/`

```
lib/
├── main.dart
├── core/
│   ├── config/
│   │   ├── env.dart                   # đọc --dart-define + .env fallback
│   │   ├── supabase_init.dart         # khởi tạo Supabase client
│   │   └── secure_session_storage.dart
│   ├── error/
│   │   └── failures.dart              # sealed Failure + subtypes
│   ├── router/
│   │   └── app_router.dart            # GoRouter + auth redirect guard
│   ├── l10n/
│   │   ├── app_vi.arb / app_en.arb / app_ja.arb
│   │   ├── app_localizations*.dart    # gen-l10n output
│   │   └── locale_controller.dart     # LocaleController (Riverpod + SharedPrefs)
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_typography.dart
└── features/
    ├── auth/
    │   ├── domain/
    │   │   ├── entities/auth_user.dart
    │   │   ├── repositories/auth_repository.dart   # interface (abstract)
    │   │   └── usecases/
    │   │       ├── sign_in_with_google.dart
    │   │       ├── sign_out.dart
    │   │       └── watch_auth_state.dart
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── google_sign_in_data_source.dart
    │   │   │   └── supabase_auth_data_source.dart
    │   │   ├── models/auth_user_model.dart
    │   │   └── repositories/
    │   │       ├── auth_repository_impl.dart
    │   │       └── fake_auth_repository.dart       # dùng trong test + credential-free boot
    │   └── presentation/
    │       ├── providers/auth_providers.dart       # authRepositoryProvider, loginControllerProvider, authStateProvider
    │       ├── screens/login_screen.dart
    │       └── widgets/
    │           ├── google_login_button.dart
    │           └── language_selector.dart
    ├── home/
    │   ├── domain/
    │   │   ├── entities/award.dart
    │   │   ├── repositories/awards_repository.dart  # interface (abstract)
    │   │   └── usecases/get_awards.dart
    │   ├── data/
    │   │   ├── models/award_model.dart
    │   │   └── repositories/
    │   │       ├── awards_repository_impl.dart
    │   │       └── stub_awards_repository.dart      # mock data; real API defer
    │   └── presentation/
    │       ├── providers/home_providers.dart         # awardsProvider, countdownProvider, kudosFeatureFlagProvider
    │       ├── screens/
    │       │   ├── home_screen.dart                  # hero + countdown + awards + kudos + FAB
    │       │   └── placeholder_screen.dart           # shared "chưa triển khai" screen (nhận tên tab)
    │       └── widgets/
    │           ├── hero_section.dart
    │           ├── countdown_widget.dart
    │           ├── awards_carousel.dart
    │           ├── kudos_section.dart
    │           └── notification_badge.dart
    ├── awards/
    │   ├── domain/
    │   │   ├── entities/award_detail.dart
    │   │   ├── repositories/awards_detail_repository.dart  # interface (abstract)
    │   │   └── usecases/get_award_detail.dart
    │   ├── data/
    │   │   ├── models/award_detail_model.dart
    │   │   └── repositories/
    │   │       └── stub_awards_detail_repository.dart  # 5 awards content from MoMorph; real API defer
    │   └── presentation/
    │       ├── providers/awards_providers.dart            # awardsDetailControllerProvider, selectedAwardIdProvider, selectedAwardDetailProvider
    │       ├── screens/
    │       │   └── awards_screen.dart                     # Awards tab: dropdown + detail; loading/error/retry
    │       └── widgets/
    │           ├── award_dropdown.dart
    │           └── award_detail_view.dart
    └── kudos/
        ├── domain/
        │   ├── entities/kudo.dart
        │   ├── repositories/kudos_repository.dart          # interface (abstract)
        │   └── usecases/
        │       ├── get_kudos_feed.dart
        │       └── get_kudos_stats.dart
        ├── data/
        │   └── repositories/
        │       └── stub_kudos_repository.dart              # fake data; real API defer
        └── presentation/
            ├── providers/kudos_providers.dart              # kudosFeedController, kudosStatsProvider, recentRecipientsProvider
            ├── screens/
            │   ├── kudos_screen.dart                       # Kudos tab: KV banner, send-kudos prompt, highlight carousel, spotlight board, stats + Mở Secret Box, recent recipients, feed cards, view-all
            │   └── write_kudo_screen.dart                  # New Kudo form: recipient/title/message/hashtag/image/anonymous; local validation; Huỷ/Gửi đi stub submit
            └── widgets/
                ├── kudos_kv_banner.dart
                ├── kudos_highlight_carousel.dart
                ├── kudos_spotlight_board.dart
                ├── kudos_stats_section.dart
                ├── recent_recipients_row.dart
                ├── kudos_feed_card.dart
                └── write_kudo_form.dart
```

## 3. Quy tắc phụ thuộc (Dependency Rule)

```
presentation → domain ← data
```

- **Domain**: hoàn toàn framework-free. Không import Flutter, Supabase, hay bất kỳ thư viện nào.
- **Data**: implement interface của domain (`AuthRepository`). Import Supabase, google_sign_in.
- **Presentation**: gọi usecase qua Riverpod provider. Không gọi trực tiếp data layer.

## 4. Luồng xác thực (Auth Flow)

```
App start
  └─► WatchAuthState (stream Supabase session)
        ├─ Có session hợp lệ ──► router redirect → /home  (auto-login)
        └─ Không có session  ──► /login

Tap Google button
  └─► LoginController.signInWithGoogle()
        ├─ double-click guard (state.isLoading → return)
        ├─ GoogleSignInDataSource.signIn()  → idToken / accessToken
        ├─ SupabaseAuthDataSource.signInWithIdToken()
        ├─ Thành công → Supabase persist session → stream emit → router /home
        └─ Thất bại   → throw Failure → AsyncError → UI hiển thị localized error

Logout
  └─► SignOut usecase → supabase.auth.signOut() → stream emit null → router /login
```

## 5. Routing & Navigation Shell

`go_router` với `redirect` callback + `StatefulShellRoute` cho bottom navigation 4 tab (F002+):

- `authStateProvider` (StreamProvider) cung cấp `AsyncValue<AuthUser?>`.
- Đang load → return null (không redirect, giữ nguyên).
- Có user + đang ở `/login` → redirect `/home`.
- Không có user + đang ở `/home` → redirect `/login`.

### Navigation Shell (StatefulShellRoute — 4 tab)

```
/home         → HomeScreen (SAA 2025 tab — active mặc định)
/awards       → AwardsScreen (F003 — triển khai đầy đủ)
/kudos        → KudosScreen (F004 — triển khai đầy đủ)
/profile      → PlaceholderScreen("Profile")
```

`StatefulShellRoute` giữ state từng tab khi switch. `PlaceholderScreen` là widget dùng chung (nhận tên màn) — thay bằng màn thật khi feature sẵn sàng.

Standalone (ngoài shell): `/write-kudo` → `WriteKudoScreen` (F004, push navigation).

Các đích còn dùng `PlaceholderScreen`: `/search`, `/notifications`, `/access-denied`.

**Retired routes (F003):** `/award-detail` và `/about-award` đã bị xóa. Home carousel "Chi tiết" và hero "ABOUT AWARD" giờ deep-link tới `/awards` qua `goBranch(1)` với `selectedAwardId` được truyền.

**Retired routes (F004):** `/kudos-detail`, `/kudos-feed`, `/about-kudos` đã bị xóa. Các entry point (Home FAB S/Kudos, Home hero "ABOUT KUDOS", Awards "ABOUT KUDOS") gọi `goBranch(2)` (kKudosBranchIndex=2) vào `KudosScreen`.

**Home → Kudos deep-links:** Home FAB pencil → `context.push(Routes.writeKudo)`; FAB S/Kudos + Home/Awards Kudos "Chi tiết" → `goBranch(2)`.

**Home → Awards deep-link:** `AwardsCarousel` "Chi tiết" + hero "ABOUT AWARD" → `goBranch(1)` + set `selectedAwardIdProvider`.

## 6. State Management (Riverpod)

| Provider | Kiểu | Mục đích |
|----------|------|----------|
| `authRepositoryProvider` | `Provider<AuthRepository>` | DI: trả `AuthRepositoryImpl` hoặc `FakeAuthRepository` |
| `authStateProvider` | `StreamProvider<AuthUser?>` | Stream trạng thái đăng nhập, drive router |
| `loginControllerProvider` | `AsyncNotifierProvider<LoginController, void>` | Xử lý login action + loading/error state |
| `localeControllerProvider` | `NotifierProvider<LocaleController, Locale>` | Ngôn ngữ hiện tại + persist |
| `awardsRepositoryProvider` | `Provider<AwardsRepository>` | DI: `StubAwardsRepository` (real API defer) |
| `awardsProvider` | `AsyncNotifierProvider<AwardsNotifier, List<Award>>` | Fetch + loading/empty/error/retry (Home carousel) |
| `countdownProvider` | `StreamProvider<Duration>` | Đếm ngược tới 26/12/2025, cập nhật mỗi giây; elapsed → Duration.zero |
| `kudosFeatureFlagProvider` | `Provider<bool>` | Ẩn/hiện Kudos section; mặc định `true` |
| `awardsDetailControllerProvider` | `AsyncNotifierProvider<AwardsDetailController, List<AwardDetail>>` | Fetch 5 awards từ stub repo; loading/error/retry (F003) |
| `selectedAwardIdProvider` | `StateProvider<String?>` | ID award đang chọn trong dropdown; pre-selectable từ Home deep-link (F003) |
| `selectedAwardDetailProvider` | `Provider<AwardDetail?>` | Derived: lọc award detail theo `selectedAwardId` (F003) |
| `kudosRepositoryProvider` | `Provider<KudosRepository>` | DI: `StubKudosRepository` (real API defer) (F004) |
| `kudosFeedController` | `AsyncNotifierProvider<KudosFeedController, List<Kudo>>` | Fetch feed từ stub repo; loading/error/retry (F004) |
| `kudosStatsProvider` | `FutureProvider<KudosStats>` | Stats tổng hợp (total kudos, top givers/receivers) (F004) |
| `recentRecipientsProvider` | `FutureProvider<List<KudoRecipient>>` | Recent recipients row (F004) |

## 7. i18n

- 3 locale: `vi` (mặc định), `en`, `ja`.
- ARB files: `lib/core/l10n/app_{vi,en,ja}.arb`.
- Generate: `fvm flutter gen-l10n` (cấu hình trong `pubspec.yaml`: `generate: true`).
- Persist lựa chọn qua `SharedPreferences` trong `LocaleController`.

## 8. Cấu hình môi trường

### Tầng 1 — `--dart-define-from-file`

Ba file không chứa secrets, commit vào git:

| File | Flutter mode | Giá trị |
|------|-------------|---------|
| `config/development.json` | debug | `APP_ENV=development`, `APP_NAME=SAA 2025 (Dev)` |
| `config/staging.json` | profile / debug | `APP_ENV=staging`, `APP_NAME=SAA 2025 (Staging)` |
| `config/production.json` | release | `APP_ENV=production`, `APP_NAME=SAA 2025` |

### Tầng 2 — `.env` (không commit, gitignored)

Chứa secrets và các giá trị phụ thuộc môi trường local:

```
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_PUBLISHABLE_KEY=<anon key từ supabase start>
GOOGLE_CLIENT_ID=<web OAuth client id>
GOOGLE_IOS_CLIENT_ID=<iOS OAuth client id>
```

Đọc qua `flutter_dotenv` (`Env.dart`). Nếu thiếu → app boot với `FakeAuthRepository`.

### iOS — Info.plist

- `GIDClientID`: iOS OAuth client ID.
- URL scheme: reversed iOS client ID (bắt buộc cho `google_sign_in` callback).

## 9. Bảo mật

- Không commit secrets (`.env` trong `.gitignore`).
- Token không được log.
- Supabase session persist qua cơ chế built-in + `flutter_secure_storage`.
- Chỉ một phương thức đăng nhập: Google OAuth. Không có email/password.

## 10. Assets (F002 + F003 + F004)

14 design asset F002 trích từ MoMorph: `assets/images/home/` (Keyvisual BG, Root Further logo,
3× Award card BG, 2× award-name overlays, Kudos Background, Kudos Logo, Pen/Kudos FAB icons,
header logo, VN flag, dropdown chevron).

F003 Awards screen tái sử dụng `HomeHeader` và `KudosSection` widgets từ F002; badge/icon asset
riêng cho từng award chờ re-upload từ design.

F004 Kudos screen tái sử dụng Kudos Background + Kudos Logo từ F002 assets. Spotlight board và
icon asset dùng fallback — chờ design asset re-upload.

**Tồn đọng:** 2 asset stand-in (Award_BG_3, Kudos_Background) + FAB icon fallbacks — chờ
design re-upload. Badge/icon fallbacks cho awards (F003) — chờ re-upload. Spotlight icons (F004)
— chờ re-upload. JA copy cần review người bản ngữ. Signature-Creator dual-prize chưa được xác
nhận trong spec. Submit Kudos (F004) là UI stub — cần real API.

## 11. Quyết định công nghệ

| Vấn đề | Lựa chọn | Lý do |
|--------|----------|-------|
| State / DI | Riverpod | compile-safe, testable, ít boilerplate; `get_it` bị loại (YAGNI) |
| Routing | go_router | redirect guard built-in cho auth flow |
| Auth | google_sign_in + supabase signInWithIdToken | UX native iOS, tương thích local Supabase |
| i18n | flutter gen-l10n (ARB) | chính thống Flutter, đủ VN/EN/JA |
| Secure store | flutter_secure_storage | token an toàn trên thiết bị |
| Config | --dart-define-from-file + .env | tách secrets khỏi env flag; env flag có thể commit |
| Test | flutter_test + mocktail + FakeAuthRepository | không cần creds thật, chạy offline |
