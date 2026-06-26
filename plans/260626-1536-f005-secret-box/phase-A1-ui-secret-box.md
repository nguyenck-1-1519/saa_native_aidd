# Phase A1 — UI: SecretBoxScreen (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** pending

## MoMorph refs (fileKey 9ypp4enmFmdK3YAFJLIu6C)
- Closed: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/kQk65hSYF2
- Opening: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/KUmv414uC9
- Revealed (7 reward variants): _cWAEarZPi, wsI6gaO_yc, xptNUunBS_, -LIblaeusT, FvTOS7oCPU, IXpGakYRm5, scvV-OQCAJ
- Clarifications: see plan.md (local stub, ONE screen + phase state machine, no backend)

## Goal
Build ONE full-screen `SecretBoxScreen` with `closed → opening → revealed` visual states + a
presentational reveal animation (Flutter built-ins, no external packages).

## Scope
- Use `momorph-implement-design` at runtime to code the 3 phases pixel-faithful; the 7 standby
  frames are data-driven reward variants — render from a reward prop, NOT 7 widgets.
- Mock data from Figma design content; reward image falls back (styled text / Material icon) when
  the S3 asset URL is null. Reuse HomeHeader, frame bg `#00101A`, gold `#FFEA9E`, Montserrat.
- New file(s): `lib/features/secret_box/presentation/secret_box_screen.dart` (+ widgets if >200 lines).

## Out of scope
- Provider/repo wiring, the route builder swap, feed-button rewire, stats sync → Track B + INT.
- Do NOT invent data; extract from Figma design.

## Integration contract (consumed at INT)
Screen takes `phase` (closed/opening/revealed) + `reward?`; exposes `onOpen` (tap box) and
`onClose` (dismiss) callbacks for INT to bind to `SecretBoxController`. No-overflow at 375px.
