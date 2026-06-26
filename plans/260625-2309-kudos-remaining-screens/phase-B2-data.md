# Phase B2 — Data: stub repos for detail/all + search + filter + static content (Track B)

**Track:** B (logic) · **blockedBy:** B1 · **Status:** done · **Priority:** P2

## Context links
- Existing stub/fake repos: `lib/features/kudos/data/repositories/*`
- Existing mock source: `lib/features/kudos/data/sources/kudos_mock_data.dart`

## Overview
Implement the B1 ifaces over **local stub data only** (no Supabase). Extend the existing
mock source; keep the stub+fake repo split already in place. Content for static screens lives
as constants/l10n, not a repo.

## Requirements
- **Detail data** — `getKudoById` returns a `KudoDetail` from an expanded mock list keyed by id;
  include at least one `isAnonymous: true` entry to feed A3. Card `Kudo.id` must map to a detail.
- **All Kudos** — `getAllKudos({hashtag, department})` returns the full mock list, filtered
  in-memory when args present (functional filter over stub).
- **Recipient search** — `searchRecipients(query)` filters a mock Sunner list case-insensitively
  (name/role), excludes current user; empty query → recent/suggested list.
- **Filter options** — `getHashtags()/getDepartments()` derive distinct values from the mock list.
- **Static content** — community-standards + rules copy extracted from design; store as l10n
  keys (wire in B3), not hardcoded in widgets.
- Update both `stub_*` and `fake_*` repo variants to satisfy new iface methods.

## Related code files
- Modify: `data/sources/kudos_mock_data.dart` (add detail records, sunner list, hashtags/depts),
  `data/repositories/stub_kudos_feed_repository.dart`, `fake_kudos_feed_repository.dart`,
  `stub_write_kudo_repository.dart`, `fake_write_kudo_repository.dart`
- Create (if mock grows >200 lines): `data/sources/kudos_detail_mock_data.dart`

## Todo
- [x] Detail mock records (incl. anonymous) + getKudoById
- [x] getAllKudos with in-memory hashtag/department filter
- [x] searchRecipients over mock Sunner list (exclude self)
- [x] getHashtags/getDepartments derivation
- [x] Static content strings staged for l10n

## Success criteria
- All B1 ifaces implemented in both stub + fake repos; `flutter analyze` clean; files <200 lines.
- Filter/search return correct subsets for sample queries (verified in TEST).

## Delivered
Stub + fake repos implement all B1 ifaces; mock data extended with detail/all/search/filter; kudos_detail_mock_data.dart created.

## Next
- B3 exposes these via providers/controllers.
