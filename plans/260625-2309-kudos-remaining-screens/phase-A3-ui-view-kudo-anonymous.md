# Phase A3 — UI: View kudo (anonymous) variant (Track A)

**Track:** A (UI) · **blockedBy:** none · **Status:** done

## MoMorph refs
- View kudo ẩn danh: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/5C2BL6GYXL
- Clarifications: see plan.md decisions (local stub, no backend)

## Goal
Anonymous variant of the detail screen — sender identity hidden (anonymous label/avatar),
rest identical to A2.

## Scope
- `momorph-implement-design` at runtime for `5C2BL6GYXL`, pixel-faithful.
- **Prefer one screen with an `isAnonymous` branch** over a duplicate file (DRY): drive the
  sender block from `KudoDetail.isAnonymous`. Build as the anonymous state of A2's widget.
- Mock data from design.

## Out of scope
- Anonymity data flag plumbing (B1) and routing → Track B + INT.
- Do NOT invent data; extract from Figma design.

## Integration contract (consumed at INT)
Same `KudoDetail` contract as A2; `isAnonymous == true` renders the masked sender block.

## Delivered
Anonymous variant integrated into ViewKudoScreen; sender block masked when `isAnonymous == true`.
