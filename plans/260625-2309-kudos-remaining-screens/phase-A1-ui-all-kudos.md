# Phase A1 — UI: All Kudos screen (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** done

## MoMorph refs
- All Kudos: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/j_a2GQWKDJ
- Clarifications: see plan.md decisions (local stub, no backend)

## Goal
Build the full "All Kudos" list screen (target of feed's "View all Kudos") — scrollable list
of kudos cards with the hashtag + department filter dropdowns at top.

## Scope
- Use `momorph-implement-design` at runtime to code `j_a2GQWKDJ` pixel-faithful.
- Reuse existing `KudosCard` / `kudos_card_parts.dart` widgets where they match design.
- Mock data from design content; filter dropdowns presentational here (functional wiring = INT).
- New file(s): `lib/features/kudos/presentation/all_kudos_screen.dart` (+ widgets if >200 lines).

## Out of scope
- Provider/repo wiring, real filter logic, routing → Track B + INT.
- Do NOT invent data; extract from Figma design.

## Integration contract (consumed at INT)
Screen takes a `List<Kudo>` + selected hashtag/department filters; "back" pops to feed.
Exposes filter-change callbacks for INT to bind to `feedFilterController`.

## Delivered
AllKudosScreen built from Figma; filter UI presentational; wired in INT.
