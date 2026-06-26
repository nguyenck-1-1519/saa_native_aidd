# Phase B4 — Router: add secretBox route (Track B)

**Track:** B (logic) · **blockedBy:** B3 · **Status:** done (folded into INT)

**Delivered:** `Routes.secretBox = '/secret-box'`; standalone GoRoute (full-screen push, no bottom nav); builder → `SecretBoxScreen()`; back returns to feed; analyze clean. (Note: router edit folded into INT phase for cohesion; outcome identical.)

## Context Links
- File: `lib/core/router/app_router.dart` (Routes constants + standalone push routes)
- Pattern ref: the `/write-kudo` GoRoute (full-screen push, outside the tab shell)

## Overview
- **Priority:** P2 · **Status:** pending
- Add a `secretBox` route as a full-screen push outside the StatefulShellRoute (no bottom nav),
  exactly like `/write-kudo` — so back returns to the Kudos feed.

## Key Insights
- The screen widget lives in Track A (`SecretBoxScreen`). To keep tracks parallel, B4 references
  the screen by an agreed class name + import path (the integration contract); if A1 has not
  landed when B4 runs, B4 may temporarily point the route at `PlaceholderScreen(title:'Secret Box')`
  and INT swaps it — mirrors the codebase's placeholder-then-swap convention.

## Requirements
- **Functional:** `Routes.secretBox = '/secret-box'`; a `GoRoute` under standalone destinations.
- **Non-functional:** preserve the existing auth redirect byte-for-byte; analyze clean.

## Architecture
Data flow: feed button → `context.push(Routes.secretBox)` → full-screen `SecretBoxScreen` →
back pops to feed. Screen reads `SecretBoxController` (B3) for its state.

## Related Code Files
**Modify:**
- `lib/core/router/app_router.dart` — add `Routes.secretBox` const + a standalone `GoRoute`
  (placeholder builder if A1 not yet merged; INT finalizes to `const SecretBoxScreen()`).

**Create / Delete:** none.

## Implementation Steps
1. Add `static const secretBox = '/secret-box';` to `Routes`.
2. Add a `GoRoute(path: Routes.secretBox, builder: …)` in the standalone-destinations block
   (next to `/write-kudo`).
3. Builder: placeholder now, real screen at INT.

## Todo List
- [ ] Routes.secretBox constant
- [ ] GoRoute (placeholder builder)

## Success Criteria
- `fvm flutter analyze` clean; navigating to `/secret-box` pushes a full-screen page with a
  working system back to feed.

## Risk Assessment
- **Low:** route shadowing. `/secret-box` is a unique literal — no conflict with `/kudos/*`.

## Security Considerations
- Route sits behind the same auth redirect as all in-app routes (logged-in only). No new surface.

## Next Steps
- Unblocks INT (final builder swap + button rewire).
