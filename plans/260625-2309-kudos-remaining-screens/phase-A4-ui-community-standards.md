# Phase A4 — UI: Tiêu chuẩn cộng đồng (static content) (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** done

## MoMorph refs
- Tiêu chuẩn cộng đồng: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/xms7csmDhD
- Clarifications: see plan.md decisions (static render)

## Goal
Build the community-standards content screen (target of WriteKudo form's "Tiêu chuẩn
cộng đồng" link, currently a placeholder).

## Scope
- `momorph-implement-design` at runtime for `xms7csmDhD`, pixel-faithful.
- Static scrollable content: AppBar + back, headings/body text from design.
- Text content is **mock data from design**, surfaced via l10n keys (B3) — render only.
- New file: `lib/features/kudos/presentation/community_standards_screen.dart`.

## Out of scope
- Routing + link rewire from form → Track B (B4) + INT.
- Do NOT invent copy; extract from Figma design.

## Integration contract (consumed at INT)
Stateless content screen; "back" pops to WriteKudoScreen. Route `/kudos/community-standards`.

## Delivered
CommunityStandardsScreen built from Figma; static content rendered via l10n keys.
