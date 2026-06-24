# Getting Started — SAA 2025

## Yêu cầu

| Tool | Phiên bản | Ghi chú |
|------|----------|---------|
| Flutter (qua FVM) | 3.32.7+ | `fvm use` tự chọn version từ `.fvmrc` |
| Dart | 3.8.1+ | đi kèm Flutter |
| Xcode | 15+ | iOS build, deployment target 15.0 |
| Docker | bất kỳ | chạy Supabase local |
| Node.js / npx | bất kỳ | chạy `npx supabase` |
| VSCode | khuyến nghị | launch configs có sẵn trong `.vscode/` |

---

## 1. Cài FVM (nếu chưa có)

```bash
brew tap leoafarias/fvm
brew install fvm
fvm install        # cài Flutter version từ .fvmrc
```

---

## 2. Khởi động Supabase local

```bash
npx supabase start
```

Lần đầu sẽ pull Docker images (~vài phút). Sau khi xong, terminal in ra:

```
API URL: http://127.0.0.1:54321
anon key: eyJ...
```

Giữ lại hai giá trị này cho bước tiếp theo.

---

## 3. Cấu hình `.env`

Tạo file `.env` ở root project (không commit):

```
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_PUBLISHABLE_KEY=<anon key từ bước 2>
GOOGLE_CLIENT_ID=<web OAuth client id>
GOOGLE_IOS_CLIENT_ID=<iOS OAuth client id>
```

> **Không có Google credentials?** App vẫn boot được — sẽ dùng `FakeAuthRepository`
> (user fake `sunner@sun-asterisk.com`). Chạy test cũng không cần credentials.

---

## 4. Cấu hình Google Sign-In cho iOS (chỉ cần khi test OAuth thật)

Sau khi có `GOOGLE_IOS_CLIENT_ID` (dạng `xxx.apps.googleusercontent.com`):

1. Mở `ios/Runner/Info.plist`.
2. Thêm / cập nhật:
   ```xml
   <key>GIDClientID</key>
   <string>YOUR_IOS_CLIENT_ID</string>

   <!-- URL scheme cho OAuth callback -->
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR_REVERSED_IOS_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```
   Reversed client ID = đảo ngược chuỗi trước `.apps.googleusercontent.com`.

---

## 5. Cài dependencies

```bash
fvm flutter pub get
```

---

## 6. Chạy app

### Qua VSCode (khuyến nghị)

Mở Run & Debug (`⇧⌘D`), chọn một trong:

| Configuration | Flutter mode | Env |
|---------------|-------------|-----|
| SAA · Debug (dev) | debug | development |
| SAA · Staging (profile) | profile | staging |
| SAA · Production (release) | release | production |
| SAA · Staging (debug attach) | debug | staging |

### Qua terminal

```bash
# Development
fvm flutter run --dart-define-from-file=config/development.json

# Staging
fvm flutter run --dart-define-from-file=config/staging.json --profile

# Production
fvm flutter run --dart-define-from-file=config/production.json --release
```

---

## 7. Chạy tests

Không cần Supabase chạy, không cần Google credentials:

```bash
fvm flutter test
fvm flutter analyze
```

Kết quả mong đợi: `49 tests passed, 0 failed` + `No issues found`.

---

## Troubleshooting

| Vấn đề | Nguyên nhân | Giải pháp |
|--------|-----------|----------|
| App boot nhưng không đăng nhập được | `.env` thiếu hoặc Google Client ID sai | Kiểm tra `.env`; app dùng FakeAuthRepository nếu Supabase chưa init |
| `supabase start` fail | Docker chưa chạy | `open -a Docker` rồi thử lại |
| `fvm flutter run` báo lỗi Flutter version | FVM chưa cài đúng version | `fvm install` ở project root |
| Google Sign-In crash trên iOS | URL scheme chưa cấu hình | Kiểm tra `Info.plist` (bước 4) |
| Build iOS fail — deployment target | Xcode cũ | Cần Xcode 15+, target iOS 15.0 |
