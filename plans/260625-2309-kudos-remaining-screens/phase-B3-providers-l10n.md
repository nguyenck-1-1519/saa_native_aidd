# Phase B3 — Providers + controllers + l10n keys (Track B)

**Track:** B (logic) · **blockedBy:** B2 · **Status:** done · **Priority:** P2

## Context links
- Existing providers: `lib/features/kudos/presentation/providers/kudos_providers.dart`
- l10n: project arb files (VN default, EN, JA) — follow F004 keys

## Overview
Wire B2 data into Riverpod providers/controllers and add static l10n keys. Mirror existing
patterns (`AsyncNotifier` feed controller, `FutureProvider` stats).

## Requirements
- **Detail** — `kudoDetailProvider = FutureProvider.family<KudoDetail, String>((ref, id) => ...)`.
- **All Kudos + filter** — `feedFilterController` (StateNotifier/Notifier holding selected
  hashtag + department) + `allKudosProvider` (AsyncNotifier/FutureProvider that watches the
  filter and calls `getAllKudos`). Reuse for the feed screen's HIGHLIGHT filter dropdowns too.
- **Recipient search** — `recipientSearchController` (Notifier<AsyncValue<List<KudoRecipient>>>
  with a `query(String)` method, debounced) backing the WriteKudo recipient dropdown.
- **Filter options** — `hashtagOptionsProvider`, `departmentOptionsProvider` (FutureProvider).
- **l10n** — add static keys for: View kudo labels (Copy Link, hero tags), All Kudos title/empty,
  community-standards + rules body sections, search placeholder/empty. VN/EN/JA; default VN.
  Kudo content itself stays data (not l10n).
- Usecase providers for the 4 B1 usecases (mirror `getKudosFeedProvider`).

## Related code files
- Modify: `presentation/providers/kudos_providers.dart` (may split into
  `kudos_detail_providers.dart` / `kudos_filter_providers.dart` if >200 lines)
- Modify: arb/l10n files + regenerate

## Todo
- [x] Usecase providers (4)
- [x] kudoDetailProvider (family)
- [x] feedFilterController + allKudosProvider
- [x] recipientSearchController (debounced)
- [x] hashtag/department option providers
- [x] l10n keys (VN/EN/JA) + regen

## Success criteria
- `flutter analyze` clean; `flutter gen-l10n` succeeds; providers resolve without cycles; files <200 lines.

## Delivered
All providers + controllers wired; l10n keys (VN/EN/JA) added + regenerated; no cycles.

## Next
- B4 adds routes; INT binds these providers into Track A widgets.
