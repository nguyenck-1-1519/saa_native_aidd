---
title: "F004 Kudos follow-up — detail + all + content + functional search/filter (5 screens)"
description: "Build the remaining iOS Kudos screens MoMorph designs that the F004 MVP left unbuilt: View kudo, View kudo (anonymous), All Kudos, Tiêu chuẩn cộng đồng, Thể lệ — plus make recipient search & feed filters functional over local stub data. MoMorph two-track."
status: completed
priority: P2
effort: 18h
branch: main
work_type: feature
spec: docs/features/F004_Kudos/
spec_revision_needed: true
tags: [flutter, kudos, momorph, feature, follow-up]
created: 2026-06-25
builds_on: 260624-1003-kudos-screens
---

# F004 Kudos follow-up — remaining MoMorph screens

Completes the F004 Kudos feature. The MVP plan (`260624-1003-kudos-screens`, completed)
shipped only 2 of the ~14 iOS `Sun*Kudos_*` designs and stubbed search/filters. This plan
builds the 5 genuinely-missing screens and makes the deferred interactions functional over
**local stub data** (no backend wired — consistent with current MVP). Secret Box flow is
**out of scope → tracked separately as F005**.

Reuses `lib/features/kudos/{domain,data,presentation}` + core/shell/HomeHeader. MoMorph
two-track: Track A (UI, per-screen, runtime `momorph-implement-design`) runs parallel to
Track B (logic). Integration is the only join. Executed by `tkm:takumi --auto`.

## MoMorph refs (fileKey 9ypp4enmFmdK3YAFJLIu6C)
- All Kudos: `j_a2GQWKDJ` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/j_a2GQWKDJ
- View kudo: `T0TR16k0vH` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/T0TR16k0vH
- View kudo (ẩn danh): `5C2BL6GYXL` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/5C2BL6GYXL
- Tiêu chuẩn cộng đồng: `xms7csmDhD` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/xms7csmDhD
- Thể lệ: `b1Filzi9i6` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/b1Filzi9i6
- Recipient search (Track B ref): Search Sunner `3jgwke3E8O`, Searching `hldqjHoSRH`, dropdown người nhận `5MU728Tjck`
- Feed filters (Track B ref): dropdown hashtag `V5GRjAdJyb`, dropdown phòng ban `76k69LQPfj`

## Phases

| # | Phase | Track | Status | Depends on |
|---|-------|-------|--------|------------|
| B1 | [Domain: enrich Kudo, KudoDetail, search/filter usecases](phase-B1-domain.md) | B | done | — |
| B2 | [Data: stub detail/all + recipient search + filter + static content](phase-B2-data.md) | B | done | B1 |
| B3 | [Providers + controllers + l10n keys](phase-B3-providers-l10n.md) | B | done | B2 |
| B4 | [Router: un-retire detail, add all/content routes](phase-B4-router-rewire.md) | B | done | B3 |
| A1 | [UI: All Kudos screen](phase-A1-ui-all-kudos.md) | A | done | — |
| A2 | [UI: View kudo screen](phase-A2-ui-view-kudo.md) | A | done | — |
| A3 | [UI: View kudo (anonymous)](phase-A3-ui-view-kudo-anonymous.md) | A | done | — |
| A4 | [UI: Tiêu chuẩn cộng đồng (static)](phase-A4-ui-community-standards.md) | A | done | — |
| A5 | [UI: Thể lệ (static)](phase-A5-ui-rules.md) | A | done | — |
| INT | [Integration: wire UI ↔ providers/router, functional search/filter](phase-INT-integration.md) | A+B | done | B3,B4,A1–A5 |
| TEST | [Tests: detail nav, all-kudos list, search, filter, content render](phase-TEST-tests.md) | — | done | INT |

**Track parallelism (MoMorph rule):** Track A (A1–A5) has NO blockedBy on Track B (B1–B4).
Both run concurrently under `tkm:takumi`. INT is the only join point.

## Key dependencies
- B1→B2→B3→B4 chained (logic spine).
- A1–A5 independent until INT.
- INT needs B3 (providers), B4 (routes), A1–A5 (UI). TEST last, against integrated code.

## Spec delta (revise docs/features/F004_Kudos before/at implement)
New FRs to add: FR9 View kudo detail (sender/recipient avatar+hero-tag, full message, images,
hearts, copy-link); FR10 View kudo anonymous variant (hide sender identity); FR11 All Kudos
paginated list + filter; FR12 functional recipient search over stub list; FR13 functional
hashtag/department feed filter; FR14 static content screens (community standards, rules).
Run `/tkm:rebuild-spec --features F004` after merge to refresh the 4-file spec set.

## Out of scope (defer)
- **Secret Box flow → separate plan F005** (~10 states: Open secret box + Standby variants).
- Real backend/Supabase (stays local stub), real rich-text, real image upload, real @mention.
- Non-iOS `Sun* Kudos - Live board` (web/large-screen).

## Completion
Delivered 2026-06-26: 5 screens + 4 domain usecases + providers + routes + integration + 270 tests green; all H1+M4 review fixes applied; on `feat/kudos-remaining-screens`.
