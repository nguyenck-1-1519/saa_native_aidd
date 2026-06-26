# Roadmap phát triển — SAA 2025

Cập nhật: 2026-06-26 (F006 Profile)

## Trạng thái tổng quan

| Phase | Mô tả | Trạng thái |
|-------|-------|-----------|
| 01–07 | iOS Login MVP (F001) | ✅ Hoàn thành |
| 08 | F002 Home Screen (iOS) | ✅ Hoàn thành |
| 09 | F003 Awards Screen (iOS) | ✅ Hoàn thành |
| 10 | F004 Kudos Screen + WriteKudo (iOS) | ✅ Hoàn thành |
| 10b | F004 Kudos follow-up: 5 screens + functional search/filters (local stub) | ✅ Hoàn thành |
| 10c | F008 System/Error screens — Access Denied (403) + Not Found (404) | ✅ Hoàn thành |
| 11 | F005 Secret Box reveal flow (local stub) | ✅ Hoàn thành |
| 11b | F007 Notifications list + real bell badge (iOS) | ✅ Hoàn thành |
| 11c | F006 Profile — self + other screens; Profile tab no longer placeholder | ✅ Hoàn thành |
| 12 | Android — Google OAuth | Chưa bắt đầu |
| 13+ | API thật (kudos submit/feed/search), Search screen, Android Home | Chưa xác định |

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

## Phase 09 — F003 Awards Screen (iOS) ✅

**Hoàn thành:** 2026-06-24

### Đã thực hiện

- **Feature F003 — Awards tab:** `AwardsScreen` thay thế `PlaceholderScreen("Awards")` tại `/awards` (shell branch 1).
- Dropdown 5 awards: Top Talent, Top Project Leader, Best Manager, Signature 2025-Creator, MVP.
- Clean Architecture: `features/awards/{domain,data,presentation}`; Riverpod providers (`awardsDetailControllerProvider`, `selectedAwardIdProvider`, `selectedAwardDetailProvider`).
- Loading / error+retry states. Stub repo với content từ MoMorph.
- Home deep-link: carousel "Chi tiết" + hero "ABOUT AWARD" → `goBranch(1)` + pre-select award qua `selectedAwardIdProvider`.
- Retired `/award-detail` + `/about-award` placeholder routes.
- Widget reuse: `HomeHeader` + `KudosSection` từ F002.
- i18n: 5 l10n keys (VN/EN/JA).
- **Tests:** 123 tests, 0 failed (32 mới).

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 123 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 10 — F004 Kudos Screen (iOS) ✅

**Hoàn thành:** 2026-06-24

### Đã thực hiện

- **Feature F004 — Kudos tab:** `KudosScreen` thay thế `PlaceholderScreen("Kudos")` tại `/kudos` (shell branch 2).
- KV banner, send-kudos prompt, highlight carousel, spotlight board, all-kudos stats + Mở Secret Box, recent recipients row, feed cards, view-all.
- **Feature F004 — Write Kudo:** `WriteKudoScreen` tại `/write-kudo` (standalone push). Form: recipient/title≤100/message≤1000/hashtag 1–5/image≤5 presentational/anonymous; local validation; Huỷ/Gửi đi stub submit.
- Clean Architecture: `features/kudos/{domain,data,presentation}`; Riverpod providers (`kudosFeedController`, `kudosStatsProvider`, `recentRecipientsProvider`). Stub + fake repos.
- Route consolidation: `/kudos-detail`, `/kudos-feed`, `/about-kudos` retired → `goBranch(2)`; Home FAB pencil → `push(/write-kudo)`.
- i18n: 28 l10n keys (VN/EN/JA).
- **Tests:** 170 tests total (47 mới), 0 failed.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 170 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 10b — F004 Kudos follow-up: 5 screens + functional search/filters (iOS) ✅

**Hoàn thành:** 2026-06-26

### Đã thực hiện

- **AllKudosScreen** (`/kudos/all`): danh sách toàn bộ kudos với hashtag + department filter hoạt động thực sự (local stub).
- **ViewKudoScreen** (`/kudos/detail/:id`): chi tiết kudo; biến thể anonymous che tên người gửi.
- **CommunityStandardsScreen** (`/kudos/community-standards`): màn nội dung tĩnh tiêu chuẩn cộng đồng.
- **KudosRulesScreen** (`/kudos/rules`): màn nội dung tĩnh Thể lệ.
- **Functional recipient search:** debounced, loại trừ chính mình, từ local stub `searchRecipients`.
- **Domain mới:** `KudoDetail` entity + `HeroTag` enum; repo methods `getKudoById`, `getAllKudos`, `getHashtags`, `getDepartments`, `searchRecipients`.
- **Secret Box:** tách ra thành F005 (không thuộc scope F004).
- **Tests:** 270 tests total (100 mới), 0 failed.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 270 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 10c — F008 System/Error Screens (iOS) ✅

**Hoàn thành:** 2026-06-26

### Đã thực hiện

- **SCR010 — AccessDeniedScreen** (`/access-denied`): thay `PlaceholderScreen("Access Denied")`. Pure widget; `AccessDeniedRouteWrapper` giải quyết auth-aware CTA.
- **SCR015 — NotFoundScreen**: hiện qua `GoRouter.errorBuilder` — bắt mọi route không hợp lệ. `NotFoundRouteWrapper` giải quyết auth-aware CTA.
- **Auth-aware CTA** (`system_route_wrappers.dart`): logged-in → `Routes.home`; logged-out → `Routes.login`. Widget không tự navigate.
- **i18n:** 6 l10n keys mới (vi/en/ja): `accessDeniedTitle/Message`, `notFoundTitle/Message`, `errorGoHome`, `errorGoLogin`. JA cần review người bản ngữ.
- **Tests:** 35 mới, tổng suite 306, 0 failed.
- **Tồn đọng:** Illustration assets (MoMorph S3 chưa export) → Material icon fallback. Nguồn 403 thực tế (permission check) deferred.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 306 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 11 — F005 Secret Box reveal flow (iOS) ✅

**Hoàn thành:** 2026-06-26

### Đã thực hiện

- **Feature F005 — SecretBoxScreen** (`/secret-box`, push ngoài shell): closed → opening → revealed state machine.
- 9 MoMorph screenIds (kQk65hSYF2 closed, KUmv414uC9 opening, 7 revealed variants) → 1 screen.
- Domain: `SecretBoxReward` + `SecretBoxState` + `SecretBoxPhase` enum + repo interface + `GetSecretBoxState` / `OpenSecretBox` usecases. Local stub (in-memory).
- `SecretBoxController` (Riverpod `Notifier`): double-tap guard, error reset, `ref.invalidate(secretBoxStateProvider)` on success.
- FR7 stats-sync: `kudosStatsProvider` watch `secretBoxStateProvider` — single source of truth cho feed counter.
- FR8 none-left: `unopenedCount = 0` → throws; exercisable sau 1 tap từ stub.
- i18n vi/en/ja. Asset S3 chưa export — Icon fallback.
- **Tests:** 77 mới, tổng suite 371, 0 failed.
- **Tồn đọng:** Real backend, server reward allocation, sharing, art asset S3 export.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 371 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 11b — F007 Notifications list + real bell badge (iOS) ✅

**Hoàn thành:** 2026-06-26

### Đã thực hiện

- **Feature F007 — NotificationsScreen** (`/notifications`, push ngoài shell): thay `PlaceholderScreen("Notifications")`. Pure widget (props-driven); `NotificationsRouteWrapper` bind providers + xử lý loading/error/deep-link.
- Domain: `AppNotification` + `NotificationType{kudos,award,secretBox,system}` + repo interface + 3 usecases. Local stub (in-memory).
- `NotificationsController` (`AsyncNotifier`): refresh/markRead/markAllRead. `notificationsUnreadCountProvider` dẫn xuất.
- Deep-link: kudos→`/kudos/detail/:id`, award→`selectedAwardIdProvider`+`/awards`, secretBox→`/secret-box`, system→no-op.
- Bell badge migration: xóa hardcoded stub 3-unread (3 files). `unreadCountProvider` nay re-emit `notificationsUnreadCountProvider` — single source of truth cho Home + Awards badge.
- i18n vi/en/ja (5 keys). JA cần review người bản ngữ.
- **Tests:** 41 mới, tổng suite 412, 0 failed.
- **Tồn đọng:** Real push backend/FCM, read-state persistence, relative-time i18n, pagination.

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 412 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 11c — F006 Profile — self + other (iOS) ✅

**Hoàn thành:** 2026-06-26

### Đã thực hiện

- **Profile tab (shell branch 3, `/profile`):** `SelfProfileRouteWrapper` → `ProfileScreen(isSelf: true)` — thay thế `PlaceholderScreen("Profile")`.
- **Other-profile (`/profile/:userId`, push ngoài shell):** `OtherProfileRouteWrapper` → `ProfileScreen(isSelf: false)`. GoRouter literal-before-param — không shadow.
- **Single screen, two variants:** `isSelf` gates: self → KudosStats + Secret Box entry + edit button; other → Send-Kudo button + back arrow.
- **ProfileData COMPOSES:** `AwardDetail` (F003) + `KudosStats` (F004) + `Kudo` (F004) + `ProfileUser` (F006 net-new). Không duplicate entity.
- **Providers:** `profileProvider` (`FutureProvider.family`, keyed by userId) + `currentUserIdProvider` (từ `authStateProvider`).
- **ProfileFilterHost:** client-side `KudosFilter{received,sent}` filter trên `recentKudos`.
- **`onTapUser`:** avatar tap → `push(/profile/:userId)` wired; full detail deferred (pending real backend userId).
- Local stub (`StubProfileRepository`). i18n vi/en/ja (loading/error keys).
- **Tests:** 63 mới, tổng suite 475, 0 failed.
- **Tồn đọng:** Real backend identity, edit-profile submission, settings content, social actions.

> **Note:** với F005–F008 + F006 + F007 hoàn thành, tất cả iOS MoMorph placeholder tabs đã được thay bằng màn thật. Placeholder duy nhất còn lại là Search (`/search`) — không có iOS design (SCR007).

### Số liệu

| Chỉ số | Giá trị |
|--------|---------|
| Tổng số tests | 475 |
| `fvm flutter analyze` | No issues |
| Platform | iOS-only |

---

## Phase 12 — Android (Google OAuth) — Chưa bắt đầu

**Điều kiện tiên quyết:** Phase 01–10 ✅

### Việc cần làm

- [ ] Tạo Android OAuth client ID trong Google Cloud Console.
- [ ] Thêm `google-services.json` vào `android/app/` (không commit — gitignore).
- [ ] Cấu hình `AndroidManifest.xml`: intent filter cho Google Sign-In callback.
- [ ] Kiểm tra SHA-1 fingerprint của keystore khớp với OAuth client.
- [ ] Thêm `.env` key `GOOGLE_ANDROID_CLIENT_ID` nếu cần.
- [ ] Chạy và test trên Android emulator/device.
- [ ] Viết test suite tương đương iOS (logic giống nhau, platform asset khác).

---

## Phase 13+ — API thật + Màn hình thật + Android — Chưa xác định

Ưu tiên tiếp theo (thứ tự gợi ý):

1. Tích hợp API thật cho Kudos: submit kudo (F004 Gửi đi stub), kudos feed/stats, recipient search, filters.
2. Profile backend identity: thay `StubProfileRepository` bằng real Supabase + edit-profile submission + settings content.
3. Search screen (`/search`, SCR007): iOS design chưa có — cần thiết kế trước khi implement.
4. Android Home + OAuth (tương đương Phase 12 iOS nhưng cho Home + F002–F008).
5. JA copy review người bản ngữ + re-upload asset tồn đọng (Award_BG_3, Kudos_Background, badge/icon F003, spotlight icons F004, profile + system screen illustrations).
6. Xác nhận Signature-Creator dual-prize logic.

Kiến trúc hiện tại (`features/{slug}/domain|data|presentation`) sẵn sàng cho feature mới.

---

## Unresolved

- Real Google OAuth Client ID/Secret cho môi trường staging/production chưa được cung cấp.
- Android phase chưa có timeline cụ thể.
- API thật cho awards / kudos submit+feed+search+filters / Kudos feature flag chưa có spec.
- 2 asset stand-in (Award_BG_3, Kudos_Background) + FAB icon fallbacks chờ design re-upload.
- Badge/icon asset cho F003 Awards chờ design re-upload.
- Spotlight icons cho F004 Kudos chờ design re-upload.
- Signature-Creator dual-prize: xác nhận logic/spec chưa hoàn tất.
- JA copy cần review người bản ngữ.
- F004 Gửi đi (submit kudos) là UI stub — cần real API endpoint.
- F005 Secret Box: real backend persistence + server reward allocation + sharing flow + art asset S3 export — deferred (local stub shipped).
- F006 Profile: real backend identity (Supabase userId → ProfileData), edit-profile form submission, settings content, social actions — deferred (local stub shipped).
- F007 Notifications: real push backend/FCM, read-state persistence (in-memory only), relative-time i18n (vi hardcoded), pagination — all deferred (local stub shipped).
- Search screen (SCR007, `/search`): no iOS design exists — design required before implementation.
