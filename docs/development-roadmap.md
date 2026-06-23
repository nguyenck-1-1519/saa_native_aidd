# Roadmap phát triển — SAA 2025

Cập nhật: 2026-06-23

## Trạng thái tổng quan

| Phase | Mô tả | Trạng thái |
|-------|-------|-----------|
| 01–07 | iOS Login MVP (F001) | ✅ Hoàn thành |
| 08 | F002 Home Screen (iOS) | ✅ Hoàn thành |
| 09 | Android — Google OAuth | Chưa bắt đầu |
| 10+ | Màn hình thật (Awards, Kudos, Profile), API thật, Android Home | Chưa xác định |

---

## Phase 01–07 — iOS Login MVP ✅

**Hoàn thành:** 2026-06-22

### Đã thực hiện

- **Kiến trúc:** Flutter Clean Architecture (domain / data / presentation), Riverpod DI/state, go_router auth guard.
- **Feature F001 — Login:**
  - UI theo Figma: logo, "ROOT FURTHER", description, language selector, Google button, copyright.
  - Google OAuth (native `google_sign_in` → `supabase.auth.signInWithIdToken`).
  - Loading/disabled state + double-click prevention.
  - Auto-login khi token còn hạn; redirect Login khi hết hạn/logout.
  - Home placeholder (user info + logout).
- **i18n:** VN / EN / JA (flutter gen-l10n ARB), persist lựa chọn qua SharedPreferences.
- **Multi-env:** `--dart-define-from-file` với `config/{development,staging,production}.json` + `.env` fallback.
- **VSCode:** 4 launch configurations (dev/staging/production/staging-debug).
- **Tests:** 49 tests, 0 failed — unit (domain, data, fake repo, locale) + widget + e2e redirect flow.
- **iOS deployment target:** 15.0.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Test cases (TC) | 20/20 pass |
| Tổng số tests | 49 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 08 — F002 Home Screen (iOS) ✅

**Hoàn thành:** 2026-06-23

### Đã thực hiện

- **Navigation shell:** `StatefulShellRoute` 4 tab (SAA 2025 / Awards / Kudos / Profile); `PlaceholderScreen` dùng chung cho tất cả đích chưa triển khai.
- **Feature F002 — Home:**
  - Hero section: key-visual BG, Root Further logo, countdown real-time (DAYS/HOURS/MINUTES) tới 26/12/2025; xử lý elapsed (hiển thị 0, không âm/lỗi).
  - Awards carousel: cuộn ngang; loading / empty / error + Retry từ stub repository.
  - Kudos section: feature-flagged (`kudosFeatureFlagProvider`), ẩn hẳn khi tắt.
  - FAB: pencil → WriteKudo + chống double-tap; S/Kudos → Kudos feed.
  - Notification bell badge: hiện khi unread > 0.
  - Auth guard: session hết hạn/401 → Login; 403 → Access Denied placeholder.
  - i18n: chuỗi Home thêm vào ARB VN/EN/JA; JA flagged cần review người bản ngữ.
- **Clean Architecture:** `features/home/{domain,data,presentation}`; Riverpod providers.
- **Assets:** 14 design asset trích từ MoMorph → `assets/images/home/`.
  - Tồn đọng: 2 asset stand-in (Award_BG_3, Kudos_Background) + FAB icon fallbacks chờ design re-upload.
- **Tests:** 91 tests, 0 failed (unit + widget; total cộng dồn từ F001+F002).

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Test cases (TC) | 32/32 pass |
| Tổng số tests | 91 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 09 — Android (Google OAuth) — Chưa bắt đầu

**Điều kiện tiên quyết:** Phase 01–08 ✅

### Việc cần làm

- [ ] Tạo Android OAuth client ID trong Google Cloud Console.
- [ ] Thêm `google-services.json` vào `android/app/` (không commit — gitignore).
- [ ] Cấu hình `AndroidManifest.xml`: intent filter cho Google Sign-In callback.
- [ ] Kiểm tra SHA-1 fingerprint của keystore khớp với OAuth client.
- [ ] Thêm `.env` key `GOOGLE_ANDROID_CLIENT_ID` nếu cần.
- [ ] Chạy và test trên Android emulator/device.
- [ ] Viết test suite tương đương iOS (logic giống nhau, platform asset khác).

---

## Phase 10+ — Màn hình thật + API thật — Chưa xác định

Ưu tiên tiếp theo (thứ tự gợi ý):

1. Thay `PlaceholderScreen` bằng màn thật: Awards list/detail, Kudos feed/detail, Profile.
2. Tích hợp API thật cho awards, notifications, Kudos flag (hiện dùng stub).
3. Android Home + OAuth (tương đương Phase 09 iOS nhưng cho Home).
4. JA copy review người bản ngữ + re-upload 2 asset tồn đọng.

Kiến trúc hiện tại (`features/{slug}/domain|data|presentation`) sẵn sàng cho feature mới.

---

## Unresolved

- Real Google OAuth Client ID/Secret cho môi trường staging/production chưa được cung cấp.
- Android phase chưa có timeline cụ thể.
- API thật cho awards / notifications / Kudos feature flag chưa có spec.
- 2 asset stand-in (Award_BG_3, Kudos_Background) + FAB icon fallbacks chờ design re-upload.
- JA copy cần review người bản ngữ.
