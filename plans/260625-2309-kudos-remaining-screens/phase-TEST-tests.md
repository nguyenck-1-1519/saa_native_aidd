# Phase TEST — Tests: detail, all-kudos, search, filter, content

**Track:** — · **blockedBy:** INT · **Status:** done · **Priority:** P2

## Context links
- Existing kudos tests (F004): mirror their structure/mocks
- Run on iOS, offline, mock data only (no real backend)

## Overview
Test the integrated remaining-screens code — the same code reviewed & merged. No fake passes.

## Requirements (test cases)
- **Domain/data**: `getKudoById` returns correct detail incl. anonymous record;
  `getAllKudos` filters by hashtag and by department (and combined); `searchRecipients`
  case-insensitive, excludes self, empty-query → suggestions; hashtag/department options distinct.
- **Providers**: `kudoDetailProvider` loading→data→error; `feedFilterController` updates
  `allKudosProvider` output; `recipientSearchController` debounce + results.
- **Widget/nav**: View kudo renders all blocks; anonymous variant masks sender identity;
  All Kudos list renders + filter dropdown changes list; feed "Xem chi tiết"→detail route,
  "View all"→all route; WriteKudo recipient search picks a recipient; "Tiêu chuẩn cộng đồng"
  link→content screen; content screens render static copy (VN) + back pops.
- **Regression/UX**: no overflow at design widths; loading/empty/error states present;
  l10n keys resolve in VN/EN/JA.

## Todo
- [x] Domain/data unit tests (detail, filter, search, options)
- [x] Provider tests (detail family, filter controller, search controller)
- [x] Widget + navigation tests (view kudo, anonymous, all kudos, content, links)
- [x] Overflow + i18n + states checks

## Success criteria
- All tests pass against final integrated code; coverage on new domain/data/providers high;
  `fvm flutter test` green. No skipped/xfail to force green.

## Delivered
270 tests green; domain/data/provider/widget/nav/i18n/states all passing; no flakes.

## Next
- Hand to `reviewer`; update docs/features/F004_Kudos + run `/tkm:rebuild-spec --features F004`.
