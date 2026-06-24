# Changelog — SAA 2025

Định dạng: [Conventional Commits](https://www.conventionalcommits.org/). Mới nhất ở trên.

---

## [1.2.0+3] — 2026-06-24

### feat: Awards screen (F003) — 1 screen + dropdown over 5 awards; Home deep-links to it; retired award-detail/about-award placeholders; 123 tests

**Chi tiết:**

- **F003 — AwardsScreen:** `PlaceholderScreen("Awards")` tại `/awards` thay bằng `AwardsScreen` đầy đủ.
- **5 awards:** Top Talent, Top Project Leader, Best Manager, Signature 2025-Creator, MVP (content từ MoMorph, stub repo).
- **Clean Architecture:** `features/awards/{domain,data,presentation}`; Riverpod providers (`awardsDetailControllerProvider`, `selectedAwardIdProvider`, `selectedAwardDetailProvider`).
- **States:** loading / error+retry / content. Tái sử dụng `HomeHeader` + `KudosSection` từ F002.
- **Home deep-link:** carousel "Chi tiết" (award id) + hero "ABOUT AWARD" → `goBranch(1)` + pre-set `selectedAwardIdProvider`; không thay đổi URL.
- **Retired routes:** `/award-detail` (`Routes.awardDetail`) + `/about-award` (`Routes.aboutAward`) xóa khỏi router.
- **i18n:** 5 l10n keys thêm vào ARB VN/EN/JA.
- **Tests:** 123 tests (32 mới), 0 failed.
- **Tồn đọng:** Signature-Creator dual-prize chưa xác nhận; badge/icon asset chờ re-upload.

---

## [1.1.0+2] — 2026-06-23

### feat: Home screen (F002) — countdown, awards carousel, Kudos section, FAB, 4-tab navigation shell, i18n + placeholder navigation; 91 tests

**Chi tiết:**

- **Navigation shell:** `StatefulShellRoute` 4 tab (SAA 2025 / Awards / Kudos / Profile). Shared `PlaceholderScreen` cho mọi đích chưa triển khai (search, notifications, award detail, kudos overview/detail/write, access-denied).
- **F002 — Home screen:**
  - Hero: key-visual, Root Further logo, countdown real-time mỗi giây (DAYS/HOURS/MINUTES) tới 26/12/2025; xử lý elapsed → hiển thị 0, không âm/lỗi.
  - Awards carousel: cuộn ngang, loading/empty/error+Retry từ `StubAwardsRepository`.
  - Kudos section: feature-flagged, ẩn hẳn khi `isKudosAvailable=false`.
  - FAB: pencil với chống double-tap; S/Kudos tab.
  - Notification bell badge: hiện khi unread > 0.
  - Auth guard: 401 → Login, 403 → Access Denied.
- **Clean Architecture:** `features/home/{domain,data,presentation}`, Riverpod providers (`awardsProvider`, `countdownProvider`, `kudosFeatureFlagProvider`).
- **Assets:** 14 MoMorph design asset → `assets/images/home/`. Tồn đọng: 2 stand-in (Award_BG_3, Kudos_Background) + FAB icon fallbacks chờ re-upload.
- **i18n:** Home strings thêm vào ARB VN/EN/JA (`AppLocalizations`). JA cần review người bản ngữ.
- **Tests:** 91 tests (42 mới), 0 failed — unit (countdown elapsed, awards states, kudos flag, FAB guard, badge) + widget + placeholder routing.

---

## [1.0.0+1] — 2026-06-22

### feat: bootstrap Flutter MVP + Login (Supabase Google OAuth, Clean Architecture, iOS-first, i18n VN/EN/JA, VSCode multi-env, 49 tests)

**Chi tiết:**

- Khởi tạo project Flutter `saa_2025` (SDK ^3.8.1, FVM).
- Clean Architecture: `core/` + `features/auth/{domain,data,presentation}` + `features/home/` placeholder.
- F001 — Login via Google OAuth:
  - `google_sign_in` (native) → `supabase.auth.signInWithIdToken`.
  - Auto-login (session persist), loading state, double-click prevention.
  - Error handling: `NetworkFailure`, `AuthCancelled`, `AccountDisabled`, `UnknownFailure`.
- go_router auth guard: redirect `/login` ↔ `/home` theo `authStateProvider`.
- Riverpod: `authStateProvider` (stream), `loginControllerProvider` (AsyncNotifier), `localeControllerProvider`.
- i18n: flutter gen-l10n, ARB cho vi/en/ja, persist lựa chọn (SharedPreferences).
- Multi-env: `config/{development,staging,production}.json` + `.env` (gitignored).
- VSCode: 4 launch configs (`SAA · Debug (dev)`, `SAA · Staging (profile)`, `SAA · Production (release)`, `SAA · Staging (debug attach)`).
- `FakeAuthRepository`: chạy offline, không cần credentials thật.
- Test suite: 49 tests (unit + widget + e2e), `fvm flutter analyze` → no issues.
- iOS deployment target: 15.0.
