# Phase A2 — UI: View kudo screen (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** done

## MoMorph refs
- View kudo: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/T0TR16k0vH
- Clarifications: see plan.md decisions (local stub, no backend)

## Goal
Build the single-kudo detail screen (target of feed/all "Xem chi tiết") — sender + recipient
blocks (avatar, name, CECV/role, hero tag), time, title, full message, #hashtags, image grid,
heart count, "Copy Link".

## Scope
- `momorph-implement-design` at runtime for `T0TR16k0vH`, pixel-faithful.
- Reuse hero-tag chip / avatar parts from `kudos_card_parts.dart` where they match.
- New file: `lib/features/kudos/presentation/view_kudo_screen.dart` (+ widgets if >200 lines).
- Mock data from design; image grid presentational (placeholders, no real upload).

## Out of scope
- `getKudoById` repo/provider, routing, real copy-link clipboard → Track B + INT.
- Do NOT invent data; extract from Figma design.

## Integration contract (consumed at INT)
Screen takes one enriched `KudoDetail` (B1) by id; "Copy Link" → callback; "back" pops.

## Delivered
ViewKudoScreen built from Figma; all detail blocks (sender, recipient, tags, hearts, copy-link) rendered.
