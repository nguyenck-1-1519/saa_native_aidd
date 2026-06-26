---
feature_id: F008
title: System / Error Screens — Access Denied (403) + Not Found (404)
lang: vi
platform: iOS (Flutter) — Android sau
fileKey: 9ypp4enmFmdK3YAFJLIu6C
momorph_screens:
  - Access Denied (403): k-7zJk2B7s
  - Not Found (404): sn2mdavs1a
status: shipped
depends_on: F001 (auth state via authStateProvider), F002 (router shell, go_router)
---

# F008 — System / Error Screens (SAA 2025)

## 1. Mục tiêu

Thay thế hai `PlaceholderScreen` cuối cùng trong nhóm hệ thống:
- **SCR010 Access Denied** — hiện khi tài khoản bị từ chối (403 / AccountDisabled).
- **SCR015 Not Found** — hiện khi go_router bắt được route không tồn tại (`errorBuilder`).

Cả hai màn là **pure widget** (StatelessWidget), không biết router. Tầng tích hợp
(`system_route_wrappers.dart`) giải quyết auth-aware CTA và inject vào router.

## 2. Màn hình

### SCR010 — Access Denied (403)

| Trường | Giá trị |
|--------|---------|
| Route | `/access-denied` |
| Class | `AccessDeniedScreen` |
| File | `lib/features/system/presentation/access_denied_screen.dart` |
| Parts | `lib/features/system/presentation/widgets/access_denied_parts.dart` |
| Wrapper | `AccessDeniedRouteWrapper` — `lib/core/router/system_route_wrappers.dart` |
| MoMorph | `https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/k-7zJk2B7s` |
| Shell | No |
| Status | Implemented |

**Hành vi:** Màn tối (`#00101A`), biểu tượng khóa fallback (asset S3 chưa export),
tiêu đề + mô tả từ l10n, một CTA button auth-aware.

**Nguồn 403 thực tế:** Chưa có — `AccountDisabled` từ Supabase là trigger duy nhất
hiện tại. Logic permission-check đầy đủ (FR002) để defer — sẽ tích hợp khi backend
permission API sẵn sàng.

---

### SCR015 — Not Found (404)

| Trường | Giá trị |
|--------|---------|
| Route | Không có route cố định — hiện qua `GoRouter.errorBuilder` |
| Class | `NotFoundScreen` |
| File | `lib/features/system/presentation/not_found_screen.dart` |
| Wrapper | `NotFoundRouteWrapper` — `lib/core/router/system_route_wrappers.dart` |
| MoMorph | `https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/sn2mdavs1a` |
| Shell | No |
| Status | Implemented |

**Hành vi:** Cùng màu nền `#00101A`, layout "4[icon]4" fallback thay robot mascot
(asset S3 chưa export), CTA button auth-aware.

---

## 3. Auth-aware CTA (FR001)

Wrapper `system_route_wrappers.dart` watch `authStateProvider`:

| Trạng thái auth | Label | Action |
|-----------------|-------|--------|
| Đã đăng nhập | `l10n.errorGoHome` | `context.go(Routes.home)` |
| Chưa đăng nhập | `l10n.errorGoLogin` | `context.go(Routes.login)` |

Widget (`AccessDeniedScreen` / `NotFoundScreen`) nhận `primaryLabel` + `onPrimaryAction`
callback — không tự navigate, dễ test độc lập.

## 4. l10n keys (vi / en / ja)

| Key | vi | en |
|-----|----|----|
| `accessDeniedTitle` | (localized) | Access Denied |
| `accessDeniedMessage` | (localized) | You don't have permission… |
| `notFoundTitle` | (localized) | Page Not Found |
| `notFoundMessage` | (localized) | The page you requested… |
| `errorGoHome` | Về trang chủ | Go to Home |
| `errorGoLogin` | Về đăng nhập | Go to Login |

> JA copy đã thêm nhưng cần review người bản ngữ (cùng flag với F002–F004).

## 5. Tồn đọng

- Illustration assets (robot mascot cho Not Found, lock illustration cho Access Denied)
  chưa export S3 từ MoMorph — cả hai màn đang dùng Material icon fallback.
- Nguồn 403 thực tế (permission check) chưa tích hợp — FR002 deferred.
- JA copy cần review người bản ngữ.

## 6. Tests

35 test mới (tổng suite 306, 0 failed). Bao gồm:
- Widget test cho `AccessDeniedScreen` + `NotFoundScreen` (pure widget, không provider).
- Widget test cho `AccessDeniedRouteWrapper` + `NotFoundRouteWrapper` (logged-in + logged-out states).
- Unit test CTA label/action routing logic.
