---
feature_id: F003
title: Màn hình Awards (Hệ thống giải thưởng) — SAA 2025
lang: vi
platform: iOS (Flutter) — Android sau
screen: "[iOS] Award_* (Awards tab — 1 screen, dropdown 5 giải)"
fileKey: 9ypp4enmFmdK3YAFJLIu6C
momorph_screens:
  - Top Talent: c-QM3_zjkG
  - Top Project Leader: QQvsfK3yaK
  - Best Manager: 7y195PPTxQ
  - Signature 2025 - Creator: O98TwiHaJe
  - MVP: b2BuS8HYIt
status: draft
depends_on: F002 (Home — đã xong; tái dùng header, KudosSection, bottom-nav shell, router)
---

# F003 — Màn hình Awards / Chi tiết giải thưởng (SAA 2025)

## 1. Phát hiện then chốt
5 screenId "Award_X" KHÔNG phải 5 màn riêng — chúng là **một màn Awards (tab "Awards")**
với **dropdown chọn loại giải**. Mỗi screenId = một trạng thái dropdown. → Triển khai
**MỘT** `AwardsScreen` + dropdown 5 giải + 5 bộ dữ liệu. (DRY)

## 2. Mục tiêu
Màn "Hệ thống giải thưởng SAA 2025" (tab Awards): chọn loại giải qua dropdown, xem chi tiết
(huy hiệu, mô tả, số lượng, giá trị). Thay placeholder `/awards` hiện tại.

> Yêu cầu người dùng: hand-off (`--auto`), **link các màn này vào màn sẵn có**, **cắt/lấy ảnh
> tuyệt đối chính xác** (5 huy hiệu giải + KV Kudos banner).

## 3. Bố cục (chung mọi giải — từ design, 2 frame đối chiếu Top Talent + MVP)
1. Header (mms_1) — logo + language switcher + search + bell+badge → **tái dùng `HomeHeader`**.
2. Kudos KV banner (mms_A) — "Hệ thống ghi nhận và cảm ơn" + logo KUDOS (ảnh) — tĩnh.
3. Award highlight header (mms_B) — phụ "Sun* Annual Awards 2025" + tiêu đề "Hệ thống giải thưởng SAA 2025" + **dropdown chọn giải** (giá trị = giải đang chọn) + artwork nền.
4. Award info (mms_2.3) — huy hiệu tròn (ảnh/giải) + icon+tên giải + mô tả + "Số lượng giải thưởng" (số + đơn vị) + "Giá trị giải thưởng" (số tiền + ghi chú).
5. Sun* Kudos block (mms_2.4) — "Phong trào ghi nhận" + "Sun* Kudos" + banner + "ĐIỂM MỚI CỦA SAA 2025" + mô tả + "Chi tiết" → /kudos-detail. **Tái dùng `KudosSection`**.
6. Bottom nav (mms_3) — tab "Awards" active. **Đã có** (shell StatefulShellRoute, F002).

## 4. 5 giải (dropdown) — dữ liệu từ design
| id | Tên (dropdown) | screenId | Số lượng | Giá trị |
|----|----------------|----------|----------|---------|
| top-talent | Top Talent | c-QM3_zjkG | 10 Cá nhân | 7.000.000 VNĐ / mỗi giải |
| top-project-leader | Top Project Leader | QQvsfK3yaK | (forge fetch) | (forge fetch) |
| best-manager | Best Manager | 7y195PPTxQ | (forge fetch) | (forge fetch) |
| signature-creator | Signature 2025 - Creator | O98TwiHaJe | (forge fetch) | (forge fetch) |
| mvp | MVP (Most Valuable Person) | b2BuS8HYIt | 01 Cá nhân | 15.000.000 VNĐ / giải cá nhân |
> Top Talent + MVP nội dung đã có ở trên. 3 giải còn lại: takumi forge **download_specs + get_frame**
> mỗi screenId để lấy tên/mô tả/số lượng/giá trị + **huy hiệu (asset)** CHÍNH XÁC.

## 5. Assets cần cắt CHÍNH XÁC (forge-time, KHÔNG tự vẽ)
- 5 huy hiệu giải (badge graphic mỗi giải, vd "TOP TALENT"/"MVP" — node mms_C2.1.3 / award image mỗi screenId) qua `get_media_files`/`get_figma_image`.
- KV Kudos banner (mms_A logo KUDOS) — có thể trùng asset Home; tái dùng nếu giống.
- Artwork nền highlight (nếu khác Home keyvisual) — tái dùng `Keyvisual_BG` nếu giống.
- Kudos banner trong block 5 — tái dùng asset Home (`Sunkudos_banner.png`).

## 6. Yêu cầu chức năng (FR)
- FR1: AwardsScreen render đúng layout design (cuộn dọc; header + nav cố định theo shell).
- FR2: Dropdown liệt kê đúng 5 giải; chọn → cập nhật huy hiệu + tên + mô tả + số lượng + giá trị (read-only, đổi theo lựa chọn).
- FR3: Thay placeholder tab `/awards` bằng AwardsScreen; tab Awards active (đã có shell).
- FR4: **Link từ Home**: carousel "Chi tiết"(awardId) → tab Awards với giải đó được chọn sẵn; "ABOUT AWARD" → tab Awards (giải mặc định / đầu danh sách).
- FR5: Kudos "Chi tiết" → /kudos-detail (placeholder, đã có).
- FR6: Dữ liệu giải từ stub repository (5 giải, nội dung+asset từ design; chưa có API thật).
- FR7: Trạng thái: loading/empty/error nếu nguồn dữ liệu không sẵn (giữ pattern Home awards).
- FR8: i18n — nhãn tĩnh ("Số lượng giải thưởng", "Giá trị giải thưởng", tiêu đề mục, nav) localized; tên/mô tả giải là DỮ LIỆU (VN, từ design), không phải l10n key.

## 7. NFR
- Clean Architecture: feature mới `features/awards/{domain,data,presentation}`; tái dùng `core/*` + (tái dùng/trích xuất) `HomeHeader`, `KudosSection`. Cân nhắc trích `HomeHeader`/`KudosSection` ra shared nếu coupling features/home↔features/awards không mong muốn (planner quyết; KISS: import lại được chấp nhận).
- Riverpod: `selectedAwardProvider`, `awardsDetailControllerProvider`. Routing: shell branch `/awards` (đã có) → AwardsScreen. Deep-link chọn giải: set provider trước `goBranch` hoặc query param (planner quyết).
- Pixel-perfect: màu/typography/asset từ MoMorph (get_node). File < 200 dòng.
- Test (iOS): dropdown đổi giải → đổi nội dung; link Home→Awards chọn đúng giải; 5 giải có dữ liệu; render mọi giải không overflow. Mock repo, offline.

## 8. Ánh xạ "link màn sẵn có"
- Home `awards_carousel.onDetail(id)` (hiện → /award-detail placeholder) → đổi: chuyển sang tab Awards + chọn giải `id`.
- Home `HeroCountdown.onAboutAward` (hiện → /about-award) → đổi: sang tab Awards.
- Bottom-nav tab "Awards" → AwardsScreen (thay PlaceholderScreen).
- `/award-detail` route placeholder: có thể bỏ hoặc giữ làm alias chuyển vào Awards (planner quyết).

## 9. Câu hỏi chưa chốt (defer, non-blocking)
- 3 giải (Top Project Leader / Best Manager / Signature Creator): nội dung+asset lấy ở forge.
- Dropdown đóng/mở UI: dùng dropdown/popup giống design (planner/forge quyết chi tiết).
- API thật cho danh sách giải — hiện stub.
