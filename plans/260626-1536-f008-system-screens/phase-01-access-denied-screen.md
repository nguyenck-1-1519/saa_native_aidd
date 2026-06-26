# Phase 01 — AccessDeniedScreen UI (Track A)

**Track:** A (UI) · **Status:** pending · **Depends on:** none · runs parallel to Phase 02.
**File ownership:** `lib/features/system/presentation/access_denied_screen.dart` (create).

## MoMorph refs
- Access Denied (403): https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/k-7zJk2B7s
- Clarifications: plans/260626-1536-f008-system-screens/spec/system-screens/spec.md

## Goal
Static 403 screen from Figma: illustration + message + one CTA button. Stateless. Mock
content/illustration straight from the design — do NOT invent data.

## Contract (consumed by Phase 03)
- `class AccessDeniedScreen extends StatelessWidget` — `const AccessDeniedScreen({super.key})`.
- CTA `onPressed` deferred: expose `final VoidCallback? onGoBack;` ctor param OR read auth in
  Phase 03 wrapper. Recommended: keep widget pure → take `onPrimaryAction` + `primaryLabel`
  so Phase 03 supplies auth-aware target. Use ARB keys (Phase 03 adds them).

## Out of scope
- Router registration, i18n key creation, auth logic, tests (all Phase 03/04).
- Any data/domain layer.
