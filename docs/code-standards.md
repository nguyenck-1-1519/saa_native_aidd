# Tiêu chuẩn code — SAA 2025

> Áp dụng cho toàn bộ codebase Flutter. Nguồn gốc: clarifications.md + kiến trúc thực tế trong `lib/`.

## 1. Clean Architecture — Quy tắc bắt buộc

### Phân tầng

| Tầng | Được phép import | Cấm import |
|------|-----------------|-----------|
| `domain/` | Dart thuần, không có gì khác | Flutter, Supabase, google_sign_in, Riverpod |
| `data/` | `domain/`, Supabase, google_sign_in, Dart | Flutter widgets, Riverpod |
| `presentation/` | `domain/` (usecases, entities), Riverpod, Flutter | `data/` trực tiếp (chỉ qua provider) |
| `core/` | Dart, Flutter, thư viện hạ tầng | `features/` |

### Interface trước, implementation sau

- Mọi repository đều phải có `abstract interface` trong `domain/repositories/`.
- `data/repositories/` implement interface đó.
- `FakeAuthRepository` implement cùng interface — không tạo class riêng cho test.

## 2. Đặt tên file

- **kebab-case** cho tất cả file Dart: `auth_repository_impl.dart`, `login_screen.dart`.
- Tên file mô tả rõ mục đích, không viết tắt mơ hồ.
- Mỗi file dưới **200 dòng**. Nếu vượt: tách thành module nhỏ hơn.

## 3. Đặt tên class / symbol

| Loại | Convention | Ví dụ |
|------|-----------|-------|
| Class, enum, typedef | PascalCase | `AuthRepositoryImpl`, `LoginController` |
| File | snake_case | `auth_repository_impl.dart` |
| Provider (Riverpod) | camelCase + hậu tố `Provider` | `authStateProvider`, `loginControllerProvider` |
| Usecase class | PascalCase động từ | `SignInWithGoogle`, `WatchAuthState` |
| Failure subtype | PascalCase + `Failure` hoặc tên lỗi | `NetworkFailure`, `AuthCancelled` |

## 4. Riverpod — Quy ước provider

```dart
// Provider đơn giản (DI)
final authRepositoryProvider = Provider<AuthRepository>((ref) { ... });

// StreamProvider cho state bất đồng bộ
final authStateProvider = StreamProvider<AuthUser?>((ref) => ...);

// AsyncNotifierProvider cho action có loading/error
final loginControllerProvider =
    AsyncNotifierProvider<LoginController, void>(LoginController.new);
```

- Provider được định nghĩa trong `presentation/providers/` của feature tương ứng.
- Core providers (locale, router) đặt trong `core/`.
- Không dùng `StateProvider` cho business logic — dùng `Notifier` hoặc `AsyncNotifier`.

## 5. Xử lý lỗi

Pattern: `throw Failure`, không dùng `Either`.

```dart
// Domain — định nghĩa trong core/error/failures.dart
sealed class Failure implements Exception { ... }
class NetworkFailure extends Failure { ... }
class AuthCancelled extends Failure { ... }
class AccountDisabled extends Failure { ... }
class UnknownFailure extends Failure { ... }

// Data layer — bắt exception, ném Failure
try {
  ...
} on SocketException {
  throw const NetworkFailure();
} on AuthApiException catch (e) {
  throw e.statusCode == 400 || e.statusCode == 403
      ? const AccountDisabled()
      : UnknownFailure(e.message);
}

// Presentation — dùng AsyncValue.guard
state = await AsyncValue.guard(() => usecase.call());
// Lỗi → state.hasError → UI đọc state.error và hiển thị message localized
```

- **Không log token** hoặc thông tin nhạy cảm trong `toString()` hay debug output.
- Message lỗi hiển thị cho user phải được localize (ARB).

## 6. i18n

- Mọi string hiển thị ra UI đều phải có trong ARB file (`app_vi.arb`, `app_en.arb`, `app_ja.arb`).
- Chạy `fvm flutter gen-l10n` sau khi thêm key mới.
- String không thay đổi theo ngôn ngữ (ví dụ: "ROOT FURTHER", tên thương hiệu) không cần ARB.
- Ngôn ngữ mặc định: `vi`. Unsupported locale bị bỏ qua, fallback về `vi`.

## 7. Secrets & bảo mật

- `.env` **không commit**. Đã có trong `.gitignore`.
- `config/*.json` commit được vì không chứa secrets — chỉ chứa `APP_ENV`, `APP_NAME`.
- Không hardcode bất kỳ key/token nào trong code Dart.
- Không log token, idToken, accessToken ở bất kỳ log level nào.
- Client-side only: không bundle server secrets vào app.

## 8. Testing

- Mỗi repository có `Fake*` implementation trong `data/repositories/` — không phụ thuộc credentials thật.
- Unit test domain usecase: chỉ mock repository interface (mocktail).
- Widget test: inject `FakeAuthRepository` qua `ProviderScope(overrides: [...])`.
- Tất cả test phải pass offline: không cần Google Client ID, không cần Supabase local chạy.
- Chạy: `fvm flutter test` + `fvm flutter analyze` trước khi push.

## 9. Kích thước file

- Giới hạn cứng: **200 dòng/file**.
- Nếu screen/widget phức tạp: tách widget con ra file riêng trong `widgets/`.
- Usecase mỗi class một file.
- Provider lớn: tách theo domain (auth providers ≠ locale providers).
