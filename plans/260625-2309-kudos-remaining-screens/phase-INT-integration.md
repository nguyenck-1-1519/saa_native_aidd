# Phase INT — Integration: wire UI ↔ providers/router, functional search/filter

**Track:** A+B (join) · **blockedBy:** B3, B4, A1, A2, A3, A4, A5 · **Status:** done · **Priority:** P2

## Context links
- Track A screens (A1–A5), Track B providers (B3), routes (B4)
- Existing feed screen: `lib/features/kudos/presentation/kudos_screen.dart`
- Existing write form: `lib/features/kudos/presentation/write_kudo_screen.dart`

## Overview
The only join point. Replace Track A mock props with B3 providers; bind navigation to B4 routes;
make the previously-stubbed interactions functional over stub data.

## Requirements
- **View kudo** — `/kudos/:id` reads `kudoDetailProvider(id)`; render loading/error/data; A3
  anonymous branch driven by `KudoDetail.isAnonymous`. "Copy Link" → clipboard + snackbar.
- **All Kudos** — bind list to `allKudosProvider`; top dropdowns → `feedFilterController`;
  list reacts to filter changes (functional, in-memory).
- **Feed screen rewire** — HIGHLIGHT filter dropdowns (hashtag/phòng ban) → same
  `feedFilterController` (make functional, retire presentational stub); card "Xem chi tiết" →
  push `/kudos/:id`; "View all Kudos" → push `/kudos/all`.
- **WriteKudo rewire** — recipient dropdown → `recipientSearchController` (functional search,
  exclude self, validation already in F004); "Tiêu chuẩn cộng đồng" link → `/kudos/community-standards`.
- **Rules entry point** — wire whichever design link opens Thể lệ → `/kudos/rules` (confirm from
  design link map at this step).
- Keep loading/empty/error states consistent with Home/Awards/F004 pattern.

## Related code files
- Modify: A1–A5 new screens (swap mock → providers), `kudos_screen.dart`,
  `write_kudo_screen.dart`, relevant widgets (`highlight_kudos_carousel.dart`,
  `kudos_card.dart`, recipient dropdown widget)

## Todo
- [x] ViewKudo bound to detail provider (+ anonymous branch + copy-link)
- [x] AllKudos bound to allKudosProvider + filter controller
- [x] Feed: functional filters + card→detail + view-all→all nav
- [x] WriteKudo: functional recipient search + community-standards link
- [x] Rules entry-point wired
- [x] No overflow; states consistent

## Success criteria
- End-to-end nav works on iOS sim; search/filter return correct results; anonymous masks sender;
  `flutter analyze` clean; no overflow at design widths.

## Delivered
UI ↔ providers/router wired; functional search + filter + nav; no overflow; states consistent.

## Next
- TEST validates the integrated flows.
