# Phase INT — Integration: wrapper, router rewire, other-profile entry

**Single join. blockedBy: A1, B3.** Connects Track A UI to Track B providers + routing.

## Context Links
- Wrapper pattern: `lib/core/router/kudos_route_wrappers.dart` (`.when` loading/error/data → maps domain → VM)
- Router: `lib/core/router/app_router.dart` (branch 3 = Profile; standalone routes section)
- A1 contract: phase-A1-ui-profile.md (props/VM + `isSelf` + callbacks)
- B3 providers: `profileProvider(userId)`, `currentUserIdProvider`

## Overview
- Priority: P2 · Status: pending
- Replace branch-3 `PlaceholderScreen` with a self-profile wrapper; add `/profile/:userId` for other
  profiles; map `ProfileData` → A1's VM/props; wire other-profile entry from kudo sender/recipient taps.

## Key Insights
- **File ownership:** INT owns `app_router.dart` and a new `profile_route_wrappers.dart`. It also edits
  `view_kudo_screen` (or kudo card) ONLY to add the other-profile tap callback — minimal, additive.
- `isSelf` is decided in the wrapper: `userId == currentUserIdProvider` → true. Self route passes
  `currentUserId`; `/profile/:userId` passes the path param.
- Self profile stays **inside the shell** (branch 3, keeps bottom nav). Other profile is a **full-screen
  push outside the shell** (`context.push('/profile/$id')`, back returns to caller) — mirrors writeKudo/kudoDetail.
- Recent-kudo tap → `context.push(Routes.kudoDetailPath(id))` (reuse F004 route, no new route).

## Requirements
- FR1 Profile tab renders self `ProfileScreen` with edit/settings affordances (isSelf=true).
- FR2 `/profile/:userId` renders other `ProfileScreen` (isSelf=false, affordances hidden, back arrow).
- FR3 Other-profile entry wired from ≥1 kudo sender/recipient tap where feasible.
- FR4 Loading/error/empty states via `.when` (retry invalidates `profileProvider`).

## Architecture / Data flow
```
branch 3  → SelfProfileRouteWrapper  → profileProvider(currentUserId) → .when → ProfileScreen(isSelf: true)
/profile/:userId → OtherProfileRouteWrapper(id) → profileProvider(id) → .when → ProfileScreen(isSelf: false)
ProfileScreen.onTapRecentKudo(kudoId) → context.push(kudoDetailPath(kudoId))
view_kudo / kudo card  onTapSender/Recipient(userId) → context.push('/profile/$userId')
```

## Related Code Files
- Create: `lib/core/router/profile_route_wrappers.dart` (Self + Other wrappers, maps ProfileData → VM)
- Modify: `lib/core/router/app_router.dart` — add `Routes.profileUser` + `profileUserPath(id)`; swap branch-3 builder; register `/profile/:userId` standalone route (literal `/profile` matches before `:userId` — no shadow, same pattern as kudoDetail note).
- Modify: `lib/features/kudos/presentation/view_kudo_screen.dart` (and/or kudo card) — add optional `onTapUser` callback wired to other-profile push.
- Read: A1 ProfileScreen + B3 providers.

## Implementation Steps
1. Add `Routes.profileUser = '/profile'` base + `static String profileUserPath(String id) => '$profileUser/$id';` (reuse existing `profile` const for the tab; the `:userId` route is the standalone variant). Confirm no collision with branch-3 literal at route registration.
2. `SelfProfileRouteWrapper` (ConsumerWidget): read `currentUserIdProvider`; guard null; watch `profileProvider(id)`; `.when` → `ProfileScreen(isSelf: true, onEditProfile/onOpenSettings: stub callbacks, onTapRecentKudo: push detail)`.
3. `OtherProfileRouteWrapper(id)`: watch `profileProvider(id)`; `isSelf: id == currentUserId`; affordances hidden; `onBack: context.pop`.
4. Swap branch-3 builder `PlaceholderScreen` → `const SelfProfileRouteWrapper()`.
5. Register standalone `GoRoute('/profile/:userId')` in the outside-shell section.
6. Wire kudo sender/recipient tap → `context.push(Routes.profileUserPath(userId))`. Map kudo VM's user id (or, if `KudoDetail` lacks a stable userId, fall back to name-keyed lookup in stub — flag as TODO(backend)).

## Todo List
- [ ] profile_route_wrappers.dart (Self + Other)
- [ ] app_router.dart: route + path helper + branch-3 swap + standalone route
- [ ] view_kudo / card: other-profile tap callback
- [ ] ProfileData → VM mapping matches A1 interface

## Success Criteria
- Profile tab shows self data with affordances; bottom nav intact. `/profile/:userId` shows other data, no affordances, back works. Tapping a recent kudo opens its detail. Tapping a kudo's user opens that user's profile. `fvm flutter analyze` clean.

## Risk Assessment
- **High — route shadowing:** `/profile` (tab, in-shell) vs `/profile/:userId` (standalone). Mitigation: literal segment matches before param (proven by kudoDetail comment in app_router.dart); verify with a nav test in TEST. Countermove if it collides: namespace other profiles under `/user/:userId`.
- Med — A1 VM mismatch: A1 reported interface may differ from B1 `ProfileData`. Mitigation: wrapper is the adapter layer (same role as ViewKudoRouteWrapper) — reshape mapping, do not touch A1 or B1.
- Med — kudo has no stable userId for sender/recipient: mitigation: name-keyed stub lookup + TODO(backend); other-profile entry is "where feasible" per scope.

## Rollback
- Revert `app_router.dart` branch-3 to `PlaceholderScreen` and drop the standalone route + wrapper file
  + the kudo callback edit. Three localized, additive changes — clean revert, no data migration (stub only).

## Security Considerations
- Other-profile shows public display data only. Profile remains behind auth redirect (router gate unchanged).

## Next Steps
- Unblocks TEST.
