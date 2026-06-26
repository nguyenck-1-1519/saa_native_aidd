# Phase 02 — NotFoundScreen UI (Track A)

**Track:** A (UI) · **Status:** pending · **Depends on:** none · runs parallel to Phase 01.
**File ownership:** `lib/features/system/presentation/not_found_screen.dart` (create).

## MoMorph refs
- Not Found (404): https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/sn2mdavs1a
- Clarifications: plans/260626-1536-f008-system-screens/spec/system-screens/spec.md

## Goal
Static 404 screen from Figma: illustration + message + one CTA button. Stateless. Mock
content/illustration straight from the design — do NOT invent data.

## Contract (consumed by Phase 03)
- `class NotFoundScreen extends StatelessWidget` — `const NotFoundScreen({super.key})`.
- Keep widget pure: take `onPrimaryAction` + `primaryLabel` so Phase 03 supplies the
  auth-aware target. Use ARB keys (Phase 03 adds them).
- Must construct cleanly inside go_router `errorBuilder` (no required runtime args
  beyond what Phase 03 supplies).

## Out of scope
- Router `errorBuilder` wiring, i18n key creation, auth logic, tests (Phase 03/04).
- Any data/domain layer.
