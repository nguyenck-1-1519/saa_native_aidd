---
feature_id: F004
title: Sun* Kudos — Kudos feed + Viết Kudo + 5 màn bổ sung (SAA 2025)
lang: vi
platform: iOS (Flutter) — Android sau
fileKey: 9ypp4enmFmdK3YAFJLIu6C
momorph_screens:
  - Sun*Kudos (tab/feed): fO0Kt19sZZ
  - Viết Kudo (form): 7fFAb-K35a
  - All Kudos list: j_a2GQWKDJ
  - View Kudo detail: T0TR16k0vH
  - View Kudo detail (anonymous): 5C2BL6GYXL
  - Community Standards: xms7csmDhD
  - Thể lệ rules: b1Filzi9i6
status: implemented (local stub — no real backend)
depends_on: F002 Home + F003 Awards (đã xong; tái dùng HomeHeader, shell nav, l10n, core)
---

# F004 — Sun* Kudos (feed) + Viết Kudo (form)

## 1. Mục tiêu
2 màn: (A) **KudosScreen** = tab "Kudos" (feed) ; (B) **WriteKudoScreen** = form tạo Kudo.
Thay các placeholder /kudos, /kudos-detail, /kudos-feed, /write-kudo, /about-kudos.

> Hand-off (`--auto`); **link vào màn sẵn có**; **cắt ảnh tuyệt đối chính xác**.

## 2. Màn A — KudosScreen (tab Kudos) — screenId fO0Kt19sZZ
Cuộn dọc, nền #00101A + key-visual. Các khối (từ design):
1. Header (tái dùng `HomeHeader`).
2. KV banner "Hệ thống ghi nhận và cảm ơn" + logo KUDOS (reuse asset).
3. Prompt "Hôm nay, bạn muốn gửi kudos đến ai?" (icon bút) → mở **WriteKudoScreen**.
4. HIGHLIGHT KUDOS: 2 dropdown lọc (Hashtag, Phòng ban) + carousel kudos card (◀ ▶, "2/5") — card: 2 avatar+tên+CECV+tag(Rising/Legend Hero), thời gian, tiêu đề, nội dung, #hashtags, ❤count, "Copy Link", "Xem chi tiết".
5. SPOTLIGHT BOARD: ảnh word-cloud "388 KUDOS" (asset — cắt chính xác).
6. ALL KUDOS: stats (Kudos nhận/gửi, tim nhận ×2 streak, Secret Box đã/chưa mở) + nút "Mở Secret Box".
7. "10 SUNNER NHẬN QUÀ MỚI NHẤT": list avatar + tên + "Nhận được 1 áo phông SAA".
8. List kudos card gần đây + "View all Kudos".
9. Bottom nav (Kudos active — đã có shell).
> Spec đầy đủ (nhiều item) — Track A forge gọi download_specs(fO0Kt19sZZ)+get_node để lấy chi tiết/màu/asset.

## 3. Màn B — WriteKudoScreen (form) — screenId 7fFAb-K35a (28 item, đã đọc)
AppBar "New Kudo" + back (◀). Card form "Gửi lời cám ơn và ghi nhận đến đồng đội":
- **Người nhận*** (B.2 dropdown search "Tìm kiếm") — required; lỗi nếu trống / chọn chính mình.
- **Danh hiệu*** (B.4 text, ≤100) — required; placeholder "Danh tặng một danh hiệu cho...".
- Link "Tiêu chuẩn cộng đồng" (B.5) → community standards (placeholder).
- **Toolbar định dạng** (C: Bold/Italic/Strike/Number/Link/Quote) — **visual** (YAGNI: không rich-text thật).
- **Message*** (D text, ≤1000) — required, non-whitespace; placeholder + hint "@ + tên để nhắc đồng nghiệp".
- **Hashtag*** (E, 1–5) — chip add/remove, nút "+ Hashtag (Tối đa 5)"; required.
- **Image** (F, 0–5, optional) — thumbnail row + "+ Image (Tối đa 5)"; **presentational** (không thêm image_picker dep — hiển thị mock/placeholder, đếm cục bộ).
- **Anonymous** (G checkbox, default off) "Gửi lời cám ơn và ghi nhận ẩn danh".
- **Huỷ** (H) → pop (confirm nếu có nội dung — optional). **Gửi đi** (I) → validate required (recipient/title/message/hashtag) → success snackbar → pop. (Submit = stub, no real API.)
- DB (tham khảo): table `kudos` {recipient_id, title, message, tags[], image_ids[], is_anonymous}.

## 4. FR
- FR1: KudosScreen render đúng design; cuộn; stats + carousel + spotlight + recent + cards.
- FR2: "Hôm nay..." prompt + FAB pencil → WriteKudoScreen.
- FR3: WriteKudoScreen form đủ field + validation (recipient/title≤100/message≤1000 non-ws/hashtag 1–5); ảnh optional ≤5.
- FR4: Gửi đi → validate; lỗi hiển thị inline/snackbar; hợp lệ → success → pop. Huỷ → pop.
- FR5: Hashtag chip add/remove ≤5; Anonymous toggle.
- FR6: Dữ liệu feed/stats/recent từ stub repository (content từ design; chưa có API).
- FR7: Trạng thái loading/empty/error cho feed (giữ pattern Home/Awards).
- FR8: i18n nhãn tĩnh (VN/EN/JA, default VN); nội dung kudo = data.
- FR9: ViewKudoScreen hiển thị kudo detail đầy đủ (người gửi/nhận, tag, hashtag, nội dung); biến thể anonymous che tên người gửi (`is_anonymous=true` → hiển thị "Ẩn danh").
- FR10: AllKudosScreen liệt kê toàn bộ kudos (`/kudos/all`); cuộn; empty/loading/error states.
- FR11: Feed hashtag filter + department filter hoạt động thực sự (local stub data; debounced); KudosScreen "View all"→AllKudosScreen.
- FR12: Recipient search trong WriteKudo hoạt động thực sự: debounced, loại trừ chính mình, kết quả từ local stub `searchRecipients`.
- FR13: CommunityStandardsScreen (`/kudos/community-standards`) — màn nội dung tĩnh, link từ WriteKudo form.
- FR14: KudosRulesScreen (`/kudos/rules`) — màn nội dung tĩnh Thể lệ.

## 5. Link vào màn sẵn có
- Bottom nav tab **Kudos** → KudosScreen (thay placeholder).
- `/kudos-detail`, `/kudos-feed` → KudosScreen (gộp; retire placeholder); `/about-kudos` → KudosScreen.
- `/write-kudo` → WriteKudoScreen (thay placeholder).
- Home FAB pencil → /write-kudo; FAB S/Kudos → Kudos tab; Home `KudosSection` "Chi tiết" → Kudos tab.
- Awards `KudosSection` "Chi tiết" → Kudos tab; Home "ABOUT KUDOS" → Kudos tab.
- KudosScreen "View all Kudos" → AllKudosScreen (`/kudos/all`).
- Feed card "Xem chi tiết" → ViewKudoScreen (`/kudos/detail/:id`).
- WriteKudo "Tiêu chuẩn cộng đồng" link → CommunityStandardsScreen (`/kudos/community-standards`).

## 5a. Screen List (F004)

| Screen | Route | Class | MoMorph screenId |
|---|---|---|---|
| KudosScreen | `/kudos` | `KudosScreen` | fO0Kt19sZZ |
| WriteKudoScreen | `/write-kudo` | `WriteKudoScreen` | 7fFAb-K35a |
| AllKudosScreen | `/kudos/all` | `AllKudosRouteWrapper` → `AllKudosScreen` | j_a2GQWKDJ |
| ViewKudoScreen | `/kudos/detail/:id` | `ViewKudoScreen` | T0TR16k0vH (standard), 5C2BL6GYXL (anonymous) |
| CommunityStandardsScreen | `/kudos/community-standards` | `CommunityStandardsScreen` | xms7csmDhD |
| KudosRulesScreen | `/kudos/rules` | `KudosRulesScreen` | b1Filzi9i6 |

## 6. Assets cắt chính xác (forge-time, không tự vẽ)
- Spotlight board "388 KUDOS" word-cloud image; KV KUDOS logo (reuse Logo_Kudos.svg nếu trùng); Secret Box icon; streak ×2 icon; card decorations. get_media_files/get_figma_image; null S3 → fallback.

## 7. NFR
- Clean Architecture: `features/kudos/{domain,data,presentation}`; tái dùng core + HomeHeader/shell. File <200 dòng.
- Riverpod: kudosFeedController (AsyncValue), kudosStatsProvider, writeKudoFormController (form state + validation). Routing: shell Kudos branch → KudosScreen; /write-kudo full-screen push.
- Test (iOS): form validation (required/maxlen/hashtag count), Gửi đi success→pop, Huỷ→pop, feed states, nav links, no overflow. Mock, offline.

## 8. Defer (non-blocking)
- Rich-text thật, @mention thật, image upload thật — stub/visual cho MVP.
- **Secret Box flow → F005** (carved out; không nằm trong F004 scope).
- Real backend API (submit kudo, feed/stats, recipient search, filters) — tất cả đang dùng local stub data.
