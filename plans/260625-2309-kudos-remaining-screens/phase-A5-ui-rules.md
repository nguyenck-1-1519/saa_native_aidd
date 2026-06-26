# Phase A5 — UI: Thể lệ (static content) (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** done

## MoMorph refs
- Thể lệ: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/b1Filzi9i6
- Clarifications: see plan.md decisions (static render)

## Goal
Build the Kudos "Thể lệ" (rules) content screen.

## Scope
- `momorph-implement-design` at runtime for `b1Filzi9i6`, pixel-faithful.
- Static scrollable content: AppBar + back, sections/body from design.
- Text = mock data from design via l10n keys (B3) — render only.
- New file: `lib/features/kudos/presentation/kudos_rules_screen.dart`.

## Out of scope
- Routing + the entry-point link (confirm at INT which screen links here) → Track B (B4) + INT.
- Do NOT invent copy; extract from Figma design.

## Integration contract (consumed at INT)
Stateless content screen; "back" pops. Route `/kudos/rules`. INT confirms entry point
(feed/about-kudos area) from design link map.

## Delivered
KudosRulesScreen built from Figma; static content rendered via l10n keys.
