# F005 Secret Box — minimal spec draft

> Spec draft authored at plan time. Promote to `docs/features/F005_SecretBox/`
> and run `/tkm:rebuild-spec --features F005` after merge.

**Feature code:** F005
**Builds on:** F004 Kudos feed (entry point) — `260625-2309-kudos-remaining-screens`
**Data:** local stub only (no backend / Supabase), consistent with F002–F004.

## Summary

From the Kudos feed's "ALL KUDOS" block, the user taps **"Mở Secret Box"**. This opens a
full-screen Secret Box screen showing a closed box. Tapping the box plays a reveal animation
(closed → opening → revealed) and shows the reward earned (e.g. "1 áo phông SAA"). After the
reveal the user can close back to the feed. The feed's "Secret Box đã/chưa mở" stats update.

## Functional requirements

- **FR1** Entry: the feed "Mở Secret Box" button (currently a coming-soon stub) navigates to a
  full-screen `secretBox` route (push, outside the tab shell — back returns to feed).
- **FR2** Closed state: screen renders the closed Secret Box (MoMorph `kQk65hSYF2`) with a
  prompt/CTA to open.
- **FR3** Opening state: tapping the box triggers a presentational reveal animation
  (MoMorph `KUmv414uC9` — "action bấm mở"). No external animation packages (Flutter built-ins).
- **FR4** Revealed state: after the animation, show the reward content — one of the 7 standby
  reward variants (`_cWAEarZPi, wsI6gaO_yc, xptNUunBS_, -LIblaeusT, FvTOS7oCPU, IXpGakYRm5,
  scvV-OQCAJ`). Reward chosen from stub data, NOT 7 separate screens.
- **FR5** Reward content (name, image/icon, descriptor) comes from stub data + design content.
- **FR6** Close: after reveal, user can dismiss the screen and return to the feed.
- **FR7** Stats reflection: on a successful open the feed's `secretBoxOpened` increments and
  `secretBoxUnopened` decrements (in-memory, session-scoped — no persistence).
- **FR8** Already-opened guard: if no unopened boxes remain, the entry button is disabled or the
  screen shows an "already opened / none left" state (decide at implement via design + stub).
- **FR9** i18n: all static labels via `AppLocalizations` (VN default / EN / JA). Reward names are
  DATA, not l10n keys.

## Screen → state mapping (MoMorph, fileKey 9ypp4enmFmdK3YAFJLIu6C)

ONE `SecretBoxScreen` with a `SecretBoxPhase` state machine, NOT 9 screens:

| Phase | MoMorph screenId(s) | Notes |
|-------|---------------------|-------|
| `closed` | `kQk65hSYF2` | initial; box shut, CTA to open |
| `opening` | `KUmv414uC9` | reveal animation in flight |
| `revealed` | `_cWAEarZPi, wsI6gaO_yc, xptNUunBS_, -LIblaeusT, FvTOS7oCPU, IXpGakYRm5, scvV-OQCAJ` | 7 reward variants = data-driven reveal states, not screens |

Confirm exact node mapping at implement-time via `momorph-implement-design`.

## Non-functional

- Files < 200 lines; Clean Architecture; Dart snake_case file names.
- Reveal animation presentational, 60fps target, no jank on iOS.
- Reuse `lib/features/kudos/` patterns, core widgets, HomeHeader, Riverpod, go_router.

## Deferred / out of scope

- Real backend / Supabase persistence of opened state (stays in-memory stub).
- Server-driven reward allocation, fairness/anti-fraud logic.
- Push/notification on reward, sharing the reward, reward redemption flow.
- Non-iOS (web / large-screen) layouts.
- Sound effects, haptics beyond a single optional tap feedback.
