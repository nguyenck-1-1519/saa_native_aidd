---
title: "F005 Secret Box — Open Secret Box reveal flow (Sun* Kudos)"
description: "Build the iOS Open-Secret-Box flow the Kudos feed stubs as coming-soon: a full-screen SecretBoxScreen with closed → opening → revealed states, a presentational reveal animation, and a data-driven reward. Local stub only. MoMorph two-track."
status: pending
priority: P2
effort: 11h
branch: main
work_type: feature
spec_draft: plans/260626-1536-f005-secret-box/spec/secret-box/
tags: [flutter, kudos, secret-box, momorph, feature]
created: 2026-06-26
builds_on: 260625-2309-kudos-remaining-screens
---

# F005 Secret Box — Open Secret Box reveal flow

Builds the reveal flow behind the Kudos feed's "Mở Secret Box" button (currently a coming-soon
stub: `kudos_screen.dart` `onOpenSecretBox: null` + `all_kudos_stats.dart` `_OpenSecretBoxButton`).
Tapping opens a full-screen `SecretBoxScreen` that walks closed → opening → revealed and shows a
reward (e.g. "1 áo phông SAA") from **local stub data** — no backend, consistent with F002–F004.

The 9 MoMorph screenIds collapse to **ONE screen + a `SecretBoxPhase` state machine** (the 7
"Standby" frames are data-driven reward variants, not screens) — mirrors the project's
N-screenIds=1-screen MoMorph pattern. MoMorph two-track: Track A (UI) runs parallel to Track B
(logic); INT is the only join. Executed later by `tkm:takumi`.

## MoMorph refs (fileKey 9ypp4enmFmdK3YAFJLIu6C — iOS)
- Closed/initial: `kQk65hSYF2` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/kQk65hSYF2
- Opening (action bấm mở): `KUmv414uC9` → .../screens/KUmv414uC9
- Revealed (7 standby reward variants): `_cWAEarZPi, wsI6gaO_yc, xptNUunBS_, -LIblaeusT, FvTOS7oCPU, IXpGakYRm5, scvV-OQCAJ`

## Phases

| # | Phase | Track | Status | Depends on |
|---|-------|-------|--------|------------|
| B1 | [Domain: SecretBox entity, reward, phase, repository, usecases](phase-B1-domain.md) | B | pending | — |
| B2 | [Data: stub repository + mock reward data](phase-B2-data.md) | B | pending | B1 |
| B3 | [Providers + controller (phase state machine) + l10n keys](phase-B3-providers-l10n.md) | B | pending | B2 |
| B4 | [Router: add secretBox route + Routes constant](phase-B4-router.md) | B | pending | B3 |
| A1 | [UI: SecretBoxScreen with closed/opening/revealed states](phase-A1-ui-secret-box.md) | A | pending | — |
| INT | [Integration: rewire feed button, bind controller, stats sync](phase-INT-integration.md) | A+B | pending | B3,B4,A1 |
| TEST | [Tests: open flow, reveal states, entry, no-overflow, i18n](phase-TEST-tests.md) | — | pending | INT |

**Track parallelism (MoMorph rule):** Track A (A1) has NO `blockedBy` on Track B (B1–B4). Both
run concurrently under `tkm:takumi`. INT is the only join point.

## Key dependencies
- B1→B2→B3→B4 chained (logic spine).
- A1 independent of Track B until INT.
- INT needs B3 (providers/controller), B4 (route), A1 (UI). TEST last, against integrated code.

## File ownership (no parallel-phase collisions)
- Track A owns `presentation/secret_box_screen.dart` (+ widgets).
- Track B owns `domain/*`, `data/*`, `presentation/providers/*`, `core/router/app_router.dart`.
- INT owns the wiring edits: `kudos_screen.dart`, `all_kudos_stats.dart` (button rewire), and
  the binding glue inside `secret_box_screen.dart` ↔ providers.
- Decision: place under **`lib/features/secret_box/{domain,data,presentation}`** — it is a distinct
  user flow with its own route and state machine; coupling to Kudos is only the entry button +
  stats counters, which INT bridges. Keeps Kudos module from growing past its already-large size.

## Out of scope (defer)
- Real backend / Supabase persistence of opened state (in-memory, session-scoped stub).
- Server-driven reward allocation, fairness / anti-fraud, redemption, sharing.
- Sound effects; haptics beyond one optional tap feedback.
- Non-iOS (web / large-screen) layouts.

## Spec
Draft at `spec/secret-box/secret-box.md` (FR1–FR9 + screen→state map + defer list). Promote to
`docs/features/F005_SecretBox/` and run `/tkm:rebuild-spec --features F005` after merge.
