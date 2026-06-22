# Roadmap phát triển — SAA 2025

Cập nhật: 2026-06-22

## Trạng thái tổng quan

| Phase | Mô tả | Trạng thái |
|-------|-------|-----------|
| 01–07 | iOS Login MVP (F001) | ✅ Hoàn thành |
| 08 | Android — Google OAuth | Chưa bắt đầu |
| 09+ | Các màn hình SAA tiếp theo | Chưa xác định |

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

## Phase 08 — Android (Google OAuth) — Chưa bắt đầu

**Điều kiện tiên quyết:** Phase 01–07 ✅

### Việc cần làm

- [ ] Tạo Android OAuth client ID trong Google Cloud Console.
- [ ] Thêm `google-services.json` vào `android/app/` (không commit — gitignore).
- [ ] Cấu hình `AndroidManifest.xml`: intent filter cho Google Sign-In callback.
- [ ] Kiểm tra SHA-1 fingerprint của keystore khớp với OAuth client.
- [ ] Thêm `.env` key `GOOGLE_ANDROID_CLIENT_ID` nếu cần.
- [ ] Chạy và test trên Android emulator/device.
- [ ] Viết test suite tương đương iOS (logic giống nhau, platform asset khác).

---

## Phase 09+ — Màn hình SAA tiếp theo — Chưa xác định

Các màn hình nghiệp vụ SAA 2025 sẽ được xác định và spec hóa trong các sprint tiếp theo.

Kiến trúc hiện tại (`features/{slug}/domain|data|presentation`) sẵn sàng cho feature mới.

---

## Unresolved

- Real Google OAuth Client ID/Secret cho môi trường staging/production chưa được cung cấp.
- Android phase chưa có timeline cụ thể.
