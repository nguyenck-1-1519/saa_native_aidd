# Changelog — SAA 2025

Định dạng: [Conventional Commits](https://www.conventionalcommits.org/). Mới nhất ở trên.

---

## [1.7.0+8] — 2026-06-26

### feat: F007 Notifications list + real bell badge (iOS)

**Chi tiết:**

- **SCR017 — NotificationsScreen:** `/notifications` — thay `PlaceholderScreen("Notifications")`. Pure widget (props-driven); `NotificationsRouteWrapper` bind providers + xử lý loading/error/deep-link.
- **Domain:** `AppNotification` + `NotificationType{kudos,award,secretBox,system}` + `NotificationFeedRepository` interface + 3 usecases (`GetNotifications`, `MarkNotificationRead`, `MarkAllNotificationsRead`). Local stub (`StubNotificationFeedRepository`, in-memory).
- **NotificationsController** (`AsyncNotifier`): `refresh()`, `markRead(id)`, `markAllRead()`. `notificationsUnreadCountProvider` (`Provider<int>`) dẫn xuất từ controller state.
- **Deep-link:** kudos + target → push `/kudos/detail/:id`; award → `selectedAwardIdProvider` + `go('/awards')`; secretBox → push `/secret-box`; system → no-op.
- **Bell badge migration:** xóa hardcoded stub 3-unread cũ (3 files). `unreadCountProvider` (`StreamProvider`) nay re-emit `notificationsUnreadCountProvider` — single source of truth. Home + Awards badge phản ánh đúng unread thực tế.
- **i18n:** 5 l10n keys mới (vi/en/ja). Relative-time label dùng hardcoded vi — i18n đúng deferred.
- **Tests:** 41 mới, tổng suite 412, 0 failed.
- **Tồn đọng:** Real push backend/FCM, read-state persistence, relative-time i18n, pagination.

---

## [1.6.0+7] — 2026-06-26

### feat: F005 Secret Box — reveal flow (local stub; iOS)

**Chi tiết:**

- **SCR016 — SecretBoxScreen:** `/secret-box` — full-screen reveal flow (push ngoài shell). 9 MoMorph screenIds (kQk65hSYF2 closed, KUmv414uC9 opening, 7 revealed variants) → 1 screen + state machine.
- **State machine:** `SecretBoxPhase` enum (closed → opening → revealed); `SecretBoxController` (Riverpod `Notifier`) với double-tap guard; error path reset to closed.
- **Domain:** `SecretBoxReward` + `SecretBoxState` entities + `SecretBoxPhase` enum + `SecretBoxRepository` interface + `GetSecretBoxState` / `OpenSecretBox` usecases. Local stub (`StubSecretBoxRepository`, in-memory).
- **FR7 stats-sync:** `kudosStatsProvider` watch `secretBoxStateProvider` (single source of truth) — feed counter (secretBoxOpened / secretBoxUnopened) cập nhật ngay sau mỗi lần mở hộp. Không còn desync giữa KudosScreen stats và SecretBoxScreen.
- **FR8 none-left:** `unopenedCount = 0` → `open()` throws → UI reset to closed; stub khởi tạo 1 box nên path này exercisable sau 1 tap.
- **Entry:** KudosScreen "Mở Secret Box" button → `context.push(Routes.secretBox)`.
- **i18n:** labels vi/en/ja. JA cần review người bản ngữ.
- **Assets:** `SecretBoxReward.assetRef` nullable — box + reward art chưa export S3 → Icon fallback active.
- **Tests:** 77 mới, tổng suite 371, 0 failed.
- **Tồn đọng:** Real backend persistence, server reward allocation, sharing flow, art asset S3 export — tất cả deferred.

---

## [1.5.0+6] — 2026-06-26

### feat: F008 System/Error screens — Access Denied (403) + Not Found (404)

**Chi tiết:**

- **SCR010 — AccessDeniedScreen:** `/access-denied` — thay `PlaceholderScreen("Access Denied")`. Pure widget; trigger hiện tại: `AccountDisabled` (Supabase). Nguồn 403 thực tế (permission check) deferred.
- **SCR015 — NotFoundScreen:** không có route cố định — hiện qua `GoRouter.errorBuilder` cho mọi route không hợp lệ. Pure widget.
- **Auth-aware CTA:** `system_route_wrappers.dart` — logged-in → "Về trang chủ" (`Routes.home`); logged-out → "Về đăng nhập" (`Routes.login`). Widget không tự navigate (dễ test).
- **i18n:** 6 l10n keys mới (vi/en/ja): `accessDeniedTitle`, `accessDeniedMessage`, `notFoundTitle`, `notFoundMessage`, `errorGoHome`, `errorGoLogin`. JA cần review người bản ngữ.
- **Tồn đọng:** Illustration assets (robot mascot + lock) chưa export S3 từ MoMorph — đang dùng Material icon fallback. Nguồn 403 thực tế chưa tích hợp.
- **Tests:** 35 mới, tổng suite 306, 0 failed.

---

## [1.4.0+5] — 2026-06-26

### feat: F004 Kudos follow-up — 5 remaining screens + functional recipient search & feed filters (local stub); Secret Box carved out as F005

**Chi tiết:**

- **F004 — AllKudosScreen:** `/kudos/all` — full list of all kudos with hashtag + department filters (functional, local stub). Entry: KudosScreen "View all Kudos".
- **F004 — ViewKudoScreen:** `/kudos/detail/:id` — kudo detail; supports anonymous variant (`is_anonymous=true` → hides sender name). Entry: feed card "Xem chi tiết".
- **F004 — CommunityStandardsScreen:** `/kudos/community-standards` — static content. Entry: WriteKudo form "Tiêu chuẩn cộng đồng" link.
- **F004 — KudosRulesScreen:** `/kudos/rules` — Thể lệ static content.
- **F004 — Functional search & filters:** recipient search (debounced, excludes self) in WriteKudo now wired to local stub `searchRecipients`; hashtag + department filters in feed now functional (local stub).
- **Domain:** `KudoDetail` entity + `HeroTag` enum added; repo methods `getKudoById`, `getAllKudos`, `getHashtags`, `getDepartments`, `searchRecipients`.
- **Secret Box:** deferred to future F005 (not in F004 scope).
- **Tests:** 270 tests (100 mới so với 1.3.0+4), 0 failed.
- **Tồn đọng:** Tất cả data vẫn là local stub; real backend API, rich-text upload chưa tích hợp.

---

## [1.3.0+4] — 2026-06-24

### feat: Kudos (F004) — KudosScreen feed tab + WriteKudoScreen form; consolidated kudos routes; Home/Awards deep-link to Kudos tab; 170 tests

**Chi tiết:**

- **F004 — KudosScreen:** `PlaceholderScreen("Kudos")` tại `/kudos` (shell branch 2) thay bằng `KudosScreen` đầy đủ. Sections: KV banner, send-kudos prompt, highlight carousel, spotlight board, all-kudos stats + Mở Secret Box, recent recipients row, feed cards, view-all.
- **F004 — WriteKudoScreen:** `/write-kudo` (standalone push) — New Kudo form với local validation. Fields: recipient (required), title ≤100, message ≤1000, hashtag 1–5, image ≤5 (presentational), anonymous toggle. Huỷ (pop) + Gửi đi (stub — no real API yet).
- **Clean Architecture:** `features/kudos/{domain,data,presentation}`; Riverpod providers (`kudosFeedController`, `kudosStatsProvider`, `recentRecipientsProvider`). Stub + fake repos.
- **Route consolidation:** `/kudos-detail`, `/kudos-feed`, `/about-kudos` retired. All entry points (Home FAB S/Kudos, Home Kudos "Chi tiết", Awards "ABOUT KUDOS") → `goBranch(2)` (kKudosBranchIndex=2). Home FAB pencil → `context.push(Routes.writeKudo)`.
- **i18n:** 28 l10n keys thêm vào ARB VN/EN/JA.
- **Tests:** 170 tests (47 mới), 0 failed.
- **Tồn đọng:** Gửi đi là UI stub; spotlight + icons là fallbacks chờ design asset re-upload.

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
