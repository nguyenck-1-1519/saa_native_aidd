---
feature_id: F002
title: Màn hình Home (Trang chủ) — SAA 2025
lang: vi
platform: iOS (Flutter) — Android sau
screen: "[iOS] Home"
screenId: OuH1BUTYT0
fileKey: 9ypp4enmFmdK3YAFJLIu6C
momorph: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/OuH1BUTYT0
status: shipped (iOS, 2026-06-23)
depends_on: F001 (Login — đã xong; tái dùng router, theme, l10n, auth guard)
---

# F002 — Màn hình Home (SAA 2025)

## 1. Mục tiêu
Trang chủ giới thiệu SAA 2025: hero + countdown, mô tả theme, danh sách giải thưởng,
khối Sun* Kudos, FAB và bottom navigation. Là màn đích sau khi đăng nhập (F001).
Màn hình **dài, cuộn dọc** (design 375×1942), nền `#00101A` + key-visual.

> **Yêu cầu người dùng (bắt buộc):**
> 1. **Cắt/lấy ảnh tuyệt đối chính xác** — tải đúng từng asset MM_MEDIA qua MoMorph
>    `get_media_files`/`get_figma_image`, KHÔNG tự vẽ/đoán. Pixel-perfect.
> 2. **Hand-off + full quyền** — thực thi bằng `tkm:takumi --auto` (không dừng rest point).
> 3. **Đích điều hướng chưa rõ → màn placeholder** ("để screen trống trước").

## 2. Phạm vi
- IN: UI Home pixel-perfect, countdown real-time, awards list (loading/empty/error/retry),
  Kudos section (feature-flag ẩn/hiện), notification badge, FAB, bottom nav shell,
  wiring điều hướng tới **placeholder screens** cho mọi đích chưa định nghĩa, auth guard
  (chưa đăng nhập → Login), i18n (tái dùng hạ tầng l10n, default VN).
- OUT: Các màn đích thật (Awards, Kudos feed/detail, Award Detail, Search, Notifications,
  WriteKudo, Profile) — chỉ làm **placeholder**. API thật cho awards/notifications
  (dùng mock/stub data source có đủ state). Android.

## 3. Thành phần UI (15 spec item)
| # | itemId | Tên | Loại | Hành vi |
|---|--------|-----|------|---------|
| 1 | 6885:9057 | Header | navigation | logo; language switcher (mở modal/dropdown — tái dùng LanguageSelector F001); search → Search (placeholder); bell → Notifications (placeholder) + badge khi unread>0 |
| 2 | 6885:8983 | Main content (hero) | info_block | theme logo, "Coming soon", countdown DAYS/HOURS/MINUTES, ngày 26/12/2025, địa điểm Âu Cơ Art Center, ghi chú livestream, 2 nút |
| 2.1 | 6885:8984 | Root Further logo | image | tĩnh (asset — giống F001 root_further) |
| 2.2 | 6885:9026 | ABOUT AWARD button | button icon_text | → Awards overview (placeholder) |
| 2.3 | 6885:9027 | ABOUT KUDOS button | button icon_text | → Kudos overview (placeholder) |
| 3 | 6885:9028 | Theme description | label | đoạn mô tả "Root Further" (tĩnh, localized) |
| 4 | 6885:9030 | Awards section | card | header + list card cuộn ngang |
| 4.1 | 6885:9031 | Awards header | label | "Sun* Annual Awards 2025" + "Hệ thống giải thưởng" |
| 4.2 | 6885:9032 | Award card list | list_item | card: ảnh + tên + mô tả (ellipsis) + "Chi tiết →"; cuộn ngang; Chi tiết → Award Detail (placeholder); loading/empty/error |
| 5 | 6885:9039 | Kudos section | info_block | header + banner + badge "ĐIỂM MỚI CỦA SAA 2025" + mô tả + Chi tiết; ẩn toàn bộ khi feature off |
| 5.1 | 6885:9040 | Kudos header | label | "Phong trào ghi nhận" + "Sun* Kudos" |
| 5.2 | 6885:9041 | Kudos banner | image | banner (asset) + fallback placeholder khi lỗi ảnh |
| 5.3 | 6885:9055 | Kudos detail button | button icon_text | "Chi tiết" → Kudos detail (placeholder) |
| 6 | 6885:9058 | FAB | button | pencil → WriteKudo (placeholder, chống double-tap); S/Kudos → Kudos feed (placeholder) |
| 7 | 6885:9056 | Bottom nav bar | navigation | 4 tab: SAA 2025 (active), Awards, Kudos, Profile → tab placeholder; tab active tô vàng |

### Nội dung mock (từ design — KHÔNG bịa)
- Ngày: "Thời gian: 26/12/2025" · Địa điểm: "Địa điểm: Âu Cơ Art Center"
- Livestream: "Tường thuật trực tiếp tại Group Facebook Sun* Family"
- Awards mẫu: "Top Talent" / "Top Project" (tên + mô tả truncate từ design)
- Kudos badge: "ĐIỂM MỚI CỦA SAA 2025"; mô tả Kudos (đoạn VN trong design)
- Nav labels: SAA 2025 / Awards / Kudos / Profile

## 4. Assets cần cắt CHÍNH XÁC (14 MM_MEDIA node — bắt buộc tải đúng)
Tải tại forge-time qua `get_media_files(OuH1BUTYT0)` → curl đúng URL; với SVG/icon
dùng `get_figma_image`. KHÔNG tự vẽ.
- `6885:8980` MM_MEDIA_Keyvisual BG (nền hero, role overlay/bg)
- `I6885:8984;65:1590` Root Further logo (≈247×109 — có thể tái dùng asset F001)
- `I6885:9033;72:2115;72:2079` Award BG (160×160) + `...72:2080;10:951` "Top Talent" name
- `I6885:9034;72:2115;72:2085` Award BG (160×160) + `...72:2104;214:654` "Top Project" name
- `I6885:9035;72:2115;75:1549;81:2442` Award BG (160×160) — card thứ 3
- `6885:9043` Kudos Background (335×145) + `6885:9045` Kudos Logo (118×21)
- `I6885:9058;75:2164` Pen icon · `I6885:9058;75:2166` Kudos Logo icon (FAB)
- Header: logo homepage, VN flag, dropdown — tái dùng/khớp F001 nơi trùng
> Lưu ý độ phân giải @2x/@3x cho iOS; giữ tỉ lệ; nền trong suốt (PNG RGBA) hoặc SVG.

## 5. Yêu cầu chức năng (FR)
- FR1: Hiển thị Home đúng layout design (header cố định trên? — theo design header nằm
  đầu nội dung cuộn; bottom nav + FAB cố định). Cuộn dọc toàn trang.
- FR2: Countdown real-time tới ngày sự kiện, cập nhật mỗi giây (DAYS/HOURS/MINUTES).
  **MOCK (chưa có API):** ngày thật 26/12/2025 đã ở quá khứ. Cho tới khi có nguồn API/remote-config,
  countdown re-anchor về `now + 24h` mỗi lần mở app → mỗi launch bắt đầu lại ở ~24h và đếm lùi.
  Thay `CountdownController._resolveTarget()` bằng giá trị API khi có; phần còn lại giữ nguyên.
- FR3: Trạng thái elapsed (`isElapsed=true` → ẩn "Coming soon", hiển thị "đã kết thúc", days/hours/
  minutes = 0, không lỗi/âm) vẫn được giữ + test đầy đủ. Với mock 24h hiện tại nó không kích hoạt
  trong runtime bình thường, nhưng là path bắt buộc khi target thật (từ API) đã qua.
- FR4: Awards list — trạng thái loading / empty / error(+Retry) / data; cuộn ngang; "Chi tiết"
  → Award Detail (placeholder). Dữ liệu từ mock/stub repository (API thật defer).
- FR5: Kudos section feature-flag: `isKudosAvailable=true` → hiện; false → **ẩn hẳn** (không
  để placeholder). Banner lỗi ảnh → fallback placeholder.
- FR6: Notification bell badge: unread>0 → chấm đỏ; =0 → ẩn.
- FR7: FAB: pencil → WriteKudo (placeholder, **chống double-tap**); S/Kudos → Kudos feed (placeholder).
- FR8: Bottom nav 4 tab; SAA 2025 active (tô vàng); tap tab khác → màn tab placeholder tương ứng.
- FR9: Header actions: language switcher (tái dùng F001), search → Search (placeholder),
  bell → Notifications (placeholder).
- FR10: ABOUT AWARD/KUDOS → overview placeholder; Kudos "Chi tiết" → Kudos detail placeholder.
- FR11: Auth guard: chưa đăng nhập / session 401 → Login; 403 → Access Denied (placeholder).
- FR12: i18n — chuỗi UI tĩnh localized (tái dùng l10n F001, default VN); đổi ngôn ngữ re-render.

## 6. Yêu cầu phi chức năng (NFR)
- Clean Architecture: `features/home/{domain,data,presentation}`; tái dùng `core/*` của F001
  (router, theme, l10n, error). File < 200 dòng.
- State/DI: Riverpod. Routing: go_router — **chuyển Home placeholder hiện tại** thành Home thật;
  bottom nav nên dùng shell route (StatefulShellRoute) cho 4 tab.
- Pixel-perfect: dùng đúng asset + giá trị màu/typography từ MoMorph (lấy qua get_node).
- Test (iOS): unit + widget cho countdown, awards states, kudos flag, badge, FAB double-tap,
  nav routing → placeholder. Mock repository, không cần creds.
- Placeholder screens: 1 widget dùng chung (tên màn + "Coming soon/Chưa triển khai") cho mọi
  đích chưa định nghĩa, để dễ thay bằng màn thật sau.

## 7. Ánh xạ Test Case (32 TC) → FR (rút gọn)
- ACC_001/002/005/006 → FR1, FR11, FR8 · ACC_003(401→Login)/ACC_004(403→AccessDenied) → FR11
- GUI_001 → FR1 · GUI_002/003/004 (loading/empty/error) → FR4 · GUI_005 (Kudos ẩn) → FR5 · GUI_006 (badge) → FR6
- FUN_001/002 → FR2/FR3 · FUN_003 (retry) → FR4 · FUN_004 (Chi tiết award) → FR4 · FUN_005 (scroll ngang) → FR4
- FUN_006 (bell) → FR9 · FUN_007 (ABOUT AWARD)/008 (ABOUT KUDOS) → FR10 · FUN_009 (Kudos hiện)/010 (banner fallback)/011 (Kudos Chi tiết) → FR5/FR10
- FUN_012 (FAB pencil)/013 (double-tap)/014 (S/Kudos) → FR7 · FUN_015/016/017/018 (nav tabs) → FR8 · FUN_019 (lang)/020 (search) → FR9/FR12

## 8. Câu hỏi chưa chốt (defer, non-blocking)
- API thật cho awards/notifications/Kudos flag — hiện dùng mock/stub (không có spec API).
- Nội dung JA cho các đoạn mô tả dài — máy dịch, cần review người bản xứ.
- Hành vi countdown sau sự kiện: mặc định ẩn "Coming soon" + hiển thị "Sự kiện đã diễn ra"/0.
