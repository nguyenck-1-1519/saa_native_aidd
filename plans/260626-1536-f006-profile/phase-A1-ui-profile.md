# Phase A1 — UI: ProfileScreen (self + other via isSelf)

**Track A (UI). No blockedBy. Runtime: `momorph-implement-design`. Status: done.**

Delivered: ProfileScreen + 13 widgets (header, stats, awards, recent-kudos, feedback, social sections); isSelf branch routes logic to edit/settings affordances. Pixel-faithful to MoMorph designs; mock data from Figma content. H1 filter fix, H2 awards render, H3 k-suffix resolved.

## MoMorph refs
- Profile bản thân (self):  `hSH7L8doXB` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
- Profile người khác (other): `bEpdheM0yU` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU
- Clarifications: plans/260626-1536-f006-profile/spec/profile/profile-spec-draft.md

## Goal
One presentational `ProfileScreen` with an `isSelf` bool: self shows edit/settings affordances,
other hides them. Sections: header (avatar/name/role/department), stats, awards/danh hiệu, recent
kudos received. Pixel-faithful to both designs; mock data from Figma content only (do NOT invent).

## Out of scope
- Providers, stub data, routing, real identity (Track B + INT own these).
- Edit-profile submission, settings contents, social actions (see defer list).
- Backend / persistence.

## Integration contract (consumed by INT)
- `ProfileScreen` takes a single view-model/props bundle + `isSelf` + callbacks
  (`onEditProfile?`, `onOpenSettings?`, `onTapRecentKudo(id)`, `onBack?` for other-profile push).
- Avatar null → grey placeholder (keep F003/F004 pattern).
- Report back: files created, component tree, exact prop/VM interface each section expects.
