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
    └── home/
        └── presentation/home_screen.dart           # placeholder MVP
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

## 5. Routing & Auth Guard

`go_router` với `redirect` callback:

- `authStateProvider` (StreamProvider) cung cấp `AsyncValue<AuthUser?>`.
- Đang load → return null (không redirect, giữ nguyên).
- Có user + đang ở `/login` → redirect `/home`.
- Không có user + đang ở `/home` → redirect `/login`.

## 6. State Management (Riverpod)

| Provider | Kiểu | Mục đích |
|----------|------|----------|
| `authRepositoryProvider` | `Provider<AuthRepository>` | DI: trả `AuthRepositoryImpl` hoặc `FakeAuthRepository` |
| `authStateProvider` | `StreamProvider<AuthUser?>` | Stream trạng thái đăng nhập, drive router |
| `loginControllerProvider` | `AsyncNotifierProvider<LoginController, void>` | Xử lý login action + loading/error state |
| `localeControllerProvider` | `NotifierProvider<LocaleController, Locale>` | Ngôn ngữ hiện tại + persist |

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

## 10. Quyết định công nghệ

| Vấn đề | Lựa chọn | Lý do |
|--------|----------|-------|
| State / DI | Riverpod | compile-safe, testable, ít boilerplate; `get_it` bị loại (YAGNI) |
| Routing | go_router | redirect guard built-in cho auth flow |
| Auth | google_sign_in + supabase signInWithIdToken | UX native iOS, tương thích local Supabase |
| i18n | flutter gen-l10n (ARB) | chính thống Flutter, đủ VN/EN/JA |
| Secure store | flutter_secure_storage | token an toàn trên thiết bị |
| Config | --dart-define-from-file + .env | tách secrets khỏi env flag; env flag có thể commit |
| Test | flutter_test + mocktail + FakeAuthRepository | không cần creds thật, chạy offline |
