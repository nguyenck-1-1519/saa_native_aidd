# Phase B1 — Domain: enrich Kudo, KudoDetail, search/filter usecases (Track B)

**Track:** B (logic) · **blockedBy:** none · **Status:** done · **Priority:** P2

## Context links
- Existing entity: `lib/features/kudos/domain/entities/kudo.dart` (minimal feed card)
- Existing repo iface: `lib/features/kudos/domain/repositories/kudos_feed_repository.dart`
- Existing recipient: `lib/features/kudos/domain/entities/kudo_recipient.dart`

## Overview
Extend the domain so the new screens have real (stub-backed) data. Today `Kudo` only carries
feed-card fields; detail/all/search/filter need more. Keep Clean Architecture; files <200 lines.

## Requirements
- **Enrich for detail** — introduce `KudoDetail` (or extend `Kudo`) with: sender/recipient
  avatar url, hero tag (Rising/Legend/New/Super Hero enum), `isAnonymous`, `imageUrls`,
  `createdAt`/`timeRange`, full `message`, `hashtags`, `heartCount`, shareable `linkUrl`.
  Prefer a dedicated `KudoDetail` entity to avoid bloating the feed-card `Kudo` (KISS/DRY).
- **HeroTag** value object/enum reused by card + detail (DRY with existing `kudos_card_parts`).
- **Repo iface additions** (`KudosFeedRepository`): `Future<KudoDetail> getKudoById(String id)`,
  `Future<List<Kudo>> getAllKudos({String? hashtag, String? department})`.
- **Recipient search iface** — add `Future<List<KudoRecipient>> searchRecipients(String query)`
  to the write-kudo (or feed) repository; exclude self per F004 rule.
- **Filter options** — `Future<List<String>> getHashtags()` / `getDepartments()` for dropdowns.
- **Usecases** (one file each): `GetKudoById`, `GetAllKudos`, `SearchRecipients`,
  `GetFilterOptions`. Mirror existing usecase style (`get_kudos_feed.dart`).

## Related code files
- Create: `domain/entities/kudo_detail.dart`, `domain/value_objects/hero_tag.dart`,
  `domain/usecases/{get_kudo_by_id,get_all_kudos,search_recipients,get_filter_options}.dart`
- Modify: `domain/repositories/kudos_feed_repository.dart`,
  `domain/repositories/write_kudo_repository.dart`, `domain/entities/kudo.dart` (add `id` link/heroTag if needed)

## Todo
- [x] HeroTag enum/value object
- [x] KudoDetail entity (+ equality)
- [x] Repo iface methods (getKudoById, getAllKudos, searchRecipients, filter options)
- [x] 4 usecases

## Success criteria
- Compiles (`fvm flutter analyze`). No presentation imports in domain. Each file <200 lines.

## Security / NFR
- No PII beyond what design shows; anonymity enforced at entity level (`isAnonymous` masks sender).

## Delivered
KudoDetail + HeroTag + 4 usecases + repo ifaces wired; domain compiles clean.

## Next
- B2 implements these ifaces against stub data.
